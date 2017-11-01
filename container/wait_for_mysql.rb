require "mysql2"

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
			mapconf = mapconf.sub(/^userid: [0-9a-z]+/m, "userid: "+server_user)
			mapconf = mapconf.sub(/^passwd: [0-9a-z]+/m, "passwd: "+server_pass)
		end

		File.write("/src/conf/char_athena.conf", charconf)
		File.write("/src/conf/map_athena.conf", mapconf)

		break;

	rescue
		sleep 1

	end
end
