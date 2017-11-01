#!/bin/sh
set -e

apk update
apk add build-base zlib-dev mariadb-dev ruby ruby-dev nginx

cd /src

./configure
make

echo gem: --no-document > ~/.gemrc

gem install foreman io-console mysql2

mkdir -p /var/www/static

