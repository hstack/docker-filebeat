#!/bin/sh

echo "Building filebeat..."

git clone https://github.com/elastic/beats.git
cd beats/filebeat
docker run --rm -w="/go/src/github.com/elastic/beats/filebeat" -v "$PWD:/go/src/github.com/elastic/beats/filebeat" golang make crosscompile

mv ./bin/filebeat-linux-386 ./../binary/filebeat
cd ..
rm -rf filebeat

echo "Done"
