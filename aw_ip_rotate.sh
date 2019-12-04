#!/bin/bash
#FIRST ENSURE YOU HAVE INSTALLED `sudo apt install awscli`
#***************ID & SECRET KEY***************#
AWS_ACCESS_KEY_ID="SECRET_ID"
AWS_SECRET_ACCESS_KEY="SECRET_KEY"
#***************KNOWN LIVE IP & PORT***************#
LIVE_IP="127.0.0.1" 
OPEN_PORT=443        
#***************TIMEOUT***************#
TIMEOUT=60             #check duration 
#***************SET ENV VARS***************#
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
#***************IP Rotation LOOP***************#
trap "exit" INT
while :
do
    #Perform check to see if blocked
    nc -z -w3 $LIVE_IP $OPEN_PORT
    retval=$?
    if [ $retval -ne 0 ]; then
        OLD_ALLOC_ID=$NEW_ALLOC_ID
        #If blocked aquire new and release old address
        #Get an elastic ip address 
        NEW_ALLOC_ID=`aws ec2 allocate-address --region ap-southeast-2 | grep -oP '(?<="AllocationId": ")[^"]*'`
        #Associate the address with the ec2 instance
        aws ec2 associate-address --instance-id `wget -q -O - http://169.254.169.254/latest/meta-data/instance-id` --allocation-id $NEW_ALLOC_ID --region ap-southeast-2
        #Wait for the new address to show up in aws
        sleep 5
        #Record the currently allocated IP
        echo `printf "IP: %s allocated @ %s %s %s %s %s %s\n" $(curl http://169.254.169.254/latest/meta-data/public-ipv4) $(date)` >> /tmp/ip_rotate
        #Release the previous address
        if [ ! -z "$OLD_ALLOC_ID" ]; then
            aws ec2 release-address --allocation-id $OLD_ALLOC_ID --region ap-southeast-2
        fi
    fi
    sleep $TIMEOUT
done
