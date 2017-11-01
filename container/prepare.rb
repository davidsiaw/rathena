require "securerandom"

charconf = File.read("conf/char_athena.conf")
mapconf = File.read("conf/map_athena.conf")
mainsql = File.read("sql-files/main.sql")


serverip = ENV["SERVER_IP"] || "127.0.0.1"

server_user = SecureRandom.hex(8)
server_pass = SecureRandom.hex(8)

mainsql = mainsql.sub("'s1', 'p1', 'S','athena@athena.com'", "'#{server_user}', '#{server_pass}', 'S','rathena@astrobunny.net'")

charconf = charconf.sub(/^userid: s1/m, "userid: "+server_user)
charconf = charconf.sub(/^passwd: p1/m, "passwd: "+server_pass)
charconf = charconf.sub(/char_ip: .+$/, "char_ip: "+serverip)
charconf = charconf.sub(/^server_name: rAthena/, "server_name: #{ENV["SERVER_NAME"]}")

mapconf = mapconf.sub(/^userid: s1/m, "userid: "+server_user)
mapconf = mapconf.sub(/^passwd: p1/m, "passwd: "+server_pass)
mapconf = mapconf.sub(/map_ip: .+$/, "map_ip: "+serverip)

File.write("conf/char_athena.conf", charconf)
File.write("conf/map_athena.conf", mapconf)
File.write("sql-files/main.sql", mainsql)

File.write("/etc/nginx/conf.d/default.conf", <<-NGINX_CONFIG
server {
    listen       8080 default_server sndbuf=32k;

    #charset koi8-r;

    #access_log  logs/host.access.log  main;

    include /etc/nginx/default.d/*.conf;

    location / {
        root   /var/www/static;
        index  index.html index.htm;
    }

    location /_stats {
        stub_status on;
    }

    error_page  404              /404.html;
    location = /404.html {
        root   /usr/share/nginx/html;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}

NGINX_CONFIG
)