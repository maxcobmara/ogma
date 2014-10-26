FactoryGirl.define do
  
  # Events  
  factory :event do
    sequence(:eventname) { |n| "eventname_#{n}" }
    end_at {Time.at(rand * Time.now.to_f)}
    start_at {Time.at(rand * Time.now.to_f)}
    location {"location_name"}
    staff
    #association :createdby, factory: :staff
    officiated {"random name"}
    participants {"random participant"}
  end
  
  factory :document do
    sequence(:serialno) { |n| "serial_#{n}" }
    sequence(:refno) { |n| "refno_#{n}" }
    sequence(:title) { |n| "title_#{n}" }
    sequence(:from) { |n| "from_#{n}" }
    category { Array(1..5).sample }
    association :stafffilled, factory: :staff
    association :cofile, factory: :cofile
  end
  
  factory :cofile do
    sequence(:name) { |n| "cofile_name_#{n}" }
    location 1
    association :owner, factory: :staff
  end
  
  factory :address_book do
    sequence(:name) { |n| "external_co_#{n}" }
  end

  factory :bulletin do
    headline {"Headline"}
    content {"this is conent"}
    association :staff, factory: :staff
    publishdt {Time.at(rand * Time.now.to_f)}
  end
end
