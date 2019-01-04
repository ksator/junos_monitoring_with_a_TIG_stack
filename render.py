# usage:
#
# Update devices details:
# vi data.yml
#
# To get help:
# python ./render.py -h
# python ./render.py --help
#
# Generate Telegraf configuration file for Openconfig:
# python ./render.py --output 'configs/telegraf-openconfig.conf' --template 'templates/telegraf-openconfig.j2' --yaml 'data.yml'
# python ./render.py -o 'configs/telegraf-openconfig.conf' -t 'templates/telegraf-openconfig.j2' -y 'data.yml'
#
# Generate Telegraf configuration file for SNMP:
# python ./render.py --output 'configs/telegraf-snmp.conf' --template 'templates/telegraf-snmp.j2' --yaml 'data.yml'
# python ./render.py -o 'configs/telegraf-snmp.conf' -t 'templates/telegraf-snmp.j2' -y 'data.yml'
#
# Generate docker-compose file
# python ./render.py -o 'docker-compose.yml' -t 'templates/docker-compose.j2' -y 'data.yml'


import yaml
from jinja2 import Template
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-o', '--output', help='rendered file')
parser.add_argument('-t', '--template', help='jinja template file')
parser.add_argument('-y', '--yaml', help='YAML variables file')
args = parser.parse_args()

# Start building telegraf configuration'

with open(args.yaml) as f:
  data=yaml.load(f.read())

with open(args.template) as f:
  template = Template(f.read(),lstrip_blocks=True, trim_blocks=True)

conf=open(args.output,'w')
conf.write(template.render(data))
conf.close()



