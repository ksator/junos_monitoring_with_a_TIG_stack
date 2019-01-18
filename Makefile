build-telegraf-conf:
	@echo "======================================================================"
	@echo "Build telegraf configuration files from template"
	@echo "======================================================================"
	python ./render.py -o 'configs/telegraf-openconfig.conf' -t 'templates/telegraf-openconfig.j2' -y 'data.yml'
	python ./render.py -o 'configs/telegraf-snmp.conf' -t 'templates/telegraf-snmp.j2' -y 'data.yml'

grafana-cli:
	@echo "======================================================================"
	@echo "start a shell session in the grafana container"
	@echo "======================================================================"
	docker exec -i -t grafana /bin/bash

telegraf-openconfig-cli:
	@echo "======================================================================"
	@echo "start a shell session in the telegraf container for Openconfig"
	@echo "======================================================================"
	docker exec -i -t telegraf-openconfig /bin/bash

telegraf-snmp-cli:
	@echo "======================================================================"
	@echo "start a shell session in the telegraf container for SNMP"
	@echo "======================================================================"
	docker exec -i -t telegraf-snmp /bin/bash

influxdb-cli:
	@echo "======================================================================"
	@echo "start a shell session in the influxb container"
	@echo "======================================================================"
	docker exec -it influxdb bash

influxdb-logs:
	@echo "======================================================================"
	@echo "fetch the 100 last lines of logs of the influxb container"
	@echo "======================================================================"
	docker logs influxdb --tail 100

grafana-logs:
	@echo "======================================================================"
	@echo "fetch the 100 last lines of logs of the grafana container"
	@echo "======================================================================"
	docker logs grafana --tail 100

telegraf-snmp-logs:
	@echo "======================================================================"
	@echo "fetch the 100 last lines of logs of the telegraf-snmp container"
	@echo "======================================================================"
	docker logs telegraf-snmp --tail 100

telegraf-openconfig-logs:
	@echo "======================================================================"
	@echo "fetch the 100 last lines of logs of the telegraf-openconfig container"
	@echo "======================================================================"
	docker logs telegraf-openconfig --tail 100

restart: stop start

up:
	@echo "======================================================================"
	@echo "create docker-compose file, create docker networks, pull docker images, create and start docker containers"
	@echo "======================================================================"
	python ./render.py -o 'docker-compose.yml' -t 'templates/docker-compose.j2' -y 'data.yml'
	docker-compose -f ./docker-compose.yml up -d

down:
	@echo "======================================================================"
	@echo "stop docker containers, remove docker containers, remove docker networks"
	@echo "======================================================================"
	docker-compose -f ./docker-compose.yml down

start:
	@echo "======================================================================"
	@echo "Start docker containers"
	@echo "======================================================================"
	docker-compose -f ./docker-compose.yml start

stop:
	@echo "======================================================================"
	@echo "Stop docker containers"
	@echo "======================================================================"
	docker-compose -f ./docker-compose.yml stop
