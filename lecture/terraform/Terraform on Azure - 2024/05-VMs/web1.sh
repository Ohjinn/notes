#! /bin/bash

apt-get -y update
apt-get install -y apache2
service apache2 start
echo "This is webserver1!" > /var/www/html/index.html
