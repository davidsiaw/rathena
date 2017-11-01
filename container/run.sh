#!/bin/sh
cd /src
mkdir -p /run/mysqld
if [ "$MYSQL_HOST" = "localhost" ] ||  [ "$MYSQL_HOST" = "127.0.0.1" ]; then
	ruby container/prepare.rb
	sh /src/container/install-mysql.sh
fi

# todo: load out server passwords and write to config if not yet

sleep 1
mkdir -p /run/nginx
mkdir -p /var/www/
rm -rf /var/www/static
cp -r /patch/content /var/www/static
chmod -R 755 /var/www/static

foreman start
