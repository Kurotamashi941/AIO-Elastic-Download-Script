#!/bin/bash

# --- Config ---
ES_HOST="https://<Elastic_node_to_be_changed>:9200"
API_KEY="<API_key_to_be_changed>"
LOG_FILE="./pipeline_backup.log"
BASE_DIR="$(pwd)/logstash_backup"

# --- Logging function ---
log() {
    local msg="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $msg" | tee -a "$LOG_FILE"
}

# --- Ensure backup folders exist ---
mkdir -p "$BASE_DIR/api_logstash_pipeline"
mkdir -p "$BASE_DIR/config_logstash_pipeline"

# --- Curl Elasticsearch for pipelines ---
log "Fetching pipelines from Elasticsearch..."
response=$(curl -s -X GET -H "Authorization: ApiKey $API_KEY" "$ES_HOST/_logstash/pipeline")

if [[ -z "$response" || "$response" == "{}" ]]; then
    log "No pipelines found or request failed."
    exit 1
fi
log "Pipelines fetched successfully."

# --- Process pipelines with jq ---
echo "$response" | jq -r 'to_entries[] | @base64' | while read entry; do
    _jq() {
        echo "$entry" | base64 --decode | jq -r "$1"
    }

    name=$(_jq '.key')
    # Create the "PUT" command style for API file
    api_file="$BASE_DIR/api_logstash_pipeline/api_${name}.json"
    config_file="$BASE_DIR/config_logstash_pipeline/config_${name}.conf"

    {
        echo "PUT _logstash/pipeline/${name}"
        _jq '.value'
    } > "$api_file"

    # Extract pipeline field only
    _jq '.value.pipeline' > "$config_file"

    log "Saved pipeline '$name' → $api_file and $config_file"
done

log "Pipeline backup completed. Files stored under $BASE_DIR"

