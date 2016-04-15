FROM busybox

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY binary/filebeat /filebeat
COPY filebeat.yml /filebeat.yml

VOLUME /logs
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/filebeat", "-e", "-v", "-c", "/filebeat.yml"]
