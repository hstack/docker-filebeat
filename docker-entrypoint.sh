#!/bin/sh

# Discover Elasticsearch config
if [[ -n "${ELASTICSEARCH_MESOS_URL}" ]]; then
  export ELASTICSEARCH_CLUSTER=$(curl -s ${ELASTICSEARCH_MESOS_URL}/v1/tasks | jq -c 'map(.http_address)')
  export ELASTICSEARCH_HOST=$(curl -s ${ELASTICSEARCH_MESOS_URL}/v1/tasks | jq -r '.[0].http_address')
fi

# create index
curl -XPUT http://${ELASTICSEARCH_HOST}/_template/filebeat -d@/etc/filebeat_index.json
export ELASTICSEARCH_INDEX=filebeat

# Render config file
cat /etc/filebeat.template.yml | sed "s/\[ELASTICSEARCH_CLUSTER\]/$ELASTICSEARCH_CLUSTER/" | sed "s/ELASTICSEARCH_INDEX/$ELASTICSEARCH_INDEX/" \
  | sed "s#PATH_GLOB#$PATH_GLOB#" > /etc/filebeat.yml

exec "$@"

