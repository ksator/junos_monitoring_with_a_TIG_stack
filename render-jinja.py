"""Render JINJA2 template

Basic python script to render JINJA2 file using YAML file as an input

Attributes:
    CONFFILE (TYPE): Output generated with OPTIONS.output
    OPTIONS (TYPE): User defined entries
    PARSER (TYPE): JINJA2 parser
    TEMPLATE (TYPE): JINJA2 template
"""

from pprint import pprint
import argparse
import yaml
from jinja2 import Template


def display_help():
    """Display Help
    """
    print ""


# Manage cmdLine parameters.
PARSER = argparse.ArgumentParser(description="Configuration Builder")
PARSER.add_argument('-v', '--verbose', help='Increase Verbosity', action="store_true")
PARSER.add_argument('-y', '--yaml', help='Provides YAML file to fill Jinja2 template',
                    default='dict.yml')
PARSER.add_argument('-t', '--template', help='template file, default=./template.j2',
                    default='./template.j2')
PARSER.add_argument('-o', '--output', help='File to save rendered file', default="demo.conf")
# Manage All options and construct array
OPTIONS = PARSER.parse_args()

print 'Start configuration building'
# YAML file.
with open(OPTIONS.yaml) as fh:
    DATA = yaml.load(fh.read())

if OPTIONS.verbose:
    pprint(DATA)

# Jinja2 template file.
with open(OPTIONS.template) as T_FH:
    T_FORMAT = T_FH.read()

TEMPLATE = Template(T_FORMAT)

CONFFILE = open(OPTIONS.output, 'w')
CONFFILE.write(TEMPLATE.render(DATA))
CONFFILE.close()

print 'End of Script'
