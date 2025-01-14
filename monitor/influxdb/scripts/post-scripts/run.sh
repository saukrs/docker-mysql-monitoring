#!/bin/bash

pip install influxdb

if [ $? -eq 0 ]
then
  echo "Installed influxdb python lib"
else
  echo "Failed to install influxdb python lib" >&2
  exit 1
fi

for i in {60..0}; do
    if curl -G "http://${INFLUXDB_HOST}:8086/query?pretty=true" --data-urlencode "q=show databases" | grep prometheus > /dev/null; then
        break
    fi

    echo 'Waiting for InfluxDB to startup and create prometheus database...'
    sleep 3
done

if [ $i -eq 0 ] ; then
  echo "InfluxDB failed to startup" >&2
  exit 1
fi

curl -o /tmp/influxdb_cq.py https://raw.githubusercontent.com/percona/grafana-dashboards/main/misc/influxdb_cq.py > /dev/null
#curl -o /tmp/influxdb_cq.py https://raw.githubusercontent.com/percona/grafana-dashboards/a4ec800bbddde49d3193080058d629e51255064b/misc/influxdb_cq.py > /dev/null

if [ $? -eq 0 ]
then
  echo "Downloaded continuous queries from github"
else
  echo "Continuous queries download failed" >&2
  exit 1
fi

sed -i "s/localhost/influxdb/" /tmp/influxdb_cq.py

if [ $? -eq 0 ]
then
  echo "Updated influxdb host"
else
  echo "Updating influxdb host failed" >&2
  exit 1
fi

python2 /tmp/influxdb_cq.py --exit-on-cq
