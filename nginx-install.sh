#!/bin/bash
set -x
sudo apt-get update
sudo apt-get install nginx -y
# default root
#/usr/share/nginx/html

sudo mkdir -p /var/www/test1.dev/html
sudo mkdir -p /var/www/test2.default_server/html

sudo chown -R $USER:$USER /var/www/test1.dev/html
sudo chown -R $USER:$USER /var/www/test2.dev/html

sudo chmod -R 755 /var/www

sudo bash -c "cat > /var/www/test1.dev/html/index.html << EOF
<html>
    <head>
        <title>Welcome to test1.dev!</title>
    </head>
    <body>
        <h1>Success!  The test1.dev server block is working!</h1>
    </body>
</html>
EOF"

sudo bash -c "cat > /var/www/test2.dev/html/index.html << EOF
<html>
    <head>
        <title>Welcome to test1.dev!</title>
    </head>
    <body>
        <h1>Success!  The test1.dev server block is working!</h1>
    </body>
</html>
EOF"

sudo bash -c "cat > /etc/nginx/sites-available/test1.dev << EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    root /var/www/test1.dev/html;
    index index.html index.htm;

    server_name test1.dev www.test1.dev;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF"

sudo bash -c "cat > /etc/nginx/sites-available/test2.dev << EOF
server {
    listen 80;
    listen [::]:80;

    root /var/www/test2.dev/html;
    index index.html index.htm;

    server_name test2.dev www.test2.dev;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF"

sudo ln -s /etc/nginx/sites-available/test1.dev /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/test2.dev /etc/nginx/sites-enabled/

sudo rm /etc/nginx/sites-enabled/default

sudo sed -i "s/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf
sudo service nginx restart

sudo bash -c "echo 192.168.70.2 test1.dev >> /etc/hosts"
sudo bash -c "echo 192.168.70.2 test2.dev >> /etc/hosts"


