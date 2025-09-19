# AIO Elastic Download Script

An all-in-one script for downloading and backing up Elastic artifacts, including Elasticsearch packages, Elastic Defend security artifacts, and centralized Logstash pipelines.

---

## Scripts Overview

### 1. **Elastic_Artifacts_Registry_Download_v1.1**
- Targets **Windows** and **RedHat Linux (x86_64)** related files from Elastic.
- Designed for selective downloads from Elastic Artifacts Registry.

### 2. **Elastic_Artifacts_Registry_Download_v1**
- Downloads **full-fledged artifacts** from Elastic.
- Ideal for complete offline setups or full registry mirroring.

### 3. **Backup_Logstash_Pipeline_v1**
- Backs up centralized Logstash pipelines via API calls.
- Useful for disaster recovery or migration purposes.

---

## Prerequisites for `Backup_Logstash_Pipeline_v1`

Before using the script, you need to create an **API key** with permissions to manage Logstash pipelines.

### Steps to Create API Key in Kibana Dev Tools

1. Open **Kibana** and navigate to **Dev Tools**.
2. Make a `POST` request:

```json
POST /_security/api_key
{
  "name": "logstash_pipeline_backup_key",
  "role_descriptors": {
    "logstash_pipeline_role": {
      "cluster": ["manage_logstash_pipelines"]
    }
  }
}
