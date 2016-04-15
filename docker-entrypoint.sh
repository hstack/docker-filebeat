#!/bin/sh
set -e

# Render config file
cat filebeat.yml | sed "s/ELASTICSEARCH_HOST/$ELASTICSEARCH_HOST/" | sed "s/ELASTICSEARCH_INDEX/$ELASTICSEARCH_INDEX/" > filebeat.yml.tmp
cat filebeat.yml.tmp > filebeat.yml
rm filebeat.yml.tmp

exec "$@"

