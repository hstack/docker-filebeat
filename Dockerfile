FROM alpine:latest

ENV \
  GOPATH=/usr/lib/go/bin \
  GOBIN=/usr/lib/go/bin \
  PATH=$PATH:/usr/lib/go/bin:/usr/local/bin \
  BEATS_VERSION=1.2.1

# install dependencies
RUN apk update \
    && apk add make git go curl

RUN apk add bash

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

RUN echo "Get tools" \
    && curl -k -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/local/bin/jq \
    && chmod +x /usr/local/bin/jq

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY filebeat.template.yml /etc/filebeat.template.yml
COPY filebeat_index.json /etc/filebeat_index.json

VOLUME /logs
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/filebeat", "-e", "-v", "-c", "/etc/filebeat.yml"]
