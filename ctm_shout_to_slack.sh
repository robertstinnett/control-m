#!/bin/bash
# Integrate Control-M Shouts with Slack
# Robert Stinnett, robert@robertstinnett.com
# Shout Msg comes through in %2 param
# Format:  channel,message

# Sample msg:  Parm 2 = test1,This is a test


incoming_msg=$2
hookurl=<YOUR WEBHOOK HERE>



channel=`echo $incoming_msg | cut -d ',' -f 1`
message=`echo $incoming_msg | cut -d ',' -f 2`

# Change the location below to where you want to store your logs at.
echo channel=$channel - message=$message >> /var/log/controlm/ctm_shout_slack.log

if [[ $message = *@here* ]]
then
    env -u LD_LIBRARY_PATH curl -H "Content-type: application/json" -X POST -d "{\"channel\":\"$channel\",\"text\":\"<!here> ${message//@here/}\", \"link_names\": \"true\"}" $hookurl
else
    env -u LD_LIBRARY_PATH curl -H "Content-type: application/json" -X POST -d "{\"channel\":\"$channel\",\"text\":\"$message\", \"link_names\": \"true\"}" $hookurl
fi


