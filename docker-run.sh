docker run -ti -p 6900:6900 -p 6121:6121 -p 5121:5121 -p 8080:8080 -v /home/david/rize/client:/data -v /home/david/programs/rathena_sql:/var/lib/mysql -v /home/david/rize/client_static:/patch/content -e SERVER_IP=192.168.1.15 -e SERVER_NAME=Lunacy ra 