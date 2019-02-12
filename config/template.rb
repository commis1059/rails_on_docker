# frozen_string_literal: true

inside "config" do
  gsub_file "database.yml", %r[^ {2}password:$], "  password: <%= ENV.fetch('DB_ROOT_PASSWORD') { 'password' } %>"
  gsub_file "database.yml", %r[^ {2}host: localhost$], "  host: db"
  gsub_file "database.yml", %r[^ {2}encoding: utf8$], "  encoding: utf8mb4\n  charset: utf8mb4\n  collation: utf8mb4_bin"

  gsub_file "webpacker.yml", %r[^ {4}host: localhost$], "    host: webpack"
end
