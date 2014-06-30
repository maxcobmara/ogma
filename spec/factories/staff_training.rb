FactoryGirl.define do
  factory :ptbudget do
    budget {rand(10 ** 5)}
    fiscalstart {Time.at(rand * Time.now.to_f)}
  end
  
  factory :ptcourse do
     sequence(:name) { |n| "Course#{n} From OS" }
  end
end