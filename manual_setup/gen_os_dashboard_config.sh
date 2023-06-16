#!/bin/bash

# Parse arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --managers)
    HOSTS="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    echo "Unknown option: $1"
    exit 1
    ;;
esac
done

IFS=',' read -ra ADDR <<< "$HOSTS"
for i in "${ADDR[@]}"; do
  formatted_hosts="$formatted_hosts,\"http://$i:9200\""
done
formatted_hosts="${formatted_hosts:1}" # Remove the leading comma

rm /etc/opensearch-dashboards/opensearch_dashboards.yml

cat > /etc/opensearch-dashboards/opensearch_dashboards.yml <<EOF

server.host: "0.0.0.0"
opensearch.hosts: [${formatted_hosts}]
server.ssl.enabled: false
opensearch.ssl.verificationMode: none

EOF

chown opensearch-dashboards:opensearch-dashboards  /etc/opensearch-dashboards/opensearch_dashboards.yml