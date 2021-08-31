

#!/bin/bash

sudo apt update -y

myname=prashant
s3bucket=upgrad-prashantnakhate
packagename=apache2
timestamp=$(date '+%d%m%Y-%H%M%S')


dpkg -s $packagename &> /dev/null  

if [ $? -ne 0 ]
then
     echo "installing $packagename now"  
     sudo apt-get update
     sudo apt-get install $packagename
else
     echo "$packagename is already installed"
fi

echo "starting apache2"
sudo systemctl start apache2

echo "enabling apache2"
sudo systemctl enable apache2

echo "creating archive of apache access logs"
tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log

echo "copying archive to s3 bucket"
aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3bucket}/${myname}-httpd-logs-${timestamp}.tar


