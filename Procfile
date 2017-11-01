login: ruby container/wait_for_mysql.rb && ./login-server
char:  ruby container/wait_for_mysql.rb && ./char-server
map:   ruby container/wait_for_mysql.rb && ./map-server
web:   nginx -g 'daemon off;'
db:    mysqld --user=root
