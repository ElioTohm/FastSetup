echo Running updates:
echo ================
echo
apt-get update --fix-missing 
apt-get upgrade -y

echo installing software properties:
echo ===============================
echo
# Install software-properties-common package to give us add-apt-repository package
apt-get install -y software-properties-common

#################################################
#      PHP                                      #
#################################################
echo add repo ondrej/php:
echo ===============================
echo
add-apt-repository ppa:ondrej/php
echo install php7.2:
echo ===============================
echo
apt-get install php7.2-cli \
php7.2-gd \
zip \
unzip \
composer \
php7.2 \
php7.2-curl \ 
php7.2-gd \
php7.2-imap \
php7.2-json \
php7.2-mysql \
php7.2-opcache \
php7.2-xmlrpc \
php7.2-xml \
php7.2-fpm \
php7.2-mbstring \
php7.2-sqlite3 \
php7.2-zip

#################################################
#      NGINX                                    #
#################################################
echo add repo nginx/stable:
echo ===============================
echo
# Install latest nginx version from community maintained ppa
add-apt-repository ppa:nginx/stable
# Update packages after adding ppa
apt-get update
echo install nginx:
echo ===============================
echo
# Install nginx
apt-get install -y nginx
# Check status
service nginx
# Start nginx if it is not already running
service nginx start

cat > /etc/nginx/sites-enabled/default <<EOF
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /home/user/IPTV/public;

	# A.php to the list if you are using PHP
	index index.php index.html index.htm index.nginx-debian.html;

	server_name _;

	location / {
		try_files $uri $uri/ /index.php$is_args$args;
	}

	location ~ \.php$ {
		try_files $uri /index.php =404;
		fastcgi_pass unix:/var/run/php/php7.2-fpm.sock; 
		fastcgi_index index.php;
		fastcgi_buffers 16 16k;
		fastcgi_buffer_size 32k;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		#fixes timeouts
		fastcgi_read_timeout 600;
		include fastcgi_params;
    	}

    	location ~ /\.ht {
        	deny all;
    	}

    	location /.well-known/acme-challenge/ {
        	root /var/www/letsencrypt/;
        	log_not_found off;
    	}
}
EOF

cat > /etc/nginx/nginx.conf << EOF
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 768;
	multi_accept on;
	use epoll;
}

http {
	# limit the number of connections per single IP
	limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:10m;

	# limit the number of requests for a given session
	limit_req_zone $binary_remote_addr zone=req_limit_per_ip:10m rate=5r/s;

	# zone which we want to limit by upper values, we want limit whole server
	server {
	    limit_conn conn_limit_per_ip 10;
	    limit_req zone=req_limit_per_ip burst=10 nodelay;
	}

	# if the request body size is more than the buffer size, then the entire (or partial)
	# request body is written into a temporary file
	client_body_buffer_size  128k;	
	
	send_timeout 2;
	reset_timedout_connection on;
	
	##
	# Basic Settings
	##
	server_tokens off;
	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 15;
	types_hash_max_size 2048;
	# server_tokens off;

	# server_names_hash_bucket_size 64;
	# server_name_in_redirect off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	##
	# SSL Settings
	##

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	##
	# Logging Settings
	##

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	##
	# Gzip Settings
	##

	gzip on;

	# gzip_vary on;
	# gzip_proxied any;
	# gzip_comp_level 6;
	# gzip_buffers 16 8k;
	# gzip_http_version 1.1;
	# gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
	gzip_disable msie6;
	##
	# Virtual Host Configs
	##

	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}

EOF

#################################################
#      NODEJS 9                                 #
#################################################

curl -sL https://deb.nodesource.com/setup_9.x | -E bash -
apt-get install -y nodejs


apt-get install -y mysql

