require "securerandom"

mainsql = File.read("sql-files/main.sql")

server_user = SecureRandom.hex(8)
server_pass = SecureRandom.hex(8)

mainsql = mainsql.sub("'s1', 'p1', 'S','athena@athena.com'", "'#{server_user}', '#{server_pass}', 'S','rathena@astrobunny.net'")

File.write("sql-files/main.sql", mainsql)
