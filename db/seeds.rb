# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Server.create([{
  name: 'US-East',
  host: 'localhost',
  secret_key: "MDACBsrfnElnEGzL",
  port: 3402,
  server_type: :file,
  state: :down,
  status: :inactive,
  uptime: 0,
}, {
  secret_key: "zQhufNiR9iDXlyQU",
  port: 3403,
  host: "localhost",
  name: "Asia-Pacific",
  server_type: :file,
  state: :down,
  status: :inactive,
  uptime: 0,
}, {
  secret_key: "xLWDSEcrhElRpWjX",
  port: 3400,
  host: "localhost",
  name: "US-Virginia",
  server_type: :kdc,
  state: :down,
  status: :inactive,
  uptime: 0,
}, {
  secret_key: "weHgSPoiUy6WgSk0",
  port: 3401,
  host: "localhost",
  name: "US-Virginia",
  server_type: :balancer,
  state: :down,
  status: :inactive,
  uptime: 0,
}])