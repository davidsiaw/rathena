#!/bin/sh
cd /src
mkdir -p /run/mysqld
if [ "$MYSQL_HOST" = "localhost" ] ||  [ "$MYSQL_HOST" = "127.0.0.1" ]; then
	ruby container/prepare.rb
	sh /src/container/install-mysql.sh
fi

# todo: load out server passwords and write to config if not yet

sleep 1

foreman start
