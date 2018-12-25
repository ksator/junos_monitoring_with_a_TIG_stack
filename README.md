# About this repository 

How to monitor Junos devices using a TIG stack (Telegraf-Influxdb-Grafana).  

# About Telegraf

Telegraf is an open source collector written in GO.  
Telegraf collects data and writes them into a database.  
It is plugin-driven (it has input plugins, output plugins, ...)  

To monitor Junos, we can use the telegraf input plugin `jti_openconfig_telemetry` (grpc client to collect telemetry on junos devices) and the telegraf input plugin `snmp`  

Telegraf has an output plugin to write the data collected to Influxdb. It supports others output plugins as well. 

# About Influxdb

Influxdb is an open source time series database written in GO.  

# About Grafana 

Grafana is an open source tool used to visualize time series data.  
It supports InfluxDB and other backends.  
It runs as a web application.  
It is written in GO.  

# About a TIG stack

A TIG stack uses: 
- Telegraf to collect data and to write the collected data in Influxdb
- Influxdb to store the data collected
- Grafana to visualize the data stored in Influxdb

# Looking for more information about Junos monitoring with telegraf and influxdb 

you can refer to these repositories:
- https://github.com/ksator/collect_telemetry_from_junos_with_telegraf 
- https://github.com/ksator/collect_snmp_with_telegraf 

# About the repository content

## Telegraf
The file [telegraf.conf](telegraf.conf) is a telegraf configuration file.  
It uses the telegraf `jti_openconfig_telemetry` input plugin (grpc client to collect telemetry on junos devices) and `influxbd` output plugin (database to store the data collected)  
It will create the influxdb database `juniper` and the influxdb user `juniper` with a password `juniper`  

You can also use the telegraf `snmp` input plugin to monitor Junos.   

## Grafana

The file [datasource.yaml](datasource.yaml) is config file.  
It contains a list of datasources that will be added during Grafana start up.  

The file [dashboards.yaml](dashboards.yaml) is a config file.  
It contains a list of dashboards providers that will load dashboards into Grafana from the local filesystem.  
When Grafana starts, it will insert all dashboards json files available in the paths configured in the file [dashboards.yaml](dashboards.yaml)  

The directory [dashboards](dashboards) has dashboards json files  

## docker-compose

The docker-compose file [docker-compose.yml](docker-compose.yml) can be used to start a TIG stack.  

# Requirements to use this repository

## Docker 

You need to install docker.  

Check if Docker is already installed 
```
$ docker --version
```

If it was not already installed, install it. Here's how to install in on Ubuntu 16.04:  
```
$ sudo apt-get update
```
```
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
```
```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
```
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```
```
$ sudo apt-get update
```
```
$ sudo apt-get install docker-ce
```
```
$ sudo docker run hello-world
```
```
$ sudo groupadd docker
```
```
$ sudo usermod -aG docker $USER
```

Exit the ssh session to your ubuntu and open an new ssh session to your ubuntu and run these commands to verify you installed Docker properly:  
```
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/
```
```
$ docker --version
Docker version 18.03.1-ce, build 9ee9f40
```


## Docker compose 

you need to install docker compose.  

Check if docker compose is already installed 
```
$ docker-compose --version
```

If it was not already installed, install it. Here's how to install in on Ubuntu 16.04:  
```
$ sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
```
Apply executable permissions to the binary:
```
$ sudo chmod +x /usr/local/bin/docker-compose
```
Verify
```
$ docker-compose --version
```


## Junos

In order to collect data from Junos using openconfig telemetry, the devices require the Junos packages ```openconfig``` and ```network agent```  
Starting with Junos OS Release 18.3R1, the Junos OS image includes these 2 packages; therefore, you do not need anymore to install them separately on your device.  
If you are using an older Junos release, it is required to install these two packages separately.  

Run this command to verify: 
```
jcluser@vMX1> show version | match "Junos:|openconfig|na telemetry"
```

### Junos configuration

This sort of configuration is required if you use the telegraf input plugin `snmp`
```
jcluser@vMX-1> show configuration snmp
community public;
```
This sort of configuration is required if you use the telegraf input plugin `jti_openconfig_telemetry`
```
jcluser@vMX-1> show configuration system services extension-service | display set
set system services extension-service request-response grpc clear-text port 32768
set system services extension-service request-response grpc skip-authentication
set system services extension-service notification allow-clients address 0.0.0.0/0
```
This sort of configuration is required if you use NETCONF
```
jcluser@vMX-1> show configuration system services netconf | display set
set system services netconf ssh
```

# How to use this repository

You can use of one these two differents workflows: 
- docker compose workflow 
- docker workflow 

## Docker compose workflow 

### clone the repository
```
$ git clone https://github.com/ksator/junos_monitoring_with_a_TIG_stack.git
$ cd junos_monitoring_with_a_TIG_stack
```

### Update the telegraf input plugin [telegraf.conf](telegraf.conf)
```
$ vi telegraf.conf
```

### Start containers

Run this command to start containers using the [docker-compose.yml](docker-compose.yml) file.  
This will pull the required docker images.  
This will instanciate 3 containers (Telegraf, Influxdb, Grafana)  
The 3 containers will be connected to same network  

Telegraf will be instanciate with the telegraf configuration file [telegraf.conf](telegraf.conf)   
It will collect data from Junos according to the telegraf input plugin configuration in [telegraf.conf](telegraf.conf)  
It will create on the influxdb container the database `juniper` and the user `juniper` with a password `juniper`    
It will store the data collected in the database `juniper` of the influxdb container using the user `juniper`  

The grafana container will load all dashboards json files from the directory [dashboards](dashboards)  
It will use the influxdb container as indicated in the [datasource.yaml](datasource.yaml) config file.  



```
$ docker-compose -f docker-compose.yml up -d
```
Run this command to list containers
```
$ docker-compose ps
```
```
$ docker ps
```
Run this command to list networks
```
$ docker network ls
```

### Use Grafana GUI 
You can now use the Grafana GUI `http://host_ip_address:3000`.  
The default username and password are admin/admin.  
You should see the dashboards from the directory [dashboards](dashboards)  
You can create your own dashboards.  

### stop and remove containers and networks 

Run this command to stop and remove containers and networks 
```
$ docker-compose -f docker-compose.yml down
```

Run these commands to verify
```
$ docker-compose ps
```
```
$ docker ps
```
```
$ docker ps -a
```
```
$ docker network ls
```

## Docker workflow 

### clone the repository
```
$ git clone https://github.com/ksator/junos_monitoring_with_a_TIG_stack.git
$ cd junos_monitoring_with_a_TIG_stack
```

### Update the telegraf input plugin [telegraf.conf](telegraf.conf)
```
$ vi telegraf.conf
```

### pull docker images for influxdb, telegraf, grafana 
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
$ docker image 
```
### Create a network 

Create a network 
```
$ docker network create tig
```
verify
```
$ docker network ls
```

### Instanciate containers 

#### influxdb container

Run this command to instanciate an influxdb container  
The Influxdb container will be connected to the network tig.  

```
$ docker run -d --name influxdb \
-p 8083:8083 -p 8086:8086 \
--network=tig \
influxdb:1.7.2
```

#### Telegraf container

Run this command to instanciate a telegraf container with the telegraf configuration file [telegraf.conf](telegraf.conf)   
The Telegraf container will be connected to the network tig.  
This container will collect data from Junos according to the telegraf input plugin configuration in [telegraf.conf](telegraf.conf)  
It will create on the influxdb container the database `juniper` and the user `juniper` with a password `juniper`    
It will store the data collected in the database `juniper` of the influxdb container using the user `juniper`  

```
$ docker run -d --name telegraf \
-v $PWD/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
--network=tig \
telegraf:1.9.1
```

#### Grafana container

Run this command to instanciate a Grafana container.  
The Grafana container will be connected to the network tig.  
The container will load all dashboards json files from the directory [dashboards](dashboards)  
The container will use the influxdb container as indicated in the [datasource.yaml](datasource.yaml) config file.  

```
$ docker run -d --name grafana \
-p 3000:3000 \
-v $PWD/datasource.yaml:/etc/grafana/provisioning/datasources/datasource.yaml:ro \
-v $PWD/dashboards.yaml:/etc/grafana/provisioning/dashboards/dashboards.yaml:ro \
-v $PWD/dashboards:/var/tmp/dashboards \
--network=tig \
grafana/grafana:5.4.2
```

#### Verify  

Run this command to list running containers
```
$ docker ps 
```
Run this command to display detailed information on the tig network
```
$ docker network inspect tig
```

### Use Grafana GUI 
You can now use the Grafana GUI `http://host_ip_address:3000`.  
The default username and password are admin/admin.  
You should see the dashboards from the directory [dashboards](dashboards)  
You can create your own dashboards.  

# Demo

# Troubleshooting guide

## telegraf

for troubleshooting purposes you can run this command
```
$ docker logs telegraf
```
start a shell session in the telegraf container
```
$ docker exec -it telegraf bash
```
Run this command to print the telegraf version
```
# telegraf --version
```
verify the telegraf configuration file
```
# more /etc/telegraf/telegraf.conf
```
exit the telegraf container
```
# exit
```

## Influxdb 

for troubleshooting purposes you can run this command
```
$ docker logs influxdb
```
start a shell session in the influxdb container
```
$ docker exec -it influxdb bash
```
run this command to read the influxdb configuration file
```
# more /etc/influxdb/influxdb.conf
```
Run the command influx
```
# influx
Connected to http://localhost:8086 version 1.7.2
InfluxDB shell version: 1.7.2
Enter an InfluxQL query
```
To list the users, run this command.
```
> show users
user    admin
----    -----
juniper false
```
To list the databases, run this command.
```
> show databases
name: databases
name
----
_internal
juniper
```
Run this command to list measurements 
```
> use juniper
Using database juniper
> show measurements
name: measurements
name
----
/interfaces/
/network-instances/network-instance/protocols/protocol/bgp/
>
```
Sessions state on device 100.123.1.0. This query returns the most recent datapoint
```
> SELECT "/network-instances/network-instance/protocols/protocol/bgp/neighbors/neighbor/state/session-state" from "/network-instances/network-instance/protocols/protocol/bgp/" WHERE device='100.123.1.0' ORDER BY DESC LIMIT 1
name: /network-instances/network-instance/protocols/protocol/bgp/
time                /network-instances/network-instance/protocols/protocol/bgp/neighbors/neighbor/state/session-state
----                -------------------------------------------------------------------------------------------------
1545574801370098016 ESTABLISHED
```
repeat the same query and check if the timestamp changed
```
> SELECT "/network-instances/network-instance/protocols/protocol/bgp/neighbors/neighbor/state/session-state" from "/network-instances/network-instance/protocols/protocol/bgp/" WHERE device='100.123.1.0' ORDER BY DESC LIMIT 1
name: /network-instances/network-instance/protocols/protocol/bgp/
time                /network-instances/network-instance/protocols/protocol/bgp/neighbors/neighbor/state/session-state
----                -------------------------------------------------------------------------------------------------
1545574807371068091 ESTABLISHED
>
```
```
> exit
# 
```
exit the influxdb container
```
# exit
```
## Grafana

for troubleshooting purposes you can run this command
```
$ docker logs grafana
```

## Junos

### connections
Run this command to show system connections activity
```
jcluser@MX1> show system connections
```

### sensors

Run this command to check the sensors on Junos
```
jcluser@vMX1> show agent sensors
```

### packages 

The Junos packages `openconfig` and `na telemetry` are required for Openconfig telemetry.  
Starting with Junos OS Release 18.3R1, the Junos OS image includes them, therefore, you do not need anymore to install them separately on your device.  
If your devices are running an older Junos release, you need to install them separately.  

Run this command to validate your Junos devices are using these 2 packages: 
```
jcluser@vMX1> show version | match "Junos:|openconfig|na telemetry"
```

### configuration 

Run these commands to verify your Junos devices are running an appropriate configuration for snmp and openconfig telemetry
```
jcluser@vMX-1> show configuration snmp | display set
```
```
jcluser@vMX-1> show configuration system services extension-service | display set
```
```
jcluser@vMX-1> show configuration system services netconf | display set
```

### YANG 
Run this command to show YANG packages installed on Junos: 
```
jcluser@vMX-1> show system yang package
```

Run this command to list YANG modules available on Junos: 
```
jcluser@vMX-1> file list /opt/yang-pkg/junos-openconfig/yang/
```

Run this command to know which `reference` of a YANG module is used on a Junos device.   
Example with openconfig-interfaces.yang YANG module
```
jcluser@vMX-1> file more /opt/yang-pkg/junos-openconfig/yang/openconfig-interfaces.yang
```

Run this command to understand which YANG deviations are used on a Junos device:
```
jcluser@vMX-1> file more /opt/yang-pkg/junos-openconfig/yang/jnx-openconfig-dev.yang
```

