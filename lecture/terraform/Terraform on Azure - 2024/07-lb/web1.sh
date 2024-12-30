#! /bin/bash

apt-get -y update
apt-get install -y apache2
service apache2 start
echo "<html>" >/var/www/html/index.html
echo "<body>" >>/var/www/html/index.html
echo "This is webserver1!" >> /var/www/html/index.html
echo "<img src=\"https://user00diagstorageblob.blob.core.windows.net/user00-content/test.jpg\">" >>/var/www/html/index.html
echo "</body>" >>/var/www/html/index.html
echo "</html>" >>/var/www/html/index.html
