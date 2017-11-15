require "mysql2"

serverip = ENV["SERVER_IP"] || "127.0.0.1"
servername = ENV["SERVER_NAME"] || "rAthena"

loop do
	begin

		client = Mysql2::Client.new(host: ENV["MYSQL_HOST"], port: ENV["MYSQL_PORT"], username: ENV["MYSQL_USER"], password: ENV["MYSQL_PASSWORD"], database: ENV["MYSQL_DATABASE"])

		results = client.query("SELECT * FROM login WHERE account_id = '1'")
		result_non_hashed = client.query("SELECT * FROM login WHERE account_id = '2'")

		loginconf = File.read("/src/conf/login_athena.conf")
		charconf = File.read("/src/conf/char_athena.conf")
		mapconf = File.read("/src/conf/map_athena.conf")
		interconf = File.read("/src/conf/inter_athena.conf")

		server_user = ""
		server_pass = ""

		results.each do |row|
			server_user = row["userid"]
		end

		result_non_hashed.each do |row|
			server_pass = row["user_pass"]
		end

		charconf = charconf.sub(/^userid: [0-9a-z]+/m, "userid: "+server_user)
		charconf = charconf.sub(/^passwd: [0-9a-z]+/m, "passwd: "+server_pass)
		charconf = charconf.sub(/^char_ip: .+$/, "char_ip: "+serverip)
		charconf = charconf.sub(/^server_name: .+$/, "server_name: #{servername}")

		mapconf = mapconf.sub(/^userid: [0-9a-z]+/m, "userid: "+server_user)
		mapconf = mapconf.sub(/^passwd: [0-9a-z]+/m, "passwd: "+server_pass)
		mapconf = mapconf.sub(/^map_ip: .+$/, "map_ip: "+serverip)

		interconf = interconf.sub(/^login_server_ip: 127.0.0.1/m, "login_server_ip: "+ENV["MYSQL_HOST"])
		interconf = interconf.sub(/^login_server_port: [0-9]+/m,    "login_server_port: "+ENV["MYSQL_PORT"])
		interconf = interconf.sub(/^login_server_id: [0-9a-z]+/m,  "login_server_id: "+ENV["MYSQL_USER"])
		interconf = interconf.sub(/^login_server_pw: [0-9a-z]+/m,  "login_server_pw: "+ENV["MYSQL_PASSWORD"])
		interconf = interconf.sub(/^login_server_db: [0-9a-z]+/m,  "login_server_db: "+ENV["MYSQL_DATABASE"])

		interconf = interconf.sub(/^ipban_db_ip: 127.0.0.1/m, "ipban_db_ip: "+ENV["MYSQL_HOST"])
		interconf = interconf.sub(/^ipban_db_port: [0-9]+/m,    "ipban_db_port: "+ENV["MYSQL_PORT"])
		interconf = interconf.sub(/^ipban_db_id: [0-9a-z]+/m,  "ipban_db_id: "+ENV["MYSQL_USER"])
		interconf = interconf.sub(/^ipban_db_pw: [0-9a-z]+/m,  "ipban_db_pw: "+ENV["MYSQL_PASSWORD"])
		interconf = interconf.sub(/^ipban_db_db: [0-9a-z]+/m,  "ipban_db_db: "+ENV["MYSQL_DATABASE"])

		interconf = interconf.sub(/^char_server_ip: 127.0.0.1/m, "char_server_ip: "+ENV["MYSQL_HOST"])
		interconf = interconf.sub(/^char_server_port: [0-9]+/m,    "char_server_port: "+ENV["MYSQL_PORT"])
		interconf = interconf.sub(/^char_server_id: [0-9a-z]+/m,  "char_server_id: "+ENV["MYSQL_USER"])
		interconf = interconf.sub(/^char_server_pw: [0-9a-z]+/m,  "char_server_pw: "+ENV["MYSQL_PASSWORD"])
		interconf = interconf.sub(/^char_server_db: [0-9a-z]+/m,  "char_server_db: "+ENV["MYSQL_DATABASE"])

		interconf = interconf.sub(/^map_server_ip: 127.0.0.1/m, "map_server_ip: "+ENV["MYSQL_HOST"])
		interconf = interconf.sub(/^map_server_port: [0-9]+/m,    "map_server_port: "+ENV["MYSQL_PORT"])
		interconf = interconf.sub(/^map_server_id: [0-9a-z]+/m,  "map_server_id: "+ENV["MYSQL_USER"])
		interconf = interconf.sub(/^map_server_pw: [0-9a-z]+/m,  "map_server_pw: "+ENV["MYSQL_PASSWORD"])
		interconf = interconf.sub(/^map_server_db: [0-9a-z]+/m,  "map_server_db: "+ENV["MYSQL_DATABASE"])

		interconf = interconf.sub(/^log_db_ip: 127.0.0.1/m, "log_db_ip: "+ENV["MYSQL_HOST"])
		interconf = interconf.sub(/^log_db_port: [0-9]+/m,    "log_db_port: "+ENV["MYSQL_PORT"])
		interconf = interconf.sub(/^log_db_id: [0-9a-z]+/m,  "log_db_id: "+ENV["MYSQL_USER"])
		interconf = interconf.sub(/^log_db_pw: [0-9a-z]+/m,  "log_db_pw: "+ENV["MYSQL_PASSWORD"])
		interconf = interconf.sub(/^log_db_db: [0-9a-z]+/m,  "log_db_db: "+ENV["MYSQL_DATABASE"])
	

		File.write("/src/conf/char_athena.conf", charconf)
		File.write("/src/conf/map_athena.conf", mapconf)
		File.write("/src/conf/inter_athena.conf", interconf)

		break;

	rescue
		sleep 1

	end
end
