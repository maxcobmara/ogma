puts "Users"
Role.all.each do | r |
  User.create!({
    login:  r.authname,
    email:  "#{r.authname}@icms.com",
    password: "maximum8", password_confirmation: "maximum8",
    userable_id: r.id, userable_type: "Staff"
  })
end
