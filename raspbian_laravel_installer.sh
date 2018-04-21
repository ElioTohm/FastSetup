# !/bin/bash

SERVER_NAME=192.168.39.95
PROJECT_PATH=/home/pi/project

apt-get update --fix-missing 
apt-get upgrade -y

apt-get install mysql nginx php7.1 php7.1-curl php7.1-gd php7.1-imap php7.1-json php7.1-mcrypt php7.1-mysql php7.1-opcache php7.1-xmlrpc php7.1-xml php7.1-fpm php7.1-mbstring php7.1-sqlite3 php7.1-zip composer -y

curl -sL https://deb.nodesource.com/setup_9.x | -E bash -
apt-get install -y nodejs

cat > /etc/nginx/sites-enabled/laravel <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root $PROJECT_PATH;
    index index.php index.html index.htm;
    server_name $SERVER_NAME;
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    location ~ \.php$ {
        try_files $uri /index.php =404;
        include                  fastcgi_params;
        fastcgi_keep_conn on;
        fastcgi_index            index.php;
        fastcgi_split_path_info  ^(.+\.php)(/.+)$;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_intercept_errors on;
        fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
    }
}
EOF

apt install samba samba-common-bin -y
cat > /etc/samba/smb.conf <<EOF
[pihome]
    comment= Pi Home
    path=/home/pi
    browseable=Yes
    writeable=Yes
    only guest=no
    create mask=0777
    directory mask=0777
    public=no
EOF

/etc/init.d/samba restart

smbpasswd -a pi