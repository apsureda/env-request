#!/usr/bin/python

import os
from jinja2 import Environment
from jinja2 import FileSystemLoader

out_folder = 'terraform/'

env = Environment(loader=FileSystemLoader('templates/sandbox'), trim_blocks=True)

short_id = 'sb-alpalacios2'
current = {
  'short_id' : short_id,
  'project_id': 'dft-ddt-'+short_id,
  'folder_id' : '710298211377',
  'owners': ['group:gcp-ddt-ops@apszaz.com', 'group:gcp-ddt-mamagers@apszaz.com', 'user:Dennis.Ritchie@apszaz.com'],
  'viewers': ['group:gcp-ddt-developers@apszaz.com']
}

common = {
  'gcs_bucket' : 'apszaz-tfstate',
  'gcs_prefix' : 'dft-ddt-draco'
}

if not os.path.exists(out_folder):
    os.makedirs(out_folder)

for tplfile in os.listdir('templates/sandbox'):
  if tplfile.startswith('.'):
    continue
  print('loading template ' + tplfile)
  template = env.get_template(tplfile)
  out_file = open(out_folder + '/' + short_id + '_' + tplfile, "w")
  out_file.write(template.render(current=current))
  out_file.close()
  

env = Environment(loader=FileSystemLoader('templates/common'), trim_blocks=True)
for tplfile in os.listdir('templates/common'):
  if tplfile.startswith('.'):
    continue
  print('loading template ' + tplfile)
  template = env.get_template(tplfile)
  out_file = open(out_folder + '/common_' + tplfile, "w")
  out_file.write(template.render(common=common))
  out_file.close()
