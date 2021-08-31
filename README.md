# Automation_Project

This project is has a script which does following-
1) Checks if Apache is installed. If not, it installs it
2) Runs and enables Apache
3) Creates a archive of apache2 access logs and copy it to your AWS S3 bucket
4) Keeps a record of logs files getting copied to S3 bucket. Logs are stoed in inventory.html file
5) Creates a cronjob that will run this script everyday.
