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
    timetable_id 1 
    #association :timetable, factory: :timetable
    sequence(:sequence) { rand(1..15) }     #NOTE - field name is 'sequence'
    day_name { rand(1..7) }
    end_at {Time.at(rand * Time.now.to_f)}
    start_at {Time.at(rand * Time.now.to_f)}
    is_break {rand(2) == 1}
  end
  
  factory :programme do
    sequence(:code) { |n| "0#{n}" }
    sequence(:ancestry_depth) {|n| "#{n}"}
    sequence(:name) { |n| "Programme_#{n}"}
    sequence(:course_type) { |n| "Course Type #{n}"}
    #sequence(:ancestry) { |n| "#{n}"}
    #sequence(:combo_code) { |n| "0#{n}-"+code}
  end
  
    #if programme --> course type diploma/pos basik/diploma lanjutan && ancestry depth=0
    #if programme --> course type semester ancestry_depth=1
    
    factory :weeklytimetable do
      #programme_id 1
      intake_id 1
      association :schedule_programme, factory: :programme
      #association :intake, factory: :intake
      startdate {Date.today+(366*rand()).to_f}
      enddate {Date.today+(366*rand())+(4*rand()).to_f}
      semester {rand(6)}
      #prepared_by 1
      #endorsed_by 1
      #format1 1
      #format2 2
      association :schedule_creator, factory: :staff
      association :schedule_approver, factory: :staff
      association :timetable_monthurs, factory: :timetable
      association :timetable_friday, factory: :timetable
      week {rand(26)}
      is_submitted {rand(2) == 1}
      submitted_on {Date.today+(366*rand()).to_f}
      hod_approved {rand(2) == 1}
      hod_approved_on {Date.today+(366*rand()).to_f}
      hod_rejected {rand(2) == 1}
      hod_rejected_on {Date.today+(366*rand()).to_f}
      reason "Some Reasons"
    end
  
end

