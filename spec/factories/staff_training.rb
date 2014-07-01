FactoryGirl.define do
  factory :ptbudget do
    budget {rand(10 ** 5)}
    fiscalstart {Time.at(rand * Time.now.to_f)}
  end
  
  factory :ptcourse do
     sequence(:name) { |n| "Course#{n} From OS" }
  end
  
  factory :ptschedule do
    #association :course, class: "Ptcourse", factory: :ptcourse
    ptcourse_id 1
    start {Time.at(rand * Time.now.to_f)}
    location "location name"
    min_participants 1
    max_participants 20
  end
  
  
end