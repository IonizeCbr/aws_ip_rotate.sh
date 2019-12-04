# aws_ip_rotate.sh

* First install the aws cli `sudo apt install awscli`
* Set the following vars in the script
```
AWS_ACCESS_KEY_ID="SECRET_ID"
AWS_SECRET_ACCESS_KEY="SECRET_KEY"
```
* Set the IP and port of a known open ip and port of the target you are perform warranted nefarious acitivities upon
```
LIVE_IP="127.0.0.1" 
OPEN_PORT=443     
```
* Change the timeout of how often to check whether your EC2 instance has been blocked (optional)
```
TIMEOUT=60
```

Each time your ip is rotated it will be noted in `/tmp/ip_rotate`

This script has been specifically tailored to `--region ap-southeast-2` Asia Pacific (Sydney) which can be changed within script.
