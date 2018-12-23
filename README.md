pull docker images for influxdb, telegraf, grafana 
```
$ docker pull influxdb:1.7.2
```
```
$ docker pull telegraf:1.9.1
```
```
$ docker pull grafana/grafana:5.4.2
```
verify 
```
$ docker image grafana/grafana
```
```
$ docker image telegraf
```
```
$ docker image influxdb
```
Instanciate containers 
```
$ docker run -d --name influxdb \
-p 8083:8083 -p 8086:8086 \
-v $PWD/meta.db:/var/lib/influxdb/meta/meta.db \
influxdb:1.7.2
```
```
$ docker run -d --name telegraf \
-v $PWD/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
telegraf:1.9.1
```
```
$ docker run -d --name grafana \
-p 9081:3000 \
-v $PWD/datasource.yaml:/etc/grafana/provisioning/datasources/datasource.yaml:ro \
-v $PWD/dashboards.yaml:/etc/grafana/provisioning/dashboards/dashboards.yaml:ro \
-v $PWD/dashboards:/var/tmp/dashboards \
grafana/grafana:5.4.2
```
Verify 
```
$ docker ps 
```


