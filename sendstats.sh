#!/bin/bash
# Script to control QR's via shout destination in Control-M
# February, 2020 - Robert Stinnett
# Password for API user should reside in ctm.pass file locatged in $HOME_DIR
# Shout should be in the format of %%JOBID,emailaddress

# Directory on CTM/Server this script lives in.
#HOME_DIR=/var/opt/ctmserver/scripts/  
HOME_DIR=./
# Control-M Data Center Name
datacenter="datacenter"

# Automation API endpoint
aapi="https://point.to.your.ctm/automation-api"

# User credentials for Control-M API
CTM_USER=apiuser
CTM_PASSWORD_FILE=${HOME_DIR}ctm.pass
CTM_PASSWORD=$(<$CTM_PASSWORD_FILE)

# Get shout from Control-M, arrives in 2nd parameter
incoming_msg=$2

jobid=`echo $incoming_msg | cut -d ',' -f 1`
destemail=`echo $incoming_msg | cut -d ',' -f 2`

# Logon to Automation API
token=`curl -sS -k -H "Content-Type: application/json" -X POST -d "{\"username\":\"$CTM_USER\",\"password\":\"$CTM_PASSWORD\"}" $aapi/session/login | jq .token | sed "s/\"//g" `

# Get job stats
job_stats=`curl -sS -k -H "Authorization: Bearer $token" -H "Content-Type: application/json" -X GET $aapi/run/job/$datacenter:$jobid/status `

# Get start time
echo $job_stats | jq .startTime

# Get end time
echo $job_stats | jq .endTime


