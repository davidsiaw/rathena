#!/bin/sh
cd /src
if [ "$MYSQL_HOST" = "localhost" ] ||  [ "$MYSQL_HOST" = "127.0.0.1" ]; then
	sh /src/container/install-mysql.sh

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
fi

sleep 1
foreman start