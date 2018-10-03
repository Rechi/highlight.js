#! /usr/bin/python3

import json
import fileinput
import glob
import re
import subprocess
import xml.etree.ElementTree as ET


def getAddOnIds(root):
	for child in root:
		if child.tag == 'addon' and 'id' in child.attrib:
			yield child.attrib.get('id')

ADDONS_REPO = set()
with open('addons/builtin.json') as file:
	for a in json.loads(file.read()):
		if a.get('type') == 'dir':
			ADDONS_REPO.add(a.get('name').replace('.', '\.'))

with open('addons/binary.json') as file:
	for a in json.loads(file.read()):
		if a.get('type') == 'dir':
			ADDONS_REPO.add(a.get('name').replace('.', '\.'))

for filename in glob.iglob('addons/*/addons.xml', recursive=True):
	tree = ET.parse(filename)
	ADDONS_REPO = ADDONS_REPO.union(set(getAddOnIds(tree.getroot())))


ADDONS_BANNED = set()
with open('addons/banned.html') as file:
	for a in re.findall(re.compile(r'&lt;!--\s+ID:\s+(\S+)\s+-->'), file.read()):
		ADDONS_BANNED.update(re.split('[,|]', a))


ADDONS_REPO = subprocess.run(['regexp-assemble', '-n'], input = '\n'.join(ADDONS_REPO), encoding='ascii', stdout = subprocess.PIPE).stdout
ADDONS_BANNED = subprocess.run(['regexp-assemble', '-n'], input = '\n'.join(ADDONS_BANNED), encoding='ascii', stdout = subprocess.PIPE).stdout


with open('src/languages/kodi.js', 'w') as outfile:
	with open('src/languages/kodi.js.in', 'r', encoding='utf-8') as infile:
		for line in infile:
			outfile.write(line.replace('@ADDONS_REPO@', ADDONS_REPO).replace('@ADDONS_BANNED@', ADDONS_BANNED))
