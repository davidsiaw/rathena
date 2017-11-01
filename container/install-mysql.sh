#!/bin/sh

apk add mysql mysql-client

#plagiarized from wangxian/alpine-mysql
if [ -d /var/lib/mysql/mysql ]; then
  echo "[i] MySQL directory already present, skipping creation"
else
  echo "[i] MySQL data directory not found, creating initial DBs"

  mysql_install_db --user=root > /dev/null

  if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
    MYSQL_ROOT_PASSWORD=111111
    echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
  fi

  MYSQL_DATABASE=${MYSQL_DATABASE}
  MYSQL_USER=${MYSQL_USER}
  MYSQL_PASSWORD=${MYSQL_PASSWORD}

  if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
  fi

  tfile=`mktemp`
  if [ ! -f "$tfile" ]; then
      return 1
  fi

  cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
DROP USER ''@'${HOSTNAME}';
DROP USER 'root'@'${HOSTNAME}';
DROP USER 'root'@'localhost';
DROP USER 'root'@'127.0.0.1';
DROP USER 'root'@'::1';
DROP USER ''@'localhost';
UPDATE user SET password=PASSWORD("${MYSQL_ROOT_PASSWORD}") WHERE user='root' AND host='%';
EOF

  if [ "$MYSQL_DATABASE" != "" ]; then
    echo "[i] Creating database: $MYSQL_DATABASE"
    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

    if [ "$MYSQL_USER" != "" ]; then
      echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
      echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
    fi
  fi

  /usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
  rm -f $tfile
    
  mysqld --user=root &

  sleep 5

  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/item_cash_db.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/item_db2.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/logs.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/mob_db2.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/mob_skill_db.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/mob_skill_db_re.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/item_cash_db2.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/item_db2_re.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/main.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/mob_db2_re.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/mob_skill_db2.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/roulette_default_data.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/item_db.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/item_db_re.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/mob_db.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/mob_db_re.sql
  mysql --user=root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < sql-files/mob_skill_db2_re.sql

  killall mysqld

fi
