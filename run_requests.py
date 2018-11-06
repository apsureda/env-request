#!/usr/bin/python

"""Generate Terraform configuration files from a set of predefined templates.

Copyright 2018 Alfonso Palacios <alpalacios@google.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

import argparse
import os
from jinja2 import Environment
from jinja2 import FileSystemLoader
import yaml
import sys
import logging
import json
import re

TEMPLATE_FOLDER = '/workspace/env-request/'
TF_OUT_FOLDER = TEMPLATE_FOLDER + 'terraform/'
REQUESTS_FILE = 'requests.yaml'
tf_config = None

def parse_args(argv):
  parser = argparse.ArgumentParser()
  parser.add_argument('--template-dir', default=TEMPLATE_FOLDER,
                      help='location of tf template files')
  parser.add_argument('--tf-out', default=TF_OUT_FOLDER,
                      help='directory where the generated Terraform files should be written')
  parser.add_argument('--requests', default=REQUESTS_FILE,
                      help='yaml file containing the environment creation requests')
  return parser.parse_args(argv)

def get_requests(requests_file):
  # open the requests file, which is in YAML format
  stream = open(requests_file, "r")
  req_stream = yaml.load_all(stream)
  all_requests = {}
  defaults = None
  allowed_first_level = ['config', 'defaults', 'requests']
  mandatory_req_fields = ['name', 'type']
  global tf_config
  # YAML files can have multiple "documents" go through the file and append all the
  # elements in a single map
  for doc in req_stream:
    for k,v in doc.items():
      # first level items must only contained one of the allowed keys
      if k not in allowed_first_level:
        logging.error('invalid key \'%s\' in requests file' % (k))
        sys.exit(1)
      # get the config section, which must appear only once
      if k == 'config':
        if not tf_config:
          tf_config = v
        else:
          logging.error('\'%s\' defined twice in requests file' % (k))
          sys.exit(1)
      # the defaults section must appear only once
      if k == 'defaults':
        if not defaults:
          defaults = v
        else:
          logging.error('\'%s\' defined twice in requests file' % (k))
          sys.exit(1)
      # append all the requests in a single dictionary
      if k == 'requests':
        for req in v:
          # check if we are missing any of the mandatory fields
          for mf in mandatory_req_fields:
            if not mf in req:
              logging.error('mandatory field \'%s\' missing in request %s' % (mf, req))
              sys.exit(1)
          # the value of the 'name' attribute will be the key in our map
          rk = req['name']
          # check that the request name is unique
          if rk in all_requests:
            logging.error('duplicate declaration of requests with name \'%s\'' % (rk))
            sys.exit(1)
          all_requests[rk] = req
  # now that we have all the requests, apply the default values, if not defined at the request level
  for rk,rv in all_requests.items():
    req_defaults = {}
    # apply first the global defaults
    if 'global' in defaults:
      req_defaults = defaults['global']
    # override BU defaults, if any
    if 'dft_bu' in rv and rv['dft_bu'] in defaults:
      bu_defaults = defaults[rv['dft_bu']]
      for dk,dv in bu_defaults.items():
        req_defaults[dk] = dv
    # now apply the defaults to the request, only of not defined at that level
    if len(req_defaults) > 0:
      for dk,dv in req_defaults.items():
        if dk not in all_requests[rk]:
          all_requests[rk][dk] = dv
  # add  autogenerated values to env requests
  for v in all_requests.values():
    prepare_context(all_requests, v)
  return all_requests

def prepare_context(requests, context):
  if context['type'] in ['sandbox', 'appengine', 'database']:
    context['short_id'] = get_short_id(context)
    context['project_id'] = get_project_id(context)
  if context['type'] == 'sandbox':
    # In sandbox environments, operations, managers and the dandbox user are owners
    permissions = {}
    permissions['owner'] = context['team_ops'] + context['team_mng'] 
    if 'user_email' in context:
      permissions['owner'].extend([context['user_email']])
    # the rest of the dev team has view access to the sandbox project
    permissions['viewer'] = context['team_dev']
    context['permissions'] = permissions
  elif context['type'] == 'database':
    # In database projects, the DBA team members have admin access to Cloud SQL instances
    permissions = {}
    permissions['cloudsql.admin'] = context['team_dba']
    context['permissions'] = permissions
  elif context['type'] == 'appengine':
    permissions = {}
    permissions['dev'] = {}
    permissions['dev']['appengine.deployer'] = context['team_dev'] 
    permissions['dev']['appengine.serviceAdmin'] = context['team_dev'] 
    permissions['dev']['appengine.appAdmin'] = context['team_ops'] + context['team_mng'] 
    # use a placeholder for the cloudbuild service account. Will be replaced in jinja tempolate.
    permissions['dev']['appengine.appAdmin'].extend(['[CLOUDBUILD_SA]'])
    permissions['test'] = {}
    permissions['test']['appengine.codeViewer'] = context['team_dev'] + context['team_qa']
    permissions['test']['appengine.serviceAdmin'] = context['team_ops'] 
    permissions['test']['appengine.appViewer'] = context['team_mng'] 
    permissions['test']['appengine.appAdmin'] = ['[CLOUDBUILD_SA]']
    permissions['prod'] = {}
    permissions['prod']['appengine.codeViewer'] = context['team_dev'] + context['team_qa']
    permissions['prod']['appengine.serviceAdmin'] = context['team_ops'] 
    permissions['prod']['appengine.appViewer'] = context['team_mng']
    permissions['prod']['appengine.appAdmin'] = ['[CLOUDBUILD_SA]']
    context['permissions'] = permissions
    # set up databases
    if 'databases' in context:
      for database in context['databases']:
        # check that mandatory params have been set in each database declaration
        for attr in ['db_project', 'name', 'environment', 'instance']:
          if not attr in database:
            logging.error('required attribute \'%s\' missing from database in request \'%s\'.' % (attr, context['name']))
            sys.exit(1)
        db_name = database['name']
        db_project = database['db_project']
        db_instance = database['instance']
        # check that the database project has been defined as a request
        if not db_project in requests:
          logging.error('database project (\'%s\') referenced by request \'%s\' has not been defined as a request.' %
                        (db_project, db_name))
          sys.exit(1)
        db_request = requests[db_project]
        # check that the requested instance has been defined in the db project
        if not db_instance in db_request['instances']:
          logging.error('instance (\'%s\') referenced by request \'%s\' not found in db project \'%s\'.' % 
                        (db_instance, db_name, db_project))
          sys.exit(1)
        if not 'databases' in db_request['instances'][db_instance]:
          db_request['instances'][db_instance]['databases'] = []
        db_request['instances'][db_instance]['databases'].append(database)

def prepare_folders(requests):
  # full path -> folder struct dictionary
  all_folders = {}
  for request in requests.values():
    if not 'folder' in request:
      continue
    # remove '/' chars from begining and end of folder path
    req_folder = request['folder'].strip('/')
    request['folder'] = req_folder

    folder_parts = req_folder.split('/')
    if len(folder_parts) > 4:
      logging.error('invalid folder: \'%s\'. Folders can be nested up to four levels deep.' % (req_folder))
      sys.exit(1)
    
    # check folder names and make folder list
    parent_path = None
    for i in range(len(folder_parts)):
      current_part = folder_parts[i]
      current_path = '/'.join(folder_parts[:i+1])
      # check that folder name is valid
      if len(current_part) > 30:
        logging.error('invalid folder name: \'%s\'. Names cannot be longer than 30 chars.' % (current_part))
        sys.exit(1)
      if not re.match('^[A-Za-z0-9].*[A-Za-z0-9]$', current_part):
        logging.error('invalid folder name: \'%s\'. Must start and end with a letter or digit.' % (current_part))
        sys.exit(1)
      if not re.match('^[A-Za-z0-9\s\-\'!]+$', current_part):
        logging.error('invalid folder name: \'%s\'. Must contain letters, numbers, quotes, hyphens, '
                      'spaces or exclamation points.' % (current_part))
        sys.exit(1)
      # add the current folder to the folder list if not there yet
      if not current_path in all_folders:
        folder_struct = {}
        # id to be used in terraform files
        folder_struct['folder_id'] = current_path.replace('/', '_')
        folder_struct['folder_name'] = current_part
        if parent_path:
          folder_struct['parent_id'] = parent_path.replace('/', '_')
          folder_struct['parent_path'] = parent_path
        all_folders[current_path] = folder_struct
      # add the terraform folder id to the current request
      request['folder_id'] = all_folders[current_path]['folder_id']
      # pass on the current path to the next folder level
      parent_path = current_path
  return all_folders

def get_short_id(req_config):
  base_name = ''
  if req_config['type'] == 'appengine':
    base_name = '%s-%s' % (req_config['dft_bu'], req_config['name'])
  elif req_config['type'] == 'sandbox':
    base_name = '%s-sb-%s' % (req_config['dft_bu'], req_config['name'])
  elif req_config['type'] == 'database':
    base_name = 'db-%s' % (req_config['name'])
  return base_name.lower()

def get_project_id(req_config):
  project_id = 'dft-' + get_short_id(req_config)
  # check if the full project ID, with the environment and random suffixes added 
  # meets the GCP project ID requirements
  sample_name = project_id
  project_id_length = len(sample_name)
  # appengine projects have a -dev, -test, -prod suffix
  if req_config['type'] in ['appengine']:
    sample_name += '-prod'
  # random suffixes add an additionad 5 chars (-ABCD)
  if req_config['random_suffix'] == 'true':
    sample_name += '-abcd'
  # check the project ID length
  if len(sample_name) > 30:
    logging.error('invalid project ID: \'%s\'. Project ID must be between 6 and 30 characters.' % (sample_name))
    sys.exit(1)
  # check the project ID respects naming constraints
  if not re.match('^[a-z].*[a-z0-9]$', sample_name):
    logging.error('invalid project ID: \'%s\'. Project IDs must start with a lowercase letter and end with a letter or number.' % (sample_name))
    sys.exit(1)
  if not re.match('^[a-z0-9\-]+$', sample_name):
    logging.error('invalid project ID: \'%s\'. Project IDs can have lowercase letters, digits, or hyphens.' % (sample_name))
    sys.exit(1)
  return project_id

def generate_tf_files(template_dir, tf_out, tpl_type, prefix, context, replace):
  # initialize jinja2 environment for tf templates
  env = Environment(loader=FileSystemLoader(template_dir), trim_blocks=True)
  # check for templates with the current template type
  template_list = []
  if os.path.isdir(template_dir + '/' + tpl_type):
    template_list = os.listdir(template_dir + '/' + tpl_type)
  if len(template_list) == 0:
    logging.warn('no templates found for request of type \'%s\'' % (tpl_type))
    return False

  # if replace requested, remove previous files. If not requested but previous files
  # present, return.
  for prev_file in os.listdir(tf_out):
    if prev_file.startswith(prefix + '_'):
      if replace:
        os.remove(tf_out + '/' + prev_file)
        logging.debug('removing previous file: \'%s\'' %(prev_file))
      else:
        logging.info('ignoring request \'%s\'. Found previous terraform config files.' % (prefix))
        return False
  # apply the selected templates
  logging.info('using context: %s' % (json.dumps(context, sort_keys=True)))

  for tplfile in template_list:
    # remove junk files
    if tplfile.startswith('.'):
      continue
    template = env.get_template(tpl_type + '/' + tplfile)
    out_file_name = prefix + '_' + tplfile
    logging.debug('generating config file: \'%s\'' % (out_file_name))
    out_file = open(tf_out + '/' + out_file_name, "w")
    out_file.write(template.render(context=context))
    out_file.close()
  return True

def main(template_dir, tf_out, requests_file):
  # load the environment requests from the requests file
  envrequests = get_requests(requests_file)

  # create output directory if it doesn't exist yet
  if not os.path.exists(tf_out):
    os.makedirs(tf_out)

  # get the likst of folders
  folders = prepare_folders(envrequests)
  # and add it to the context to be used in common files
  tf_config['folders'] = folders

  # regenerate the common files (always refreshed)
  generate_tf_files(template_dir, tf_out, 'common', 'common', tf_config, True)

  # generate the tf files of the requested environments
  for k,v in envrequests.items():
    logging.info('processing request: \'%s\'' % (k))
    # ask for file regeneration if indicate din requests file
    regenerate = False
    if 'force_update' in v and v['force_update'] == 'true':
      regenerate = True
    file_type = v['type']
    generate_tf_files(template_dir, tf_out, file_type, v['short_id'], v, regenerate)

if __name__ == '__main__':
  logging.getLogger().setLevel(logging.INFO)
  FORMAT = '%(asctime)-15s %(levelname)s %(message)s'
  logging.basicConfig(format=FORMAT)
  args = parse_args(sys.argv[1:])
  main(args.template_dir, args.tf_out, args.requests)