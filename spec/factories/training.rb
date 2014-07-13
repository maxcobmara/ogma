FactoryGirl.define do
  
  factory :academic_session do
    semester {rand(1..2).to_s+"/"+(Date.today.year+rand(1..3)).to_s}
    total_week {rand(20..30)}
  end
  
  factory :timetable do
    sequence(:code) { |n| "Some Code_#{n}"} 
    sequence(:name) { |n| "Some Name_#{n}"}
    description "Some Description"
    association :creator, factory: :staff  #(user not ready)
    #created_by 1
  end
  
  factory :intake do
    name {Date.new(2014,rand(1..12),1).strftime("%b")+" "+(Date.today.year+rand(1..3)).to_s}
    description {rand(1..1000)}
    register_on {Date.today+(366*rand()).to_f}
    association :programme, factory: :programme
    is_active {rand(2) == 1}
    monthyear_intake {Date.new(Date.today.year+rand(1..3), [1,3,7,9].sample, 1)}
    #monthyear_intake {Date.new(Date.today.year+rand(1..3), [1,3,7,9][rand([1,3,7,9].length)], 1)}  
  end
  
  factory :timetable_period do 
    #timetable_id 1 
    association :timetable, factory: :timetable
    sequence(:sequence) { rand(1..15) }     #NOTE - field name is 'sequence'
    day_name { rand(1..7) }
    end_at {Time.at(rand * Time.now.to_f)}
    start_at {Time.at(rand * Time.now.to_f)}
    is_break {rand(2) == 1}
  end
  
end

