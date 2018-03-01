#!/usr/bin/env python
import sys
from lxml.etree import parse

if len(sys.argv) < 3:
    exit(1)

filename = sys.argv[1]
revision = sys.argv[2]

doc = parse(filename)
root = doc.getroot()

for atype in root.findall('project'):
    remote   = atype.get('remote')
    name     = atype.get('name')
    if remote == "pcore" and name == "uxteam/meta-qtas-demo":
        atype.attrib['revision']=revision

doc.write(filename, xml_declaration=True)
