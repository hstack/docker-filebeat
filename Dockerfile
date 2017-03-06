FROM alpine:latest

ENV \
  GOPATH=/usr/lib/go/bin \
  GOBIN=/usr/lib/go/bin \
  PATH=$PATH:/usr/lib/go/bin:/usr/local/bin \
  BEATS_VERSION=5.2.2 \
  ELASTICSEARCH_INDEX=filebeat

# install dependencies
RUN apk --no-cache add make git go curl libc-dev bash

RUN echo "Building filebeat" \
    && mkdir -p /tmp/beats \
    && curl -k -L https://github.com/elastic/beats/archive/v${BEATS_VERSION}.tar.gz -o /tmp/beats/beats-${BEATS_VERSION}.tar.gz \
    && cd /tmp/beats \
    && tar -xzf /tmp/beats/beats-${BEATS_VERSION}.tar.gz \
    && mkdir -p /tmp/go \
    && mkdir -p /tmp/go-src/src/github.com/elastic \
    && mv /tmp/beats/beats-${BEATS_VERSION}/* /tmp/go \
    && cd /tmp/go \
    && ln -s /tmp/go /tmp/go-src/src/github.com/elastic/beats \
    && cd /tmp/go-src/src/github.com/elastic/beats/filebeat \
    && GOPATH=/tmp/go-src GOOS=linux make \
    && mv /tmp/go-src/src/github.com/elastic/beats/filebeat/filebeat /usr/local/bin/filebeat

COPY filebeat.yml filebeat.template.json /etc/filebeat/
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

VOLUME /logs
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/filebeat", "-e", "-v", "-c", "/etc/filebeat/filebeat.yml"]
