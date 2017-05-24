#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Parses TF state file to extract devices where volumes where mapped.
# Volumes not provisioned in the TF run will be listed as unk_1, unk_2 and
# so on.

import argparse
import json
from collections import defaultdict

# Arguments parsing
parser = argparse.ArgumentParser(
    description='Parses TF state file to obtain volumes mapping.')
parser.add_argument('state_file', type=str, nargs=1,
                    help='Path to the Terraform state file')
parser.add_argument('output_file', type=str, nargs=1, help='Output file')

args = parser.parse_args()

state = json.load(open(args.state_file[0]))
# Parse state file
volumes = defaultdict(dict)
volumes_mapping = defaultdict(dict)

resources = state['modules'][0]['resources']
for name, resource in resources.iteritems():
    # Got a volume, parse id and name
    if resource['type'].startswith("openstack_blockstorage_volume_v"):
        volumes[resource['primary']['attributes']['id']] = {
            #'name': resource['primary']['attributes']['name']}
            'name': name.split(".")[1]}

    if resource['type'] == 'openstack_compute_volume_attach_v2':
        # Got a volume attach, extract the info
        volumes_mapping[resource['primary']['attributes']['id']] = {
                'attachment_id' : resource['primary']['attributes']['id'],
                'device': resource['primary']['attributes']['device'],
                'volume_id': resource['primary']['attributes']['volume_id']
            }


# Output construction
unk_counter = 1
json_dict = {}
for volume in volumes_mapping.values():
    volumes[volume['volume_id']]['device'] = volume['device']
    if 'name' not in volumes[volume['volume_id']]:
        volumes[volume['volume_id']]['name'] = "unk_{}".format(unk_counter)
        unk_counter += 1

    volume_name = '{}'.format(
        volumes[volume['volume_id']]['name']).replace("-", "_")
    json_dict[volume_name] = volumes[volume['volume_id']]['device']

json.dump(json_dict, open(args.output_file[0], 'w'))
