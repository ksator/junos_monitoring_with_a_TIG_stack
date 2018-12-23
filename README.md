# About this repository 

How to monitor Junos devices using a TIG (Telegraf-Influxdb-Grafana) stack.  

For more information about Junos monitoring with telegraf and influxdb you can refer to these repositories:
- https://github.com/ksator/collect_telemetry_from_junos_with_telegraf 
- https://github.com/ksator/collect_snmp_with_telegraf 

The file [telegraf.conf](telegraf.conf) is a telegraf configuration file.  
It uses the `jti_openconfig_telemetry` input plugin (grpc client to collect telemetry on junos devices) and `influxbd` output plugin (database to store the data collected)

The yaml file [dashboards.yaml](dashboards.yaml) is a config file.  
This file contains a list of dashboards providers that will load dashboards into Grafana from the local filesystem.  
When Grafana starts, it will insert all dashboards json files available in the paths configured in [dashboards.yaml](dashboards.yaml)  

The directory [dashboards](dashboards) has dashboards json files  

The yaml file [datasource.yaml](datasource.yaml) is config file.  
This file contains a list of datasources that will be added during Grafana start up.  
 
The file [meta.db](meta.db) contains the influxdb databases and users. 
It has a database called juniper and a user 

# Requirements to use this repository

## Docker 
you need to install docker.  
This is not covered in this repository

## Junos

In order to collect data from Junos using openconfig telemetry, the devices require the Junos packages ```openconfig``` and ```network agent```

Starting with Junos OS Release 18.3R1: 
- the Junos OS image includes the ```OpenConfig``` package; therefore, you do not need anymore to install ```OpenConfig``` separately on your device.  
- the Junos OS image includes the ```Network Agent```, therefore, you do not need anymore to install the ```network agent``` separately on your device.  

If you are using an older Junos release, it is required to install these two packages. 

```
jcluser@vMX1> show version | match "Junos:|openconfig|na telemetry"
Junos: 18.2R1.9
JUNOS na telemetry [18.2R1-S3.2-C1]
JUNOS Openconfig [0.0.0.10-1]
```

### Junos configuration

This is required if you use the telegraf input plugin `snmp`
```
jcluser@vMX-1> show configuration snmp
community public;
```
This is required if you use the telegraf input plugin `jti_openconfig_telemetry`
```
jcluser@vMX-1> show configuration system services extension-service | display set
set system services extension-service request-response grpc clear-text port 32768
set system services extension-service request-response grpc skip-authentication
set system services extension-service notification allow-clients address 0.0.0.0/0
```
This is required if you use NETCONF
```
jcluser@vMX-1> show configuration system services netconf | display set
set system services netconf ssh
```

# How to use this repository

## pull docker images for influxdb, telegraf, grafana 
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
## Instanciate containers 
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


