#!/bin/bash -e
# Deploy AI job types to hostgroups automatically in Control-M
# May 2022, Robert Stinnett
ctmenv=ctmenv
aijob=AINAME  
hostgroup=lgenbatch
ctm config server:hostgroup:agents::get $ctmenv $hostgroup | jq -r .[].host > /tmp/nodes.lst
while read node; do
  echo $node
  ctm deploy ai:jobtype $ctmenv $node $aijob
done </tmp/nodes.lst
