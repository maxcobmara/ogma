FactoryGirl.define do
  
  # Events
  factory :event do
    sequence(:event) { |n| "eventname#{n}" }
  end

end