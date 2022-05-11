#!/bin/bash

sudo su

yum update -y

yum install -y httpd.x86_64

systemctl start httpd.service

systemctl enable httpd.service

echo "Hello world DEV_SERVER" > /var/www/html/index.html