FROM alpine:3.6

COPY . /src

ENV MYSQL_HOST=localhost \
	MYSQL_PORT=3306 \
	MYSQL_DATABASE=ragnarok \
	MYSQL_USER=ragnarok \
	MYSQL_PASSWORD=ragnarok \
	MYSQL_ROOT_PASSWORD=yggdrasil

RUN sh /src/container/provision.sh

VOLUME /data
EXPOSE 6900/tcp 6121/tcp 5121/tcp

CMD ["sh", "/src/container/run.sh"]