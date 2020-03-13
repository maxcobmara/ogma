# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
heavy_false_data = [[true, 1],[false,99]]

puts "Creating Academic Sessions"
(2012..2020).each do | y |
  AcademicSession.create!([
    {semester: "1/#{y}", total_week: 26},
    {semester: "2/#{y}", total_week: 26}
  ])
end

puts "Not Creating Accessions"


puts "Creating Address Book"
60.times do
  comp = Faker::Company.name
  domain  = comp.parameterize.underscore
  AddressBook.create!({
    name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.street_address,
    mail: "#{Faker::Name.first_name}@#{domain}.com",
    web: "www.#{domain}.com",
    fax: Faker::PhoneNumber.phone_number,
    shortname: nil
  })
end

puts "Load Asset File"


puts "Not creating Attachments"
puts ""
