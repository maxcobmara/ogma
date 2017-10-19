# require 'spec_helper'
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

  factory :programme do
    sequence(:code) { |n| "0#{n}" }
    sequence(:ancestry_depth) {|n| "#{n}"}
    sequence(:name) { |n| "Programme_#{n}"}
    #sequence(:course_type) { |n| "Course Type #{n}"}
    course_type {["Diploma", "Pos Basik Diploma Lanjutan", "Semester", "Subject", "Commonsubject", "Topic", "Subtopic"].sample}
    #sequence(:ancestry) { |n| "#{n}"}
    #sequence(:combo_code) { |n| "0#{n}-"+code}
  end

    #if programme --> course type diploma/pos basik/diploma lanjutan && ancestry depth=0
    #if programme --> course type semester ancestry_depth=1

    factory :weeklytimetable, class: Weeklytimetable do
      #programme_id 1
      intake_id 1
      programme_id 1
      #association :schedule_programme, factory: :programme
      #association :intake, factory: :intake
      startdate {Date.today+(366*rand()).to_f}
      enddate {Date.today+(366*rand())+(4*rand()).to_f}
      semester {rand(6)}
      #association :schedule_creator, factory: :staff
      #association :schedule_approver, factory: :staff
      #association :timetable_monthurs, factory: :timetable
      #association :timetable_friday, factory: :timetable
      format1 1
      format2 2
      week {rand(26)}
      is_submitted {rand(2) == 1}
      submitted_on {Date.today+(366*rand()).to_f}
      hod_approved {rand(2) == 1}
      hod_approved_on {Date.today+(366*rand()).to_f}
      hod_rejected {rand(2) == 1}
      hod_rejected_on {Date.today+(366*rand()).to_f}
      reason "Some Reasons"
    end

    factory :weeklytimetable_detail do
      #association :weeklytimetable_subject, factory: :programme
      #association :weeklytimetable_topic, factory: :programme
      #association :weeklytimetable_lecturer, factory: :staff
      association :weeklytimetable, factory: :weeklytimetable
      day2 {[1,2,3,4,6,7].sample}
      is_friday {rand(2) == 1}
      #association :fridayslot, factory: :timetable_period
      #association :monthurslot, factory: :timetable_period
      location "Some location"
      #association :weeklytimetable_location, factory: :location
      lecture_method {rand(1..3)}
    end

    factory :lesson_plan, class: LessonPlan do
      #association :lessonplan_owner, factory: :staff
      #association :lessonplan_intake, factory: :intake
      sequence(:student_qty) { |n| "#{n}" }
      #semester {rand(1..6)}
      #topic {|n| "#{n}"}#depends on relationship with weeklytimetable_details table
      #lecture_title "Some Lecture Title"
      #lecture_date {Date.today+(366*rand()).to_f}
      #start_time {Time.at(rand * Time.now.to_f)}
      #end_time {Time.at(rand * Time.now.to_f)}
      #reference "Some Reference"
      #is_submitted {rand(2) == 1}
      #submitted_on {Date.today+(366*rand()).to_f}
      #hod_approved {rand(2) == 1}
      #hod_approved_on {Date.today+(366*rand()).to_f}
      #hod_rejected {rand(2) == 1}
      #hod_rejected_on {Date.today+(366*rand()).to_f}
      #data_file_name "Some Name"
      #data_content_type { |n| "Some Content Type #{n}"}
      #data_content_type "text/plain"
      #data_file_size {rand(5242880)}
      #data_updated_ot {Date.today+(366*rand()).to_f}
      #prerequisites "Some prerequisite"
      #year {rand(1..3)}
      #reason "Some Reason"
      #association :endorser, factory: :staff
      #condition_isgood {rand(2) == 1}
      #condition_isnotgood {rand(2) == 1}
      #condition_desc "Some conditon description"
      #training_aids "Some Training Aids"
      #summary "Some Summary"
      #sequence(:total_absent) {|n| "#{n}"}
      #report_submit {rand(2) == 1}
      #report_submit_on {Date.today+(366*rand()).to_f}
      #report_endorsed {rand(2) == 1}
      #report_endorsed_on {Date.today+(366*rand()).to_f}
      #report_summary "Some Summary"
      #association :schedule, factory: :weeklytimetable_detail
      schedule 1
    end

end
