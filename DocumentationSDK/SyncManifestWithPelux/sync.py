#!/usr/bin/env python

import sys
from lxml.etree import parse

if len(sys.argv) < 3:
    exit(1)

filename_qtas = sys.argv[1]
filename_pelux = sys.argv[2]

doc_qtas = parse(filename_qtas)
doc_pelux = parse(filename_pelux)
root_qtas = doc_qtas.getroot()
root_pelux = doc_pelux.getroot()

pelux_projects = {}

for atype in root_pelux.findall('project'):
    pelux_projects[atype.get('name')] = { 'remote': atype.get('remote'), 
                                          'revision': atype.get('revision'), 
                                          'path': atype.get('path'), 
                                          'upstream': atype.get('upstream') }

for atype in root_qtas.findall('project'):
    if atype.get('name') in pelux_projects:
        temp = pelux_projects[atype.get('name')]
        atype.attrib['revision'] = temp['revision']
        atype.attrib['path'] = temp['path']
        if temp['upstream']:
            atype.attrib['upstream'] = temp['upstream']

doc_qtas.write(filename_qtas, xml_declaration = True)
