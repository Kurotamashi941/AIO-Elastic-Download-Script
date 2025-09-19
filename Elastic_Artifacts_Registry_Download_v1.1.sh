#!/bin/bash
export SCRIPTBASE="`dirname \"$0\"`" 
#export LOGFILE="${SCRIPTBASE}/artefacts_`date +"%d%m%y"`-`hostname`.log"
export LOGFILE="/var/log/artefacts_`date +"%d%m%y"`-`hostname`.log"
timestamp() {
	date +"%F %T"
}
log_msg_blue() { 
	#red
	echo -e  "\e[44m[ $(timestamp) ] $1  \e[0m"
}

#Global Variable
esversion=""
BASE_DIR=""

# Function to handle SIGINT (Ctrl+C)
cleanup() {
  echo -e "\nScript interrupted. Cleaning up..." | tee -a $LOGFILE
  exit 1
}

Main(){
###
### Script starting
###
echo "BY RUNNING THIS SCRIPT YOU AGREED TO THIS TERMS AND CONDITION, THIS SCRIPT BEARS NO WARRENTY" 
echo "TO ANY DAMAGE OR MISCONFIGURE OR LOST, USER IS TO USE THIS SCRIPT ON YOUR OWN RISK."

# Provide version number before asking for user confirmation
read -r -p "Enter the desired Elasticsearch version (e.g., 8.6.1): " esversion
echo "[ $(timestamp) ] You have selected version $esversion" | tee -a $LOGFILE

# Ask for the download path
read -r -p "Enter the path where you want to store the download base url (e.g., /var): " BASE_DIR
echo "[ $(timestamp) ] Download path (Base_URL): $BASE_DIR" | tee -a $LOGFILE

# Ask for confirmation to download all packages automatically
read -r -p "Automatic Mode - Downloading all packages into this machine? [Y/n]" response
case $response in 
  [yY][eE][sS]|[yY])
    # Automatic Mode - Proceed with the tasks
    for i in {1..5}
    do
      task_${i}
    done
    ;;
  *)
    # Otherwise exit...
    echo "[ $(timestamp) ] Exiting without downloading the packages." | tee -a $LOGFILE
    exit 1
    ;;
esac

echo "Ended..." 
exit
}

task_1(){
log_msg_blue "Removing existing packages and Creating directory" 

echo "Removing $BASE_DIR/downloads*"
# Remove $BASE_DIR/downloads*
rm -rf $BASE_DIR/downloads*

echo "Creating respective directories"
# Create respective directories
mkdir -p $BASE_DIR/downloads-$esversion/apm-server/
mkdir -p $BASE_DIR/downloads-$esversion/beats/agentbeat/
mkdir -p $BASE_DIR/downloads-$esversion/beats/auditbeat/
mkdir -p $BASE_DIR/downloads-$esversion/beats/beats-dashboards/
mkdir -p $BASE_DIR/downloads-$esversion/beats/elastic-agent/
mkdir -p $BASE_DIR/downloads-$esversion/beats/filebeat/
mkdir -p $BASE_DIR/downloads-$esversion/beats/functionbeat/
mkdir -p $BASE_DIR/downloads-$esversion/beats/heartbeat/
mkdir -p $BASE_DIR/downloads-$esversion/beats/metricbeat/
mkdir -p $BASE_DIR/downloads-$esversion/beats/osquerybeat/
mkdir -p $BASE_DIR/downloads-$esversion/beats/packetbeat/
mkdir -p $BASE_DIR/downloads-$esversion/beats/winlogbeat/
mkdir -p $BASE_DIR/downloads-$esversion/cloud-defend/
mkdir -p $BASE_DIR/downloads-$esversion/cloudbeat/
mkdir -p $BASE_DIR/downloads-$esversion/connectors/
mkdir -p $BASE_DIR/downloads-$esversion/elastic-agent-core/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-hadoop/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-icu/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-kuromoji/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-nori/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-phonetic/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-smartcn/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-stempel/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-ukrainian/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/discovery-azure-classic/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/discovery-ec2/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/discovery-gce/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/mapper-annotated-text/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/mapper-murmur3/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/mapper-size/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/repository-hdfs/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch-plugins/store-smb/
mkdir -p $BASE_DIR/downloads-$esversion/elasticsearch/
mkdir -p $BASE_DIR/downloads-$esversion/endpoint-dev/
mkdir -p $BASE_DIR/downloads-$esversion/enterprise-search/
mkdir -p $BASE_DIR/downloads-$esversion/fleet-server/
mkdir -p $BASE_DIR/downloads-$esversion/kibana/
mkdir -p $BASE_DIR/downloads-$esversion/logstash/
mkdir -p $BASE_DIR/downloads-$esversion/prodfiler/

chmod -R 755 $BASE_DIR/downloads-$esversion
chown -R root:root $BASE_DIR/downloads-$esversion

echo "[ $(timestamp) ] All respective directories has been created." | tee -a $LOGFILE

}

task_2(){
log_msg_blue "Downloading Endpoint Security artifacts" 

cd $BASE_DIR

echo "[ $(timestamp) ] Downloading Endpoint Security artifacts for version $esversion" | tee -a $LOGFILE
# Download Elastic Agent Security artifacts
export ENDPOINT_VERSION=$esversion && wget -P downloads/endpoint/manifest https://artifacts.security.elastic.co/downloads/endpoint/manifest/artifacts-$ENDPOINT_VERSION.zip && zcat -q downloads/endpoint/manifest/artifacts-$ENDPOINT_VERSION.zip | jq -r '.artifacts | to_entries[] | .value.relative_url' | xargs -I@ curl "https://artifacts.security.elastic.co@" --create-dirs -o ".@"

#Move downloaded Endpoint Security Artifacts to $BASE_DIR/downloads-$esversion/
mv $BASE_DIR/downloads/endpoint $BASE_DIR/downloads-$esversion/

#Remove the Elastic security artifacts
rm -rf $BASE_DIR/downloads 

echo "[ $(timestamp) ] Endpoint Security artifacts : $esversion downloaded complete" | tee -a $LOGFILE

}

task_3(){
log_msg_blue "Downloading Elastic Artifacts Registry" 

cd $BASE_DIR

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/apm-server/apm-server-$esversion-x86_64.rpm.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry APM-Server : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/agentbeat/agentbeat-$esversion-windows-x86_64.zip.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-$esversion-x86_64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-oss-$esversion-x86_64.rpm.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Auditbeat : $esversion downloaded complete" | tee -a $LOGFILE

curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/beats-dashboards/beats-dashboards-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/beats-dashboards/beats-dashboards-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/beats-dashboards/beats-dashboards-$esversion.zip.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Beats-Dashboard : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$esversion-x86_64.rpm.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Elastic-Agent : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$esversion-x86_64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-$esversion-x86_64.rpm.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Filebeat : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/functionbeat/functionbeat-$esversion-windows-x86_64.zip.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Functionbeat : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-$esversion-x86_64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-oss-$esversion-x86_64.rpm.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Heartbeat : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-$esversion-x86_64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-oss-$esversion-x86_64.rpm.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Metricbeat : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/osquerybeat/osquerybeat-$esversion-windows-x86_64.zip.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Osquerybeat : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-$esversion-x86_64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-oss-$esversion-x86_64.rpm.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Packetbeat : $esversion downloaded complete" | tee -a $LOGFILE

curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-oss-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-oss-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-oss-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-oss-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-oss-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-oss-$esversion-windows-x86_64.zip.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Winlogbeat : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/cloud-defend/cloud-defend-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/cloud-defend/cloud-defend-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/cloud-defend/cloud-defend-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/cloud-defend/cloud-defend-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/cloud-defend/cloud-defend-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/cloud-defend/cloud-defend-$esversion-linux-x86_64.tar.gz.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Cloud-Defend : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/cloudbeat/cloudbeat-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/cloudbeat/cloudbeat-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/cloudbeat/cloudbeat-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/cloudbeat/cloudbeat-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/cloudbeat/cloudbeat-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/cloudbeat/cloudbeat-$esversion-linux-x86_64.tar.gz.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Cloudbeat : $esversion downloaded complete" | tee -a $LOGFILE

curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/connectors/connectors-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/connectors/connectors-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/connectors/connectors-$esversion.zip.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Connectors : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elastic-agent-core/elastic-agent-core-$esversion-windows-x86_64.zip.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Elastic-Agent-Core : $esversion downloaded complete" | tee -a $LOGFILE

curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-hadoop/elasticsearch-hadoop-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-hadoop/elasticsearch-hadoop-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-hadoop/elasticsearch-hadoop-$esversion.zip.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Elasticsearch-Hadoop : $esversion downloaded complete" | tee -a $LOGFILE

curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-icu/analysis-icu-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-icu/analysis-icu-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-icu/analysis-icu-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-kuromoji/analysis-kuromoji-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-kuromoji/analysis-kuromoji-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-kuromoji/analysis-kuromoji-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-nori/analysis-nori-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-nori/analysis-nori-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-nori/analysis-nori-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-phonetic/analysis-phonetic-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-phonetic/analysis-phonetic-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-phonetic/analysis-phonetic-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-smartcn/analysis-smartcn-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-smartcn/analysis-smartcn-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-smartcn/analysis-smartcn-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-stempel/analysis-stempel-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-stempel/analysis-stempel-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-stempel/analysis-stempel-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-ukrainian/analysis-ukrainian-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-ukrainian/analysis-ukrainian-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-ukrainian/analysis-ukrainian-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/discovery-azure-classic/discovery-azure-classic-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/discovery-azure-classic/discovery-azure-classic-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/discovery-azure-classic/discovery-azure-classic-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/discovery-ec2/discovery-ec2-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/discovery-ec2/discovery-ec2-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/discovery-ec2/discovery-ec2-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/discovery-gce/discovery-gce-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/discovery-gce/discovery-gce-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/discovery-gce/discovery-gce-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/mapper-annotated-text/mapper-annotated-text-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/mapper-annotated-text/mapper-annotated-text-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/mapper-annotated-text/mapper-annotated-text-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/mapper-murmur3/mapper-murmur3-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/mapper-murmur3/mapper-murmur3-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/mapper-murmur3/mapper-murmur3-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/mapper-size/mapper-size-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/mapper-size/mapper-size-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/mapper-size/mapper-size-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/repository-hdfs/repository-hdfs-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/repository-hdfs/repository-hdfs-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/repository-hdfs/repository-hdfs-$esversion.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/store-smb/store-smb-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/store-smb/store-smb-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch-plugins/store-smb/store-smb-$esversion.zip.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Elasticsearch-Plugins : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-linux-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-linux-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-linux-aarch64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$esversion-x86_64.rpm.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-jdbc-$esversion.taco
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-jdbc-$esversion.taco.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-jdbc-$esversion.taco.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/esodbc-$esversion-windows-x86.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/esodbc-$esversion-windows-x86.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/esodbc-$esversion-windows-x86.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/esodbc-$esversion-windows-x86_64.msi
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/esodbc-$esversion-windows-x86_64.msi.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/esodbc-$esversion-windows-x86_64.msi.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/rest-resources-zip-$esversion.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/rest-resources-zip-$esversion.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/elasticsearch/rest-resources-zip-$esversion.zip.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Elasticsearch : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-darwin-universal.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-darwin-universal.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-darwin-universal.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/endpoint-dev/endpoint-security-$esversion-windows-x86_64.zip.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Endpoint-Dev : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion.deb.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion.rpm.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/enterprise-search/enterprise-search-$esversion.tar.gz.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Enterprise-Search : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/fleet-server/fleet-server-$esversion-windows-x86_64.zip.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Fleet-Server : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-linux-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-linux-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-linux-aarch64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/kibana/kibana-$esversion-x86_64.rpm.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Kibana : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-linux-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-linux-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-linux-aarch64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-linux-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-no-jdk.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-no-jdk.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-no-jdk.deb.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-no-jdk.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-no-jdk.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-no-jdk.rpm.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-no-jdk.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-no-jdk.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-no-jdk.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-no-jdk.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-no-jdk.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-no-jdk.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-$esversion-x86_64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-darwin-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-darwin-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-darwin-aarch64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-darwin-x86_64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-darwin-x86_64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-darwin-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-linux-aarch64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-linux-aarch64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-linux-aarch64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-linux-x86_64.tar.gz.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-no-jdk.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-no-jdk.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-no-jdk.deb.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-no-jdk.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-no-jdk.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-no-jdk.rpm.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-no-jdk.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-no-jdk.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-no-jdk.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-no-jdk.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-no-jdk.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-no-jdk.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-windows-x86_64.zip
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-windows-x86_64.zip.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-windows-x86_64.zip.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-$esversion-x86_64.rpm.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Logstash : $esversion downloaded complete" | tee -a $LOGFILE

# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-collector-$esversion-x86_64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-elastic-symbolizer-$esversion-x86_64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-aarch64.rpm
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-aarch64.rpm.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-aarch64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-amd64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-amd64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-amd64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-arm64.deb
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-arm64.deb.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-arm64.deb.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-linux-x86_64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-x86_64.rpm
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-x86_64.rpm.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/pf-host-agent-$esversion-x86_64.rpm.sha512
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/symbtool-$esversion-linux-arm64.tar.gz
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/symbtool-$esversion-linux-arm64.tar.gz.asc
# curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/symbtool-$esversion-linux-arm64.tar.gz.sha512
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/symbtool-$esversion-linux-x86_64.tar.gz
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/symbtool-$esversion-linux-x86_64.tar.gz.asc
curl --retry-connrefused --retry 5 -O https://artifacts.elastic.co/downloads/prodfiler/symbtool-$esversion-linux-x86_64.tar.gz.sha512
echo "[ $(timestamp) ] Elastic Artifacts Registry Prodfiler : $esversion downloaded complete" | tee -a $LOGFILE

}

task_4(){
log_msg_blue "Downloading Elastic Package Registry" 

cd $BASE_DIR

echo "[ $(timestamp) ] Downloading Elastic Package Registry for version $esversion" | tee -a $LOGFILE
# Downloading Elastic Package Registry
export TMPDIR=$BASE_DIR
podman pull docker.elastic.co/package-registry/distribution:$esversion
podman save -o package-$esversion.tar docker.elastic.co/package-registry/distribution:$esversion

#Move downloaded EPR Image to $BASE_DIR/downloads-$esversion/
mv package-$esversion.tar $BASE_DIR/downloads-$esversion/package-$esversion.tar

echo "[ $(timestamp) ] Elastic Package Registry : $esversion downloaded complete" | tee -a $LOGFILE

}
task_5(){
log_msg_blue "Move downloaded package to respective directories" 

cd $BASE_DIR

# mv apm-server-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-aarch64.rpm
# mv apm-server-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-aarch64.rpm.asc
# mv apm-server-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-aarch64.rpm.sha512
# mv apm-server-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-amd64.deb
# mv apm-server-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-amd64.deb.asc
# mv apm-server-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-amd64.deb.sha512
# mv apm-server-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-arm64.deb
# mv apm-server-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-arm64.deb.asc
# mv apm-server-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-arm64.deb.sha512
# mv apm-server-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-darwin-x86_64.tar.gz
# mv apm-server-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-darwin-x86_64.tar.gz.asc
# mv apm-server-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-darwin-x86_64.tar.gz.sha512
# mv apm-server-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-linux-arm64.tar.gz
# mv apm-server-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-linux-arm64.tar.gz.asc
# mv apm-server-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-linux-arm64.tar.gz.sha512
mv apm-server-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-linux-x86_64.tar.gz
mv apm-server-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-linux-x86_64.tar.gz.asc
mv apm-server-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-linux-x86_64.tar.gz.sha512
mv apm-server-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-windows-x86_64.zip
mv apm-server-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-windows-x86_64.zip.asc
mv apm-server-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-windows-x86_64.zip.sha512
mv apm-server-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-x86_64.rpm
mv apm-server-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-x86_64.rpm.asc
mv apm-server-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/apm-server/apm-server-$esversion-x86_64.rpm.sha512
# mv agentbeat-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-darwin-aarch64.tar.gz
# mv agentbeat-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-darwin-aarch64.tar.gz.asc
# mv agentbeat-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-darwin-aarch64.tar.gz.sha512
# mv agentbeat-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-darwin-x86_64.tar.gz
# mv agentbeat-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-darwin-x86_64.tar.gz.asc
# mv agentbeat-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-darwin-x86_64.tar.gz.sha512
# mv agentbeat-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-linux-arm64.tar.gz
# mv agentbeat-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-linux-arm64.tar.gz.asc
# mv agentbeat-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-linux-arm64.tar.gz.sha512
mv agentbeat-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-linux-x86_64.tar.gz
mv agentbeat-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-linux-x86_64.tar.gz.asc
mv agentbeat-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-linux-x86_64.tar.gz.sha512
mv agentbeat-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-windows-x86_64.zip
mv agentbeat-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-windows-x86_64.zip.asc
mv agentbeat-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/agentbeat/agentbeat-$esversion-windows-x86_64.zip.sha512
# mv auditbeat-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-aarch64.rpm
# mv auditbeat-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-aarch64.rpm.asc
# mv auditbeat-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-aarch64.rpm.sha512
# mv auditbeat-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-amd64.deb
# mv auditbeat-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-amd64.deb.asc
# mv auditbeat-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-amd64.deb.sha512
# mv auditbeat-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-arm64.deb
# mv auditbeat-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-arm64.deb.asc
# mv auditbeat-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-arm64.deb.sha512
# mv auditbeat-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-darwin-aarch64.tar.gz
# mv auditbeat-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-darwin-aarch64.tar.gz.asc
# mv auditbeat-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-darwin-aarch64.tar.gz.sha512
# mv auditbeat-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-darwin-x86_64.tar.gz
# mv auditbeat-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-darwin-x86_64.tar.gz.asc
# mv auditbeat-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-darwin-x86_64.tar.gz.sha512
# mv auditbeat-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-linux-arm64.tar.gz
# mv auditbeat-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-linux-arm64.tar.gz.asc
# mv auditbeat-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-linux-arm64.tar.gz.sha512
mv auditbeat-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-linux-x86_64.tar.gz
mv auditbeat-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-linux-x86_64.tar.gz.asc
mv auditbeat-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-linux-x86_64.tar.gz.sha512
mv auditbeat-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-windows-x86_64.msi
mv auditbeat-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-windows-x86_64.msi.asc
mv auditbeat-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-windows-x86_64.msi.sha512
mv auditbeat-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-windows-x86_64.zip
mv auditbeat-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-windows-x86_64.zip.asc
mv auditbeat-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-windows-x86_64.zip.sha512
mv auditbeat-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-x86_64.rpm
mv auditbeat-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-x86_64.rpm.asc
mv auditbeat-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-$esversion-x86_64.rpm.sha512
# mv auditbeat-oss-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-aarch64.rpm
# mv auditbeat-oss-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-aarch64.rpm.asc
# mv auditbeat-oss-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-aarch64.rpm.sha512
# mv auditbeat-oss-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-amd64.deb
# mv auditbeat-oss-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-amd64.deb.asc
# mv auditbeat-oss-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-amd64.deb.sha512
# mv auditbeat-oss-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-arm64.deb
# mv auditbeat-oss-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-arm64.deb.asc
# mv auditbeat-oss-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-arm64.deb.sha512
# mv auditbeat-oss-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-darwin-x86_64.tar.gz
# mv auditbeat-oss-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-darwin-x86_64.tar.gz.asc
# mv auditbeat-oss-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-darwin-x86_64.tar.gz.sha512
# mv auditbeat-oss-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-linux-arm64.tar.gz
# mv auditbeat-oss-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-linux-arm64.tar.gz.asc
# mv auditbeat-oss-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-linux-arm64.tar.gz.sha512
mv auditbeat-oss-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-linux-x86_64.tar.gz
mv auditbeat-oss-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-linux-x86_64.tar.gz.asc
mv auditbeat-oss-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-linux-x86_64.tar.gz.sha512
mv auditbeat-oss-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-windows-x86_64.msi
mv auditbeat-oss-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-windows-x86_64.msi.asc
mv auditbeat-oss-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-windows-x86_64.msi.sha512
mv auditbeat-oss-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-windows-x86_64.zip
mv auditbeat-oss-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-windows-x86_64.zip.asc
mv auditbeat-oss-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-windows-x86_64.zip.sha512
mv auditbeat-oss-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-x86_64.rpm
mv auditbeat-oss-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-x86_64.rpm.asc
mv auditbeat-oss-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/auditbeat/auditbeat-oss-$esversion-x86_64.rpm.sha512
mv beats-dashboards-$esversion.zip $BASE_DIR/downloads-$esversion/beats/beats-dashboards/beats-dashboards-$esversion.zip
mv beats-dashboards-$esversion.zip.asc $BASE_DIR/downloads-$esversion/beats/beats-dashboards/beats-dashboards-$esversion.zip.asc
mv beats-dashboards-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/beats/beats-dashboards/beats-dashboards-$esversion.zip.sha512
# mv elastic-agent-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-aarch64.rpm
# mv elastic-agent-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-aarch64.rpm.asc
# mv elastic-agent-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-aarch64.rpm.sha512
# mv elastic-agent-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-amd64.deb
# mv elastic-agent-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-amd64.deb.asc
# mv elastic-agent-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-amd64.deb.sha512
# mv elastic-agent-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-arm64.deb
# mv elastic-agent-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-arm64.deb.asc
# mv elastic-agent-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-arm64.deb.sha512
# mv elastic-agent-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-darwin-aarch64.tar.gz
# mv elastic-agent-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-darwin-aarch64.tar.gz.asc
# mv elastic-agent-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-darwin-aarch64.tar.gz.sha512
# mv elastic-agent-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-darwin-x86_64.tar.gz
# mv elastic-agent-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-darwin-x86_64.tar.gz.asc
# mv elastic-agent-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-darwin-x86_64.tar.gz.sha512
# mv elastic-agent-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-linux-arm64.tar.gz
# mv elastic-agent-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-linux-arm64.tar.gz.asc
# mv elastic-agent-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-linux-arm64.tar.gz.sha512
mv elastic-agent-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-linux-x86_64.tar.gz
mv elastic-agent-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-linux-x86_64.tar.gz.asc
mv elastic-agent-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-linux-x86_64.tar.gz.sha512
mv elastic-agent-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-windows-x86_64.msi
mv elastic-agent-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-windows-x86_64.msi.asc
mv elastic-agent-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-windows-x86_64.msi.sha512
mv elastic-agent-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-windows-x86_64.zip
mv elastic-agent-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-windows-x86_64.zip.asc
mv elastic-agent-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-windows-x86_64.zip.sha512
mv elastic-agent-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-x86_64.rpm
mv elastic-agent-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-x86_64.rpm.asc
mv elastic-agent-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/elastic-agent/elastic-agent-$esversion-x86_64.rpm.sha512
# mv filebeat-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-aarch64.rpm
# mv filebeat-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-aarch64.rpm.asc
# mv filebeat-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-aarch64.rpm.sha512
# mv filebeat-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-amd64.deb
# mv filebeat-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-amd64.deb.asc
# mv filebeat-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-amd64.deb.sha512
# mv filebeat-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-arm64.deb
# mv filebeat-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-arm64.deb.asc
# mv filebeat-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-arm64.deb.sha512
# mv filebeat-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-darwin-aarch64.tar.gz
# mv filebeat-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-darwin-aarch64.tar.gz.asc
# mv filebeat-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-darwin-aarch64.tar.gz.sha512
# mv filebeat-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-darwin-x86_64.tar.gz
# mv filebeat-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-darwin-x86_64.tar.gz.asc
# mv filebeat-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-darwin-x86_64.tar.gz.sha512
# mv filebeat-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-linux-arm64.tar.gz
# mv filebeat-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-linux-arm64.tar.gz.asc
# mv filebeat-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-linux-arm64.tar.gz.sha512
mv filebeat-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-linux-x86_64.tar.gz
mv filebeat-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-linux-x86_64.tar.gz.asc
mv filebeat-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-linux-x86_64.tar.gz.sha512
mv filebeat-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-windows-x86_64.msi
mv filebeat-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-windows-x86_64.msi.asc
mv filebeat-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-windows-x86_64.msi.sha512
mv filebeat-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-windows-x86_64.zip
mv filebeat-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-windows-x86_64.zip.asc
mv filebeat-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-windows-x86_64.zip.sha512
mv filebeat-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-x86_64.rpm
mv filebeat-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-x86_64.rpm.asc
mv filebeat-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-$esversion-x86_64.rpm.sha512
# mv filebeat-oss-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-aarch64.rpm
# mv filebeat-oss-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-aarch64.rpm.asc
# mv filebeat-oss-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-aarch64.rpm.sha512
# mv filebeat-oss-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-amd64.deb
# mv filebeat-oss-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-amd64.deb.asc
# mv filebeat-oss-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-amd64.deb.sha512
# mv filebeat-oss-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-arm64.deb
# mv filebeat-oss-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-arm64.deb.asc
# mv filebeat-oss-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-arm64.deb.sha512
# mv filebeat-oss-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-darwin-x86_64.tar.gz
# mv filebeat-oss-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-darwin-x86_64.tar.gz.asc
# mv filebeat-oss-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-darwin-x86_64.tar.gz.sha512
# mv filebeat-oss-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-linux-arm64.tar.gz
# mv filebeat-oss-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-linux-arm64.tar.gz.asc
# mv filebeat-oss-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-linux-arm64.tar.gz.sha512
mv filebeat-oss-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-linux-x86_64.tar.gz
mv filebeat-oss-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-linux-x86_64.tar.gz.asc
mv filebeat-oss-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-linux-x86_64.tar.gz.sha512
mv filebeat-oss-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-windows-x86_64.msi
mv filebeat-oss-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-windows-x86_64.msi.asc
mv filebeat-oss-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-windows-x86_64.msi.sha512
mv filebeat-oss-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-windows-x86_64.zip
mv filebeat-oss-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-windows-x86_64.zip.asc
mv filebeat-oss-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-windows-x86_64.zip.sha512
mv filebeat-oss-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-x86_64.rpm
mv filebeat-oss-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-x86_64.rpm.asc
mv filebeat-oss-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/filebeat/filebeat-oss-$esversion-x86_64.rpm.sha512
# mv functionbeat-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/functionbeat/functionbeat-$esversion-darwin-x86_64.tar.gz
# mv functionbeat-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/functionbeat/functionbeat-$esversion-darwin-x86_64.tar.gz.asc
# mv functionbeat-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/functionbeat/functionbeat-$esversion-darwin-x86_64.tar.gz.sha512
# mv functionbeat-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/functionbeat/functionbeat-$esversion-linux-arm64.tar.gz
# mv functionbeat-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/functionbeat/functionbeat-$esversion-linux-arm64.tar.gz.asc
# mv functionbeat-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/functionbeat/functionbeat-$esversion-linux-arm64.tar.gz.sha512
mv functionbeat-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/functionbeat/functionbeat-$esversion-linux-x86_64.tar.gz
mv functionbeat-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/functionbeat/functionbeat-$esversion-linux-x86_64.tar.gz.asc
mv functionbeat-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/functionbeat/functionbeat-$esversion-linux-x86_64.tar.gz.sha512
mv functionbeat-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/functionbeat/functionbeat-$esversion-windows-x86_64.zip
mv functionbeat-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/functionbeat/functionbeat-$esversion-windows-x86_64.zip.asc
mv functionbeat-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/functionbeat/functionbeat-$esversion-windows-x86_64.zip.sha512
# mv heartbeat-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-aarch64.rpm
# mv heartbeat-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-aarch64.rpm.asc
# mv heartbeat-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-aarch64.rpm.sha512
# mv heartbeat-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-amd64.deb
# mv heartbeat-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-amd64.deb.asc
# mv heartbeat-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-amd64.deb.sha512
# mv heartbeat-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-arm64.deb
# mv heartbeat-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-arm64.deb.asc
# mv heartbeat-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-arm64.deb.sha512
# mv heartbeat-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-darwin-aarch64.tar.gz
# mv heartbeat-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-darwin-aarch64.tar.gz.asc
# mv heartbeat-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-darwin-aarch64.tar.gz.sha512
# mv heartbeat-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-darwin-x86_64.tar.gz
# mv heartbeat-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-darwin-x86_64.tar.gz.asc
# mv heartbeat-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-darwin-x86_64.tar.gz.sha512
# mv heartbeat-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-linux-arm64.tar.gz
# mv heartbeat-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-linux-arm64.tar.gz.asc
# mv heartbeat-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-linux-arm64.tar.gz.sha512
mv heartbeat-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-linux-x86_64.tar.gz
mv heartbeat-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-linux-x86_64.tar.gz.asc
mv heartbeat-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-linux-x86_64.tar.gz.sha512
mv heartbeat-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-windows-x86_64.msi
mv heartbeat-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-windows-x86_64.msi.asc
mv heartbeat-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-windows-x86_64.msi.sha512
mv heartbeat-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-windows-x86_64.zip
mv heartbeat-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-windows-x86_64.zip.asc
mv heartbeat-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-windows-x86_64.zip.sha512
mv heartbeat-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-x86_64.rpm
mv heartbeat-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-x86_64.rpm.asc
mv heartbeat-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-$esversion-x86_64.rpm.sha512
# mv heartbeat-oss-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-aarch64.rpm
# mv heartbeat-oss-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-aarch64.rpm.asc
# mv heartbeat-oss-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-aarch64.rpm.sha512
# mv heartbeat-oss-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-amd64.deb
# mv heartbeat-oss-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-amd64.deb.asc
# mv heartbeat-oss-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-amd64.deb.sha512
# mv heartbeat-oss-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-arm64.deb
# mv heartbeat-oss-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-arm64.deb.asc
# mv heartbeat-oss-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-arm64.deb.sha512
# mv heartbeat-oss-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-darwin-x86_64.tar.gz
# mv heartbeat-oss-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-darwin-x86_64.tar.gz.asc
# mv heartbeat-oss-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-darwin-x86_64.tar.gz.sha512
# mv heartbeat-oss-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-linux-arm64.tar.gz
# mv heartbeat-oss-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-linux-arm64.tar.gz.asc
# mv heartbeat-oss-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-linux-arm64.tar.gz.sha512
mv heartbeat-oss-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-linux-x86_64.tar.gz
mv heartbeat-oss-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-linux-x86_64.tar.gz.asc
mv heartbeat-oss-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-linux-x86_64.tar.gz.sha512
mv heartbeat-oss-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-windows-x86_64.msi
mv heartbeat-oss-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-windows-x86_64.msi.asc
mv heartbeat-oss-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-windows-x86_64.msi.sha512
mv heartbeat-oss-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-windows-x86_64.zip
mv heartbeat-oss-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-windows-x86_64.zip.asc
mv heartbeat-oss-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-windows-x86_64.zip.sha512
mv heartbeat-oss-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-x86_64.rpm
mv heartbeat-oss-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-x86_64.rpm.asc
mv heartbeat-oss-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/heartbeat/heartbeat-oss-$esversion-x86_64.rpm.sha512
# mv metricbeat-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-aarch64.rpm
# mv metricbeat-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-aarch64.rpm.asc
# mv metricbeat-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-aarch64.rpm.sha512
# mv metricbeat-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-amd64.deb
# mv metricbeat-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-amd64.deb.asc
# mv metricbeat-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-amd64.deb.sha512
# mv metricbeat-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-arm64.deb
# mv metricbeat-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-arm64.deb.asc
# mv metricbeat-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-arm64.deb.sha512
# mv metricbeat-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-darwin-aarch64.tar.gz
# mv metricbeat-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-darwin-aarch64.tar.gz.asc
# mv metricbeat-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-darwin-aarch64.tar.gz.sha512
# mv metricbeat-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-darwin-x86_64.tar.gz
# mv metricbeat-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-darwin-x86_64.tar.gz.asc
# mv metricbeat-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-darwin-x86_64.tar.gz.sha512
# mv metricbeat-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-linux-arm64.tar.gz
# mv metricbeat-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-linux-arm64.tar.gz.asc
# mv metricbeat-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-linux-arm64.tar.gz.sha512
mv metricbeat-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-linux-x86_64.tar.gz
mv metricbeat-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-linux-x86_64.tar.gz.asc
mv metricbeat-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-linux-x86_64.tar.gz.sha512
mv metricbeat-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-windows-x86_64.msi
mv metricbeat-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-windows-x86_64.msi.asc
mv metricbeat-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-windows-x86_64.msi.sha512
mv metricbeat-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-windows-x86_64.zip
mv metricbeat-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-windows-x86_64.zip.asc
mv metricbeat-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-windows-x86_64.zip.sha512
mv metricbeat-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-x86_64.rpm
mv metricbeat-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-x86_64.rpm.asc
mv metricbeat-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-$esversion-x86_64.rpm.sha512
# mv metricbeat-oss-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-aarch64.rpm
# mv metricbeat-oss-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-aarch64.rpm.asc
# mv metricbeat-oss-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-aarch64.rpm.sha512
# mv metricbeat-oss-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-amd64.deb
# mv metricbeat-oss-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-amd64.deb.asc
# mv metricbeat-oss-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-amd64.deb.sha512
# mv metricbeat-oss-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-arm64.deb
# mv metricbeat-oss-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-arm64.deb.asc
# mv metricbeat-oss-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-arm64.deb.sha512
# mv metricbeat-oss-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-darwin-x86_64.tar.gz
# mv metricbeat-oss-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-darwin-x86_64.tar.gz.asc
# mv metricbeat-oss-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-darwin-x86_64.tar.gz.sha512
# mv metricbeat-oss-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-linux-arm64.tar.gz
# mv metricbeat-oss-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-linux-arm64.tar.gz.asc
# mv metricbeat-oss-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-linux-arm64.tar.gz.sha512
mv metricbeat-oss-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-linux-x86_64.tar.gz
mv metricbeat-oss-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-linux-x86_64.tar.gz.asc
mv metricbeat-oss-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-linux-x86_64.tar.gz.sha512
mv metricbeat-oss-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-windows-x86_64.msi
mv metricbeat-oss-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-windows-x86_64.msi.asc
mv metricbeat-oss-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-windows-x86_64.msi.sha512
mv metricbeat-oss-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-windows-x86_64.zip
mv metricbeat-oss-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-windows-x86_64.zip.asc
mv metricbeat-oss-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-windows-x86_64.zip.sha512
mv metricbeat-oss-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-x86_64.rpm
mv metricbeat-oss-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-x86_64.rpm.asc
mv metricbeat-oss-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/metricbeat/metricbeat-oss-$esversion-x86_64.rpm.sha512
# mv osquerybeat-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-darwin-aarch64.tar.gz
# mv osquerybeat-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-darwin-aarch64.tar.gz.asc
# mv osquerybeat-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-darwin-aarch64.tar.gz.sha512
# mv osquerybeat-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-darwin-x86_64.tar.gz
# mv osquerybeat-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-darwin-x86_64.tar.gz.asc
# mv osquerybeat-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-darwin-x86_64.tar.gz.sha512
# mv osquerybeat-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-linux-arm64.tar.gz
# mv osquerybeat-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-linux-arm64.tar.gz.asc
# mv osquerybeat-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-linux-arm64.tar.gz.sha512
mv osquerybeat-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-linux-x86_64.tar.gz
mv osquerybeat-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-linux-x86_64.tar.gz.asc
mv osquerybeat-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-linux-x86_64.tar.gz.sha512
mv osquerybeat-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-windows-x86_64.zip
mv osquerybeat-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-windows-x86_64.zip.asc
mv osquerybeat-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/osquerybeat/osquerybeat-$esversion-windows-x86_64.zip.sha512
# mv packetbeat-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-aarch64.rpm
# mv packetbeat-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-aarch64.rpm.asc
# mv packetbeat-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-aarch64.rpm.sha512
# mv packetbeat-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-amd64.deb
# mv packetbeat-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-amd64.deb.asc
# mv packetbeat-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-amd64.deb.sha512
# mv packetbeat-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-arm64.deb
# mv packetbeat-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-arm64.deb.asc
# mv packetbeat-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-arm64.deb.sha512
# mv packetbeat-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-darwin-aarch64.tar.gz
# mv packetbeat-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-darwin-aarch64.tar.gz.asc
# mv packetbeat-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-darwin-aarch64.tar.gz.sha512
# mv packetbeat-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-darwin-x86_64.tar.gz
# mv packetbeat-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-darwin-x86_64.tar.gz.asc
# mv packetbeat-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-darwin-x86_64.tar.gz.sha512
# mv packetbeat-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-linux-arm64.tar.gz
# mv packetbeat-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-linux-arm64.tar.gz.asc
# mv packetbeat-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-linux-arm64.tar.gz.sha512
mv packetbeat-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-linux-x86_64.tar.gz
mv packetbeat-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-linux-x86_64.tar.gz.asc
mv packetbeat-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-linux-x86_64.tar.gz.sha512
mv packetbeat-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-windows-x86_64.msi
mv packetbeat-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-windows-x86_64.msi.asc
mv packetbeat-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-windows-x86_64.msi.sha512
mv packetbeat-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-windows-x86_64.zip
mv packetbeat-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-windows-x86_64.zip.asc
mv packetbeat-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-windows-x86_64.zip.sha512
mv packetbeat-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-x86_64.rpm
mv packetbeat-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-x86_64.rpm.asc
mv packetbeat-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-$esversion-x86_64.rpm.sha512
# mv packetbeat-oss-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-aarch64.rpm
# mv packetbeat-oss-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-aarch64.rpm.asc
# mv packetbeat-oss-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-aarch64.rpm.sha512
# mv packetbeat-oss-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-amd64.deb
# mv packetbeat-oss-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-amd64.deb.asc
# mv packetbeat-oss-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-amd64.deb.sha512
# mv packetbeat-oss-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-arm64.deb
# mv packetbeat-oss-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-arm64.deb.asc
# mv packetbeat-oss-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-arm64.deb.sha512
# mv packetbeat-oss-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-darwin-x86_64.tar.gz
# mv packetbeat-oss-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-darwin-x86_64.tar.gz.asc
# mv packetbeat-oss-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-darwin-x86_64.tar.gz.sha512
# mv packetbeat-oss-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-linux-arm64.tar.gz
# mv packetbeat-oss-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-linux-arm64.tar.gz.asc
# mv packetbeat-oss-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-linux-arm64.tar.gz.sha512
mv packetbeat-oss-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-linux-x86_64.tar.gz
mv packetbeat-oss-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-linux-x86_64.tar.gz.asc
mv packetbeat-oss-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-linux-x86_64.tar.gz.sha512
mv packetbeat-oss-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-windows-x86_64.msi
mv packetbeat-oss-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-windows-x86_64.msi.asc
mv packetbeat-oss-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-windows-x86_64.msi.sha512
mv packetbeat-oss-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-windows-x86_64.zip
mv packetbeat-oss-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-windows-x86_64.zip.asc
mv packetbeat-oss-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-windows-x86_64.zip.sha512
mv packetbeat-oss-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-x86_64.rpm
mv packetbeat-oss-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-x86_64.rpm.asc
mv packetbeat-oss-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/beats/packetbeat/packetbeat-oss-$esversion-x86_64.rpm.sha512
mv winlogbeat-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/winlogbeat/winlogbeat-$esversion-windows-x86_64.msi
mv winlogbeat-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/winlogbeat/winlogbeat-$esversion-windows-x86_64.msi.asc
mv winlogbeat-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/winlogbeat/winlogbeat-$esversion-windows-x86_64.msi.sha512
mv winlogbeat-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/winlogbeat/winlogbeat-$esversion-windows-x86_64.zip
mv winlogbeat-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/winlogbeat/winlogbeat-$esversion-windows-x86_64.zip.asc
mv winlogbeat-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/winlogbeat/winlogbeat-$esversion-windows-x86_64.zip.sha512
mv winlogbeat-oss-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/beats/winlogbeat/winlogbeat-oss-$esversion-windows-x86_64.msi
mv winlogbeat-oss-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/beats/winlogbeat/winlogbeat-oss-$esversion-windows-x86_64.msi.asc
mv winlogbeat-oss-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/beats/winlogbeat/winlogbeat-oss-$esversion-windows-x86_64.msi.sha512
mv winlogbeat-oss-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/beats/winlogbeat/winlogbeat-oss-$esversion-windows-x86_64.zip
mv winlogbeat-oss-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/beats/winlogbeat/winlogbeat-oss-$esversion-windows-x86_64.zip.asc
mv winlogbeat-oss-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/beats/winlogbeat/winlogbeat-oss-$esversion-windows-x86_64.zip.sha512
# mv cloud-defend-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/cloud-defend/cloud-defend-$esversion-linux-arm64.tar.gz
# mv cloud-defend-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/cloud-defend/cloud-defend-$esversion-linux-arm64.tar.gz.asc
# mv cloud-defend-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/cloud-defend/cloud-defend-$esversion-linux-arm64.tar.gz.sha512
mv cloud-defend-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/cloud-defend/cloud-defend-$esversion-linux-x86_64.tar.gz
mv cloud-defend-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/cloud-defend/cloud-defend-$esversion-linux-x86_64.tar.gz.asc
mv cloud-defend-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/cloud-defend/cloud-defend-$esversion-linux-x86_64.tar.gz.sha512
# mv cloudbeat-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/cloudbeat/cloudbeat-$esversion-linux-arm64.tar.gz
# mv cloudbeat-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/cloudbeat/cloudbeat-$esversion-linux-arm64.tar.gz.asc
# mv cloudbeat-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/cloudbeat/cloudbeat-$esversion-linux-arm64.tar.gz.sha512
mv cloudbeat-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/cloudbeat/cloudbeat-$esversion-linux-x86_64.tar.gz
mv cloudbeat-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/cloudbeat/cloudbeat-$esversion-linux-x86_64.tar.gz.asc
mv cloudbeat-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/cloudbeat/cloudbeat-$esversion-linux-x86_64.tar.gz.sha512
mv connectors-$esversion.zip $BASE_DIR/downloads-$esversion/connectors/connectors-$esversion.zip
mv connectors-$esversion.zip.asc $BASE_DIR/downloads-$esversion/connectors/connectors-$esversion.zip.asc
mv connectors-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/connectors/connectors-$esversion.zip.sha512
# mv elastic-agent-core-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-darwin-aarch64.tar.gz
# mv elastic-agent-core-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-darwin-aarch64.tar.gz.asc
# mv elastic-agent-core-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-darwin-aarch64.tar.gz.sha512
# mv elastic-agent-core-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-darwin-x86_64.tar.gz
# mv elastic-agent-core-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-darwin-x86_64.tar.gz.asc
# mv elastic-agent-core-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-darwin-x86_64.tar.gz.sha512
# mv elastic-agent-core-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-linux-arm64.tar.gz
# mv elastic-agent-core-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-linux-arm64.tar.gz.asc
# mv elastic-agent-core-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-linux-arm64.tar.gz.sha512
mv elastic-agent-core-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-linux-x86_64.tar.gz
mv elastic-agent-core-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-linux-x86_64.tar.gz.asc
mv elastic-agent-core-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-linux-x86_64.tar.gz.sha512
mv elastic-agent-core-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-windows-x86_64.zip
mv elastic-agent-core-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-windows-x86_64.zip.asc
mv elastic-agent-core-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/elastic-agent-core/elastic-agent-core-$esversion-windows-x86_64.zip.sha512
mv elasticsearch-hadoop-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-hadoop/elasticsearch-hadoop-$esversion.zip
mv elasticsearch-hadoop-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-hadoop/elasticsearch-hadoop-$esversion.zip.asc
mv elasticsearch-hadoop-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-hadoop/elasticsearch-hadoop-$esversion.zip.sha512
mv analysis-icu-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-icu/analysis-icu-$esversion.zip
mv analysis-icu-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-icu/analysis-icu-$esversion.zip.asc
mv analysis-icu-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-icu/analysis-icu-$esversion.zip.sha512
mv analysis-kuromoji-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-kuromoji/analysis-kuromoji-$esversion.zip
mv analysis-kuromoji-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-kuromoji/analysis-kuromoji-$esversion.zip.asc
mv analysis-kuromoji-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-kuromoji/analysis-kuromoji-$esversion.zip.sha512
mv analysis-nori-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-nori/analysis-nori-$esversion.zip
mv analysis-nori-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-nori/analysis-nori-$esversion.zip.asc
mv analysis-nori-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-nori/analysis-nori-$esversion.zip.sha512
mv analysis-phonetic-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-phonetic/analysis-phonetic-$esversion.zip
mv analysis-phonetic-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-phonetic/analysis-phonetic-$esversion.zip.asc
mv analysis-phonetic-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-phonetic/analysis-phonetic-$esversion.zip.sha512
mv analysis-smartcn-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-smartcn/analysis-smartcn-$esversion.zip
mv analysis-smartcn-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-smartcn/analysis-smartcn-$esversion.zip.asc
mv analysis-smartcn-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-smartcn/analysis-smartcn-$esversion.zip.sha512
mv analysis-stempel-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-stempel/analysis-stempel-$esversion.zip
mv analysis-stempel-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-stempel/analysis-stempel-$esversion.zip.asc
mv analysis-stempel-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-stempel/analysis-stempel-$esversion.zip.sha512
mv analysis-ukrainian-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-ukrainian/analysis-ukrainian-$esversion.zip
mv analysis-ukrainian-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-ukrainian/analysis-ukrainian-$esversion.zip.asc
mv analysis-ukrainian-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/analysis-ukrainian/analysis-ukrainian-$esversion.zip.sha512
mv discovery-azure-classic-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/discovery-azure-classic/discovery-azure-classic-$esversion.zip
mv discovery-azure-classic-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/discovery-azure-classic/discovery-azure-classic-$esversion.zip.asc
mv discovery-azure-classic-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/discovery-azure-classic/discovery-azure-classic-$esversion.zip.sha512
mv discovery-ec2-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/discovery-ec2/discovery-ec2-$esversion.zip
mv discovery-ec2-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/discovery-ec2/discovery-ec2-$esversion.zip.asc
mv discovery-ec2-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/discovery-ec2/discovery-ec2-$esversion.zip.sha512
mv discovery-gce-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/discovery-gce/discovery-gce-$esversion.zip
mv discovery-gce-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/discovery-gce/discovery-gce-$esversion.zip.asc
mv discovery-gce-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/discovery-gce/discovery-gce-$esversion.zip.sha512
mv mapper-annotated-text-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/mapper-annotated-text/mapper-annotated-text-$esversion.zip
mv mapper-annotated-text-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/mapper-annotated-text/mapper-annotated-text-$esversion.zip.asc
mv mapper-annotated-text-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/mapper-annotated-text/mapper-annotated-text-$esversion.zip.sha512
mv mapper-murmur3-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/mapper-murmur3/mapper-murmur3-$esversion.zip
mv mapper-murmur3-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/mapper-murmur3/mapper-murmur3-$esversion.zip.asc
mv mapper-murmur3-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/mapper-murmur3/mapper-murmur3-$esversion.zip.sha512
mv mapper-size-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/mapper-size/mapper-size-$esversion.zip
mv mapper-size-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/mapper-size/mapper-size-$esversion.zip.asc
mv mapper-size-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/mapper-size/mapper-size-$esversion.zip.sha512
mv repository-hdfs-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/repository-hdfs/repository-hdfs-$esversion.zip
mv repository-hdfs-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/repository-hdfs/repository-hdfs-$esversion.zip.asc
mv repository-hdfs-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/repository-hdfs/repository-hdfs-$esversion.zip.sha512
mv store-smb-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch-plugins/store-smb/store-smb-$esversion.zip
mv store-smb-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch-plugins/store-smb/store-smb-$esversion.zip.asc
mv store-smb-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch-plugins/store-smb/store-smb-$esversion.zip.sha512
# mv elasticsearch-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-aarch64.rpm
# mv elasticsearch-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-aarch64.rpm.asc
# mv elasticsearch-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-aarch64.rpm.sha512
# mv elasticsearch-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-amd64.deb
# mv elasticsearch-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-amd64.deb.asc
# mv elasticsearch-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-amd64.deb.sha512
# mv elasticsearch-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-arm64.deb
# mv elasticsearch-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-arm64.deb.asc
# mv elasticsearch-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-arm64.deb.sha512
# mv elasticsearch-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-darwin-aarch64.tar.gz
# mv elasticsearch-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-darwin-aarch64.tar.gz.asc
# mv elasticsearch-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-darwin-aarch64.tar.gz.sha512
# mv elasticsearch-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-darwin-x86_64.tar.gz
# mv elasticsearch-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-darwin-x86_64.tar.gz.asc
# mv elasticsearch-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-darwin-x86_64.tar.gz.sha512
# mv elasticsearch-$esversion-linux-aarch64.tar.gz $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-linux-aarch64.tar.gz
# mv elasticsearch-$esversion-linux-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-linux-aarch64.tar.gz.asc
# mv elasticsearch-$esversion-linux-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-linux-aarch64.tar.gz.sha512
mv elasticsearch-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-linux-x86_64.tar.gz
mv elasticsearch-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-linux-x86_64.tar.gz.asc
mv elasticsearch-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-linux-x86_64.tar.gz.sha512
mv elasticsearch-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-windows-x86_64.zip
mv elasticsearch-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-windows-x86_64.zip.asc
mv elasticsearch-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-windows-x86_64.zip.sha512
mv elasticsearch-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-x86_64.rpm
mv elasticsearch-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-x86_64.rpm.asc
mv elasticsearch-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-$esversion-x86_64.rpm.sha512
mv elasticsearch-jdbc-$esversion.taco $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-jdbc-$esversion.taco
mv elasticsearch-jdbc-$esversion.taco.asc $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-jdbc-$esversion.taco.asc
mv elasticsearch-jdbc-$esversion.taco.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/elasticsearch-jdbc-$esversion.taco.sha512
mv esodbc-$esversion-windows-x86.msi $BASE_DIR/downloads-$esversion/elasticsearch/esodbc-$esversion-windows-x86.msi
mv esodbc-$esversion-windows-x86.msi.asc $BASE_DIR/downloads-$esversion/elasticsearch/esodbc-$esversion-windows-x86.msi.asc
mv esodbc-$esversion-windows-x86.msi.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/esodbc-$esversion-windows-x86.msi.sha512
mv esodbc-$esversion-windows-x86_64.msi $BASE_DIR/downloads-$esversion/elasticsearch/esodbc-$esversion-windows-x86_64.msi
mv esodbc-$esversion-windows-x86_64.msi.asc $BASE_DIR/downloads-$esversion/elasticsearch/esodbc-$esversion-windows-x86_64.msi.asc
mv esodbc-$esversion-windows-x86_64.msi.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/esodbc-$esversion-windows-x86_64.msi.sha512
mv rest-resources-zip-$esversion.zip $BASE_DIR/downloads-$esversion/elasticsearch/rest-resources-zip-$esversion.zip
mv rest-resources-zip-$esversion.zip.asc $BASE_DIR/downloads-$esversion/elasticsearch/rest-resources-zip-$esversion.zip.asc
mv rest-resources-zip-$esversion.zip.sha512 $BASE_DIR/downloads-$esversion/elasticsearch/rest-resources-zip-$esversion.zip.sha512
# mv endpoint-security-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-darwin-aarch64.tar.gz
# mv endpoint-security-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-darwin-aarch64.tar.gz.asc
# mv endpoint-security-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-darwin-aarch64.tar.gz.sha512
# mv endpoint-security-$esversion-darwin-universal.tar.gz $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-darwin-universal.tar.gz
# mv endpoint-security-$esversion-darwin-universal.tar.gz.asc $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-darwin-universal.tar.gz.asc
# mv endpoint-security-$esversion-darwin-universal.tar.gz.sha512 $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-darwin-universal.tar.gz.sha512
# mv endpoint-security-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-darwin-x86_64.tar.gz
# mv endpoint-security-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-darwin-x86_64.tar.gz.asc
# mv endpoint-security-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-darwin-x86_64.tar.gz.sha512
# mv endpoint-security-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-linux-arm64.tar.gz
# mv endpoint-security-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-linux-arm64.tar.gz.asc
# mv endpoint-security-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-linux-arm64.tar.gz.sha512
mv endpoint-security-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-linux-x86_64.tar.gz
mv endpoint-security-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-linux-x86_64.tar.gz.asc
mv endpoint-security-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-linux-x86_64.tar.gz.sha512
mv endpoint-security-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-windows-x86_64.zip
mv endpoint-security-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-windows-x86_64.zip.asc
mv endpoint-security-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/endpoint-dev/endpoint-security-$esversion-windows-x86_64.zip.sha512
# mv enterprise-search-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion-aarch64.rpm
# mv enterprise-search-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion-aarch64.rpm.asc
# mv enterprise-search-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion-aarch64.rpm.sha512
# mv enterprise-search-$esversion-aarch64.tar.gz $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion-aarch64.tar.gz
# mv enterprise-search-$esversion-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion-aarch64.tar.gz.asc
# mv enterprise-search-$esversion-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion-aarch64.tar.gz.sha512
# mv enterprise-search-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion-arm64.deb
# mv enterprise-search-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion-arm64.deb.asc
# mv enterprise-search-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion-arm64.deb.sha512
# mv enterprise-search-$esversion.deb $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion.deb
# mv enterprise-search-$esversion.deb.asc $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion.deb.asc
# mv enterprise-search-$esversion.deb.sha512 $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion.deb.sha512
mv enterprise-search-$esversion.rpm $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion.rpm
mv enterprise-search-$esversion.rpm.asc $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion.rpm.asc
mv enterprise-search-$esversion.rpm.sha512 $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion.rpm.sha512
mv enterprise-search-$esversion.tar.gz $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion.tar.gz
mv enterprise-search-$esversion.tar.gz.asc $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion.tar.gz.asc
mv enterprise-search-$esversion.tar.gz.sha512 $BASE_DIR/downloads-$esversion/enterprise-search/enterprise-search-$esversion.tar.gz.sha512
# mv fleet-server-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-darwin-aarch64.tar.gz
# mv fleet-server-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-darwin-aarch64.tar.gz.asc
# mv fleet-server-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-darwin-aarch64.tar.gz.sha512
# mv fleet-server-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-darwin-x86_64.tar.gz
# mv fleet-server-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-darwin-x86_64.tar.gz.asc
# mv fleet-server-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-darwin-x86_64.tar.gz.sha512
# mv fleet-server-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-linux-arm64.tar.gz
# mv fleet-server-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-linux-arm64.tar.gz.asc
# mv fleet-server-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-linux-arm64.tar.gz.sha512
mv fleet-server-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-linux-x86_64.tar.gz
mv fleet-server-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-linux-x86_64.tar.gz.asc
mv fleet-server-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-linux-x86_64.tar.gz.sha512
mv fleet-server-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-windows-x86_64.zip
mv fleet-server-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-windows-x86_64.zip.asc
mv fleet-server-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/fleet-server/fleet-server-$esversion-windows-x86_64.zip.sha512
# mv kibana-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-aarch64.rpm
# mv kibana-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-aarch64.rpm.asc
# mv kibana-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-aarch64.rpm.sha512
# mv kibana-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-amd64.deb
# mv kibana-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-amd64.deb.asc
# mv kibana-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-amd64.deb.sha512
# mv kibana-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-arm64.deb
# mv kibana-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-arm64.deb.asc
# mv kibana-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-arm64.deb.sha512
# mv kibana-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-darwin-aarch64.tar.gz
# mv kibana-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-darwin-aarch64.tar.gz.asc
# mv kibana-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-darwin-aarch64.tar.gz.sha512
# mv kibana-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-darwin-x86_64.tar.gz
# mv kibana-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-darwin-x86_64.tar.gz.asc
# mv kibana-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-darwin-x86_64.tar.gz.sha512
# mv kibana-$esversion-linux-aarch64.tar.gz $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-linux-aarch64.tar.gz
# mv kibana-$esversion-linux-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-linux-aarch64.tar.gz.asc
# mv kibana-$esversion-linux-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-linux-aarch64.tar.gz.sha512
mv kibana-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-linux-x86_64.tar.gz
mv kibana-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-linux-x86_64.tar.gz.asc
mv kibana-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-linux-x86_64.tar.gz.sha512
mv kibana-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-windows-x86_64.zip
mv kibana-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-windows-x86_64.zip.asc
mv kibana-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-windows-x86_64.zip.sha512
mv kibana-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-x86_64.rpm
mv kibana-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-x86_64.rpm.asc
mv kibana-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/kibana/kibana-$esversion-x86_64.rpm.sha512
# mv logstash-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-aarch64.rpm
# mv logstash-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-aarch64.rpm.asc
# mv logstash-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-aarch64.rpm.sha512
# mv logstash-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-amd64.deb
# mv logstash-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-amd64.deb.asc
# mv logstash-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-amd64.deb.sha512
# mv logstash-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-arm64.deb
# mv logstash-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-arm64.deb.asc
# mv logstash-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-arm64.deb.sha512
# mv logstash-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-darwin-aarch64.tar.gz
# mv logstash-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-darwin-aarch64.tar.gz.asc
# mv logstash-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-darwin-aarch64.tar.gz.sha512
# mv logstash-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-darwin-x86_64.tar.gz
# mv logstash-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-darwin-x86_64.tar.gz.asc
# mv logstash-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-darwin-x86_64.tar.gz.sha512
# mv logstash-$esversion-linux-aarch64.tar.gz $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-linux-aarch64.tar.gz
# mv logstash-$esversion-linux-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-linux-aarch64.tar.gz.asc
# mv logstash-$esversion-linux-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-linux-aarch64.tar.gz.sha512
mv logstash-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-linux-x86_64.tar.gz
mv logstash-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-linux-x86_64.tar.gz.asc
mv logstash-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-linux-x86_64.tar.gz.sha512
# mv logstash-$esversion-no-jdk.deb $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-no-jdk.deb
# mv logstash-$esversion-no-jdk.deb.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-no-jdk.deb.asc
# mv logstash-$esversion-no-jdk.deb.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-no-jdk.deb.sha512
mv logstash-$esversion-no-jdk.rpm $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-no-jdk.rpm
mv logstash-$esversion-no-jdk.rpm.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-no-jdk.rpm.asc
mv logstash-$esversion-no-jdk.rpm.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-no-jdk.rpm.sha512
mv logstash-$esversion-no-jdk.tar.gz $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-no-jdk.tar.gz
mv logstash-$esversion-no-jdk.tar.gz.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-no-jdk.tar.gz.asc
mv logstash-$esversion-no-jdk.tar.gz.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-no-jdk.tar.gz.sha512
mv logstash-$esversion-no-jdk.zip $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-no-jdk.zip
mv logstash-$esversion-no-jdk.zip.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-no-jdk.zip.asc
mv logstash-$esversion-no-jdk.zip.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-no-jdk.zip.sha512
mv logstash-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-windows-x86_64.zip
mv logstash-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-windows-x86_64.zip.asc
mv logstash-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-windows-x86_64.zip.sha512
mv logstash-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-x86_64.rpm
mv logstash-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-x86_64.rpm.asc
mv logstash-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-$esversion-x86_64.rpm.sha512
# mv logstash-oss-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-aarch64.rpm
# mv logstash-oss-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-aarch64.rpm.asc
# mv logstash-oss-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-aarch64.rpm.sha512
# mv logstash-oss-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-amd64.deb
# mv logstash-oss-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-amd64.deb.asc
# mv logstash-oss-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-amd64.deb.sha512
# mv logstash-oss-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-arm64.deb
# mv logstash-oss-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-arm64.deb.asc
# mv logstash-oss-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-arm64.deb.sha512
# mv logstash-oss-$esversion-darwin-aarch64.tar.gz $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-darwin-aarch64.tar.gz
# mv logstash-oss-$esversion-darwin-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-darwin-aarch64.tar.gz.asc
# mv logstash-oss-$esversion-darwin-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-darwin-aarch64.tar.gz.sha512
# mv logstash-oss-$esversion-darwin-x86_64.tar.gz $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-darwin-x86_64.tar.gz
# mv logstash-oss-$esversion-darwin-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-darwin-x86_64.tar.gz.asc
# mv logstash-oss-$esversion-darwin-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-darwin-x86_64.tar.gz.sha512
# mv logstash-oss-$esversion-linux-aarch64.tar.gz $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-linux-aarch64.tar.gz
# mv logstash-oss-$esversion-linux-aarch64.tar.gz.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-linux-aarch64.tar.gz.asc
# mv logstash-oss-$esversion-linux-aarch64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-linux-aarch64.tar.gz.sha512
mv logstash-oss-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-linux-x86_64.tar.gz
mv logstash-oss-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-linux-x86_64.tar.gz.asc
mv logstash-oss-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-linux-x86_64.tar.gz.sha512
# mv logstash-oss-$esversion-no-jdk.deb $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-no-jdk.deb
# mv logstash-oss-$esversion-no-jdk.deb.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-no-jdk.deb.asc
# mv logstash-oss-$esversion-no-jdk.deb.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-no-jdk.deb.sha512
mv logstash-oss-$esversion-no-jdk.rpm $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-no-jdk.rpm
mv logstash-oss-$esversion-no-jdk.rpm.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-no-jdk.rpm.asc
mv logstash-oss-$esversion-no-jdk.rpm.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-no-jdk.rpm.sha512
mv logstash-oss-$esversion-no-jdk.tar.gz $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-no-jdk.tar.gz
mv logstash-oss-$esversion-no-jdk.tar.gz.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-no-jdk.tar.gz.asc
mv logstash-oss-$esversion-no-jdk.tar.gz.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-no-jdk.tar.gz.sha512
mv logstash-oss-$esversion-no-jdk.zip $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-no-jdk.zip
mv logstash-oss-$esversion-no-jdk.zip.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-no-jdk.zip.asc
mv logstash-oss-$esversion-no-jdk.zip.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-no-jdk.zip.sha512
mv logstash-oss-$esversion-windows-x86_64.zip $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-windows-x86_64.zip
mv logstash-oss-$esversion-windows-x86_64.zip.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-windows-x86_64.zip.asc
mv logstash-oss-$esversion-windows-x86_64.zip.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-windows-x86_64.zip.sha512
mv logstash-oss-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-x86_64.rpm
mv logstash-oss-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-x86_64.rpm.asc
mv logstash-oss-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/logstash/logstash-oss-$esversion-x86_64.rpm.sha512
# mv pf-elastic-collector-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-aarch64.rpm
# mv pf-elastic-collector-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-aarch64.rpm.asc
# mv pf-elastic-collector-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-aarch64.rpm.sha512
# mv pf-elastic-collector-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-amd64.deb
# mv pf-elastic-collector-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-amd64.deb.asc
# mv pf-elastic-collector-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-amd64.deb.sha512
# mv pf-elastic-collector-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-arm64.deb
# mv pf-elastic-collector-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-arm64.deb.asc
# mv pf-elastic-collector-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-arm64.deb.sha512
# mv pf-elastic-collector-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-linux-arm64.tar.gz
# mv pf-elastic-collector-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-linux-arm64.tar.gz.asc
# mv pf-elastic-collector-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-linux-arm64.tar.gz.sha512
mv pf-elastic-collector-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-linux-x86_64.tar.gz
mv pf-elastic-collector-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-linux-x86_64.tar.gz.asc
mv pf-elastic-collector-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-linux-x86_64.tar.gz.sha512
mv pf-elastic-collector-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-x86_64.rpm
mv pf-elastic-collector-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-x86_64.rpm.asc
mv pf-elastic-collector-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-collector-$esversion-x86_64.rpm.sha512
# mv pf-elastic-symbolizer-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-aarch64.rpm
# mv pf-elastic-symbolizer-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-aarch64.rpm.asc
# mv pf-elastic-symbolizer-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-aarch64.rpm.sha512
# mv pf-elastic-symbolizer-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-amd64.deb
# mv pf-elastic-symbolizer-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-amd64.deb.asc
# mv pf-elastic-symbolizer-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-amd64.deb.sha512
# mv pf-elastic-symbolizer-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-arm64.deb
# mv pf-elastic-symbolizer-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-arm64.deb.asc
# mv pf-elastic-symbolizer-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-arm64.deb.sha512
# mv pf-elastic-symbolizer-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-linux-arm64.tar.gz
# mv pf-elastic-symbolizer-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-linux-arm64.tar.gz.asc
# mv pf-elastic-symbolizer-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-linux-arm64.tar.gz.sha512
mv pf-elastic-symbolizer-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-linux-x86_64.tar.gz
mv pf-elastic-symbolizer-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-linux-x86_64.tar.gz.asc
mv pf-elastic-symbolizer-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-linux-x86_64.tar.gz.sha512
mv pf-elastic-symbolizer-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-x86_64.rpm
mv pf-elastic-symbolizer-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-x86_64.rpm.asc
mv pf-elastic-symbolizer-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-elastic-symbolizer-$esversion-x86_64.rpm.sha512
# mv pf-host-agent-$esversion-aarch64.rpm $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-aarch64.rpm
# mv pf-host-agent-$esversion-aarch64.rpm.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-aarch64.rpm.asc
# mv pf-host-agent-$esversion-aarch64.rpm.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-aarch64.rpm.sha512
# mv pf-host-agent-$esversion-amd64.deb $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-amd64.deb
# mv pf-host-agent-$esversion-amd64.deb.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-amd64.deb.asc
# mv pf-host-agent-$esversion-amd64.deb.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-amd64.deb.sha512
# mv pf-host-agent-$esversion-arm64.deb $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-arm64.deb
# mv pf-host-agent-$esversion-arm64.deb.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-arm64.deb.asc
# mv pf-host-agent-$esversion-arm64.deb.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-arm64.deb.sha512
# mv pf-host-agent-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-linux-arm64.tar.gz
# mv pf-host-agent-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-linux-arm64.tar.gz.asc
# mv pf-host-agent-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-linux-arm64.tar.gz.sha512
mv pf-host-agent-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-linux-x86_64.tar.gz
mv pf-host-agent-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-linux-x86_64.tar.gz.asc
mv pf-host-agent-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-linux-x86_64.tar.gz.sha512
mv pf-host-agent-$esversion-x86_64.rpm $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-x86_64.rpm
mv pf-host-agent-$esversion-x86_64.rpm.asc $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-x86_64.rpm.asc
mv pf-host-agent-$esversion-x86_64.rpm.sha512 $BASE_DIR/downloads-$esversion/prodfiler/pf-host-agent-$esversion-x86_64.rpm.sha512
mv symbtool-$esversion-linux-arm64.tar.gz $BASE_DIR/downloads-$esversion/prodfiler/symbtool-$esversion-linux-arm64.tar.gz
mv symbtool-$esversion-linux-arm64.tar.gz.asc $BASE_DIR/downloads-$esversion/prodfiler/symbtool-$esversion-linux-arm64.tar.gz.asc
mv symbtool-$esversion-linux-arm64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/prodfiler/symbtool-$esversion-linux-arm64.tar.gz.sha512
mv symbtool-$esversion-linux-x86_64.tar.gz $BASE_DIR/downloads-$esversion/prodfiler/symbtool-$esversion-linux-x86_64.tar.gz
mv symbtool-$esversion-linux-x86_64.tar.gz.asc $BASE_DIR/downloads-$esversion/prodfiler/symbtool-$esversion-linux-x86_64.tar.gz.asc
mv symbtool-$esversion-linux-x86_64.tar.gz.sha512 $BASE_DIR/downloads-$esversion/prodfiler/symbtool-$esversion-linux-x86_64.tar.gz.sha512

echo "[ $(timestamp) ] File move completed" | tee -a $LOGFILE
}

# Trap SIGINT and call the cleanup function
trap cleanup SIGINT

# Run the Main function
Main
