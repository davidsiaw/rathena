require "mysql2"

serverip = ENV["SERVER_IP"] || "127.0.0.1"
servername = ENV["SERVER_NAME"] || "rAthena"

loop do
	begin

		client = Mysql2::Client.new(host: ENV["MYSQL_HOST"], port: ENV["MYSQL_PORT"], username: ENV["MYSQL_USER"], password: ENV["MYSQL_PASSWORD"], database: ENV["MYSQL_DATABASE"])

		results = client.query("SELECT * FROM login WHERE sex = 'S'")

		charconf = File.read("/src/conf/char_athena.conf")
		mapconf = File.read("/src/conf/map_athena.conf")
		interconf = File.read("/src/conf/inter_athena.conf")

		results.each do |row|

			server_user = row["userid"]
			server_pass = row["user_pass"]

			charconf = charconf.sub(/^userid: [0-9a-z]+/m, "userid: "+server_user)
			charconf = charconf.sub(/^passwd: [0-9a-z]+/m, "passwd: "+server_pass)
			charconf = charconf.sub(/^char_ip: .+$/, "char_ip: "+serverip)
			charconf = charconf.sub(/^server_name: .+$/, "server_name: #{servername}")

			mapconf = mapconf.sub(/^userid: [0-9a-z]+/m, "userid: "+server_user)
			mapconf = mapconf.sub(/^passwd: [0-9a-z]+/m, "passwd: "+server_pass)
			mapconf = mapconf.sub(/^map_ip: .+$/, "map_ip: "+serverip)

			interconf = interconf.sub(/^login_server_ip: 127.0.0.1/m, "login_server_ip: "+ENV["MYSQL_HOST"])
			interconf = interconf.sub(/^login_server_port: 3306/m,    "login_server_port: "+ENV["MYSQL_PORT"])
			interconf = interconf.sub(/^login_server_id: ragnarok/m,  "login_server_id: "+ENV["MYSQL_USER"])
			interconf = interconf.sub(/^login_server_pw: ragnarok/m,  "login_server_pw: "+ENV["MYSQL_PASSWORD"])
			interconf = interconf.sub(/^login_server_db: ragnarok/m,  "login_server_db: "+ENV["MYSQL_DATABASE"])

			interconf = interconf.sub(/^ipban_db_ip: 127.0.0.1/m, "ipban_db_ip: "+ENV["MYSQL_HOST"])
			interconf = interconf.sub(/^ipban_db_port: 3306/m,    "ipban_db_port: "+ENV["MYSQL_PORT"])
			interconf = interconf.sub(/^ipban_db_id: ragnarok/m,  "ipban_db_id: "+ENV["MYSQL_USER"])
			interconf = interconf.sub(/^ipban_db_pw: ragnarok/m,  "ipban_db_pw: "+ENV["MYSQL_PASSWORD"])
			interconf = interconf.sub(/^ipban_db_db: ragnarok/m,  "ipban_db_db: "+ENV["MYSQL_DATABASE"])

			interconf = interconf.sub(/^char_server_ip: 127.0.0.1/m, "char_server_ip: "+ENV["MYSQL_HOST"])
			interconf = interconf.sub(/^char_server_port: 3306/m,    "char_server_port: "+ENV["MYSQL_PORT"])
			interconf = interconf.sub(/^char_server_id: ragnarok/m,  "char_server_id: "+ENV["MYSQL_USER"])
			interconf = interconf.sub(/^char_server_pw: ragnarok/m,  "char_server_pw: "+ENV["MYSQL_PASSWORD"])
			interconf = interconf.sub(/^char_server_db: ragnarok/m,  "char_server_db: "+ENV["MYSQL_DATABASE"])

			interconf = interconf.sub(/^map_server_ip: 127.0.0.1/m, "map_server_ip: "+ENV["MYSQL_HOST"])
			interconf = interconf.sub(/^map_server_port: 3306/m,    "map_server_port: "+ENV["MYSQL_PORT"])
			interconf = interconf.sub(/^map_server_id: ragnarok/m,  "map_server_id: "+ENV["MYSQL_USER"])
			interconf = interconf.sub(/^map_server_pw: ragnarok/m,  "map_server_pw: "+ENV["MYSQL_PASSWORD"])
			interconf = interconf.sub(/^map_server_db: ragnarok/m,  "map_server_db: "+ENV["MYSQL_DATABASE"])

			interconf = interconf.sub(/^log_db_ip: 127.0.0.1/m, "log_db_ip: "+ENV["MYSQL_HOST"])
			interconf = interconf.sub(/^log_db_port: 3306/m,    "log_db_port: "+ENV["MYSQL_PORT"])
			interconf = interconf.sub(/^log_db_id: ragnarok/m,  "log_db_id: "+ENV["MYSQL_USER"])
			interconf = interconf.sub(/^log_db_pw: ragnarok/m,  "log_db_pw: "+ENV["MYSQL_PASSWORD"])
			interconf = interconf.sub(/^log_db_db: ragnarok/m,  "log_db_db: "+ENV["MYSQL_DATABASE"])
		end

		File.write("/src/conf/char_athena.conf", charconf)
		File.write("/src/conf/map_athena.conf", mapconf)
		File.write("/src/conf/inter_athena.conf", interconf)

		break;

	rescue
		sleep 1

	end
end
