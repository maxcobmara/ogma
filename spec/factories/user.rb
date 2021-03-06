FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.define do
  factory :admin_user, :class => 'User' do
    email
    password '12345678'
    password_confirmation '12345678'
    after(:create) {|user| user.roles = [create(:admin_role)]}
  end

  factory :staff_user, :class => 'User' do
    sequence(:email) { |n| "slatest#{n}@example.com" }
    sequence(:login) { |n| "slatest#{n}@example.com" }
    password '12345678'
    password_confirmation '12345678'
    after(:create) {|user| user.roles = [create(:staff_role)]}
  end

  factory :admin_role, :class => 'Role' do
    name 'Administration'
    authname 'administration'
  end

  factory :staff_role, :class => 'Role' do
    name 'Staff'
    authname 'staff'
  end


end
