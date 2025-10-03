#!/bin/bash
# Control-M agent removal script
# October, 2019 - Robert Stinnett
# Home Repo: https://github.com/robertstinnett/control-m

# The purpose of this script is to remove a decomissioned Control-M agent from all hostgroups it may be in.
# Tested with Automation API v 9.19.130

# Usage:  agentremove [ctm environment] [agentname]

if [[ $# -lt 2 ]] ; then
    echo 'Usage:  agentremove [ctm environment] [agentname]'
    exit 1
fi

ctm_environment=$1
agent_name=$2

ctm config server:hostgroups::get $ctm_environment > ./hostgroups.json
hostgroups=$(<./hostgroups.json)
for hostgroup in $(echo "${hostgroups}" | jq -r '.[]'); do
    ctm config server:hostgroup:agents::get $ctm_environment $hostgroup > ./agent_list.json
    agent_list=$(<./agent_list.json)
    for agent in $(echo "${agent_list}" | jq -r '.[].host'); do
        if [ "$agent" = "$agent_name" ]; then
            ctm config server:hostgroup:agent::delete $ctm_environment $hostgroup $agent
            echo $agent was deleted from $hostgroup on $ctm_environment >> ./agentremove.log
        fi
    done
done


rm -rf ./agent_list.json
rm -rf ./hostgroups.json
