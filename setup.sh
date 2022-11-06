#!/bin/bash
sudo apt update
sudo mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
rm amazon-ssm-agent.deb
sudo apt install awscli -y
sudo apt install unzip -y
sudo apt install nginx -y
sudo ufw app list
sudo ufw allow 'Nginx HTTP'
sudo ufw status
sudo systemctl start nginx
sudo systemctl status nginx
sudo systemctl enable nginx
sudo mkdir /tmp/source
sudo cd /tmp/source
sudo aws s3 sync s3://nphc-vinod-s3-bucket .
sudo unzip sourcecode
sudo rm -f /var/www/html/*
sudo mv * /var/www/html/
sudo rm -f /var/www/html/sourcecode
sudo chown -R $USER:$USER /var/www/html
sudo chmod -R 755 /var/www/html
sudo systemctl reload nginx