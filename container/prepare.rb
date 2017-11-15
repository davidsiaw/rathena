require "securerandom"
require "digest"

mainsql = File.read("sql-files/main.sql")
loginconf = File.read("/src/conf/login_athena.conf")

server_user = SecureRandom.hex(8)
server_pass = SecureRandom.hex(8)
server_pass_x = server_pass

if loginconf.include? "use_MD5_passwords: yes"
	server_pass_x = Digest::MD5.hexdigest(server_pass)
end

mainsql = mainsql.sub("'s1', 'p1', 'S','athena@athena.com'", "'#{server_user}', '#{server_pass_x}', 'S', 'rathena@astrobunny.net'")
mainsql = mainsql.sub("'non_hashed_s1', 'p1', 'S','original@athena.com'", "'non_hashed_s1', '#{server_pass}', 'S', 'original@astrobunny.net'")

File.write("sql-files/main.sql", mainsql)
