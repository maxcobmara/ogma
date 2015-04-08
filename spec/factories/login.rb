FactoryGirl.define do

   factory :login do
     id 11
     staff_id 25
     login "maslinda"
     sequence(:email) { |n| "slatest#{n}@example.com" }
     password {(0..40).map{ rand(10).to_s}.join }
     ##encrypted_password {(0..40).map{rand(10).to_s}.join }
     #crypted_password {(0..40).map{rand(10).to_s}.join }

   end
end
