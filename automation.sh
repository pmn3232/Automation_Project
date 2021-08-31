#!/bin/bash

sudo apt update -y

myname=prashant
s3bucket=upgrad-prashantnakhate
packagename=apache2
timestamp=$(date '+%d%m%Y-%H%M%S')
inventory=/var/www/html/inventory.html

dpkg -s $packagename &> /dev/null  

if [ $? -ne 0 ]
then
     echo "installing $packagename now"  
     sudo apt-get update
     sudo apt-get install $name
else
     echo "$packagename is already installed"
fi

#start apache2
sudo systemctl start apache2

#enable apache2
sudo systemctl enable apache2

#creating archive of apache access logs
tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log

#copying archive to s3 bucket
aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3bucket}/${myname}-httpd-logs-${timestamp}.tar

#check if inventory.html file is present
if test -f "$inventory"
then
    	:
else
	sudo touch /var/www/html/inventory.html #create inventory file
	sudo chmod 777 $inventory -R
	echo -e "Log Type &emsp; Time Created &emsp; &emsp; Type &emsp; Size <br>" >> $inventory #add header
fi

#append content to inventory file
sudo chmod 777 $inventory -R
echo -e "\nhttpd-logs &ensp; ${timestamp} &ensp; tar &ensp; $(stat -c%s "$inventory")K <br>" >> $inventory

#create cronjob if not already
if [ ! -f /etc/cron.d/automation ]; 
then
	sudo echo -e "0 */5 * * * root /root/Automation_Project/automation.sh" >> /etc/cron.d/automation
fi
