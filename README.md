# Docker Filebeat image
This image contains filebeat so you can send logs from a server to Elasticsearch.

It's expecting some environment variables to know where is the ES instance:
you must provide the `ELASTICSEARCH_URL` and `ELASTICSEARCH_PORT`.

## Running the container

- To start the container run with the default filebeat and template configuration:
  
  ```
  docker run -e "ELASTICSEARCH_URL=http://my-es.mydomain.com" -e "ELASTICSEARCH_PORT=9200" 
  -e "PATH_GLOB=/var/log/" -d filebeats:5.2.2
  ```

- If you want to overwrite the default filebeat or template configuration:

  ```
  docker run -e "ELASTICSEARCH_URL=http://my-es.mydomain.com" -e "ELASTICSEARCH_PORT=9200" 
  -e "PATH_GLOB=/var/log/" -e "FILEBEAT_CONFIG_URL=http://cdn.mydomain.com/my-filebeat-config.yml" 
  -e "FILEBEAT_TEMPLATE_URL=http://cdn.mydomain.com/my-filebeat-template.json" -d filebeats:5.2.2
  ```
