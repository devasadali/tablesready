# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

CreatePlanService.new.call
puts "Plans created!"

# Create Country
Country.create(name: "United States of America",code: "USA",phone_code: "+1")
Country.create(name: "Canada",code: "CA",phone_code: "+1")
Country.create(name: "United Kingdom",code: "UK",phone_code: "+44")
Country.create(name: "Pakistan",code: "PK",phone_code: "+92")

CreateAdminService.new.call
puts "AdminUser created!"