from pprint import pprint
import yaml
from jinja2 import Template

# print 'Start building telegraf configuration'

with open('data.yml') as f:
  data=yaml.load(f.read())

with open('templates/telegraf-openconfig.j2') as f:
  template = Template(f.read())

conf=open('configs/telegraf-openconfig.conf','w')
conf.write(template.render(data))
conf.close()

# print 'done'
