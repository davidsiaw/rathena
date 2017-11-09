require "mysql2"

serverip = ENV["SERVER_IP"] || "127.0.0.1"
servername = ENV["SERVER_NAME"] || "rAthena"

loop do
	begin

		client = Mysql2::Client.new(host: ENV["MYSQL_HOST"], port: ENV["MYSQL_PORT"], username: ENV["MYSQL_USER"], password: ENV["MYSQL_PASSWORD"], database: ENV["MYSQL_DATABASE"])

		results = client.query("SELECT * FROM login WHERE sex = 'S'")

		charconf = File.read("/src/conf/char_athena.conf")
		mapconf = File.read("/src/conf/map_athena.conf")

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
		end

		File.write("/src/conf/char_athena.conf", charconf)
		File.write("/src/conf/map_athena.conf", mapconf)

		break;

	rescue
		sleep 1

	end
end
