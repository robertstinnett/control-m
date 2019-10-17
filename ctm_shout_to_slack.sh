
#!/bin/bash
# Integrate Control-M Shouts with Slack
# Robert Stinnett
# Shout Msg comes through in %2 param
# Format:  channel,message

# Sample msg:  Parm 2 = test1,This is a test


incoming_msg=$2
hookurl=<Your Slack URL here>



channel=`echo $incoming_msg | cut -d ',' -f 1`
message=`echo $incoming_msg | cut -d ',' -f 2`

echo channel=$channel - message=$message >> /var/log/controlm/ctm_shout_slack.log

if [[ $message = *@here* ]]
then
    env -u LD_LIBRARY_PATH curl -H "Content-type: application/json" -X POST -d "{\"channel\":\"$channel\",\"text\":\"<!here> ${message//@here/}\"}" $hookurl
else
    env -u LD_LIBRARY_PATH curl -H "Content-type: application/json" -X POST -d "{\"channel\":\"$channel\",\"text\":\"$message\"}" $hookurl
fi

