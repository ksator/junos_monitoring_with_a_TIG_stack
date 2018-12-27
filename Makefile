build-data:
	@echo "======================================================================"
	@echo "Build data from data.yaml - monitoring-stack"
	@echo "======================================================================"
	python render-jinja.py -y data.yaml -t templates/telegraf.snmp.conf.j2 -o configs/telegraf.snmp.conf
	python render-jinja.py -y data.yaml -t templates/telegraf.conf.j2 -o configs/telegraf.conf

cli:
	docker exec -i -t grafana /bin/bash

restart: stop start

start:
	@echo "======================================================================"
	@echo "Start docker - monitoring-stack"
	@echo "======================================================================"
	docker-compose -f ./docker-compose.yml up -d --build

stop:
	@echo "======================================================================"
	@echo "Stop docker - monitoring-stack"
	@echo "======================================================================"
	docker-compose -f ./docker-compose.yml down

rm:
	@echo "======================================================================"
	@echo "Remove containers - monitoring-stack"
	@echo "======================================================================"
	docker-compose -f ./docker-compose.yml rm -s -f