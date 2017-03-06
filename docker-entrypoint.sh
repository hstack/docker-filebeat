#!/bin/sh

# If the env variable FILEBEAT_CONFIG_URL is sent, then overwrite the default
# filebeat config with the downloaded one
if [[ -n "${FILEBEAT_CONFIG_URL}" ]]; then
  echo "FILEBEAT_CONFIG_URL provided, downloading the new config..."
  curl -o /etc/filebeat/filebeat.yml ${FILEBEAT_CONFIG_URL}
fi

# If the env variable FILEBEAT_TEMPLATE_URL is sent, then overwrite the default
# filebeat template with the downloaded one
if [[ -n "${FILEBEAT_TEMPLATE_URL}" ]]; then
  echo "FILEBEAT_TEMPLATE_URL provided, downloading the new template..."
  curl -o /etc/filebeat/filebeat.template.json ${FILEBEAT_TEMPLATE_URL}
fi

exec "$@"
