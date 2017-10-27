FactoryGirl.define do

  # Staffs
#   astaff=Staff.new(name: 'nama 1', coemail: 'latest@example.com', icno: '123456789012', code: "123456789012", appointdt: "2012-01-01", current_salary: 1100.00, country_cd: 1, staffgrade_id: 1)

  factory :basic_staff, :class => 'Staff' do
    sequence(:coemail) { |n| "slatest#{n}@example.com" }
    sequence(:name) { |n| "Bob#{n} Uncle" }
    icno {(0...12).map {rand(10).to_s}.join }
    code {(0...8).map { (65 + rand(26)).chr }.join}
    appointdt {Time.at(rand * Time.now.to_f)}
    cobirthdt {Time.at(rand * Time.now.to_f)}
    addr "Some Address"
    poskod_id {rand(10 ** 5).to_s}
    statecd 1
    country_id 1
    country_cd 1
    fileno {(0...8).map { (65 + rand(26)).chr }.join}
    current_salary {rand(300..15000)}
    association :staffgrade, factory: :employgrade
    association :college, factory: :college
    #association :timetables, factory: :timetable
#     factory :basic_staff_with_position do
      after(:create) {|basic_staff| create(:position, staff: basic_staff)}
#     end
  end

  factory :staff_with_login, :class => 'Staff' do
    sequence(:coemail) { |n| "slatest#{n}@example.com" }
    sequence(:name) { |n| "Bob#{n} Uncle" }
    icno {(0...12).map {rand(10).to_s}.join }
    code {(0...8).map { (65 + rand(26)).chr }.join}
    appointdt {Time.at(rand * Time.now.to_f)}
    cobirthdt {Time.at(rand * Time.now.to_f)}
    addr "Some Address"
    poskod_id {rand(10 ** 5).to_s}
    statecd 1
    country_id 1
    country_cd 1
    fileno {(0...8).map { (65 + rand(26)).chr }.join}
    current_salary {rand(300..15000)}
    association :staffgrade, factory: :employgrade
    after(:create) {|staff| staff.users = [create(:staff_user)]}
    after(:create) {|staff| staff.vehicles = [create(:vehicle)]}
    #association :timetables, factory: :timetable
  end

  factory :vehicle, :class => 'Vehicle' do
    sequence(:type_model)  { |n| "Reg No #{n}" }
    sequence(:reg_no) { |n| "Reg No #{n}" }
    cylinder_capacity {rand(60..3000)}
    #association :staffvehicle, factory: :basic_staff
    #staff_id 25
  end

#   agrade=Employgrade.new(name: 'grade 11', group_id: 1)
  factory :employgrade do
#     name {|n| "Grade Name #{[1,2].sample}#{n}"}
    name {|n| "Grade Name 4#{n}" }
    group_id {[1,2,4].sample}
  end

  factory :position do
    sequence(:name) { |n| "Position#{n} Orgchart" }
    sequence(:code) { |n| "Code#{n}" }
    sequence(:tasks_main) {|n| "Task #{n}"}
    sequence(:combo_code) {|n| "0-#{n}"}
    association :college, factory: :college
    association :staff, factory: :basic_staff
    association :staffgrade, factory: :employgrade #min grade
  end

  factory :staff_attendance do
    #sequence(:thumb_id) { |n| }
    association :attended, factory: :basic_staff
    logged_at {Time.at(rand * Time.now.to_f)}
    log_type "Some Type"
    reason "Some Reason"
    trigger {rand(2) == 1}
    association :approver, factory: :basic_staff
    is_approved {rand(2) == 1}
    approved_on {Date.today+(366*rand()).to_f}
    status 1
    review "Some Review"
  end

#   app=StaffAppraisal.new(staff_id: 1, evaluation_year: "2011-01-01")
  factory :staff_appraisal do
    association :appraised, factory: :basic_staff
    association :eval1_officer, factory: :basic_staff
    association :eval2_officer, factory: :basic_staff
    evaluation_year {(Date.today+(366*rand()).to_f).at_beginning_of_month}
    is_skt_submit true #{rand(2) == 1}
    skt_submit_on {Date.today+(366*rand()).to_f}
    is_skt_endorsed true #{rand(2) == 1}
    skt_endorsed_on {Date.today+(366*rand()).to_f}
    skt_pyd_report "Some PYD Report"
    is_skt_pyd_report_done true #{rand(2) == 1}
    skt_pyd_report_on {Date.today+(366*rand()).to_f}
    skt_ppp_report "Some PPP Report"
    is_skt_ppp_report_done true #{rand(2) == 1}
    skt_ppp_report_on {Date.today+(366*rand()).to_f}
    is_submit_for_evaluation true #{rand(2) ==1}
    submit_for_evaluation_on {Date.today+(366*rand()).to_f}
    g1_questions 5
    g2_questions {rand(3..4)}
    g3_questions {rand(3..5)}
    e1g1q1 {rand(0..10).to_f}
    e1g1q2 {rand(0..10).to_f}
    e1g1q3 {rand(0..10).to_f}
    e1g1q4 {rand(0..10).to_f}
    e1g1q5 {rand(0..10).to_f}
    e1g1_total {rand(0..50).to_f}
    e1g1_percent {rand(0..50).to_f}
    e1g2q1 {rand(0..10).to_f}
    e1g2q2 {rand(0..10).to_f}
    e1g2q3 {rand(0..10).to_f}
    e1g2q4 {rand(0..10).to_f}
    e1g2_total {rand(0..40).to_f}
    e1g2_percent {rand(0..25).to_f}
    e1g3q1 {rand(0..10).to_f}
    e1g3q2 {rand(0..10).to_f}
    e1g3q3 {rand(0..10).to_f}
    e1g3q4 {rand(0..10).to_f}
    e1g3q5 {rand(0..10).to_f}
    e1g3_total {rand(0..50).to_f}
    e1g3_percent {rand(0..20).to_f}
    e1g4 {rand(0..10).to_f}
    e1g4_percent {rand(0..5).to_f}
    e1_total {rand(0..100).to_f}
    e1_years{rand(0..45)}
    e1_months {rand(0..12)}
    e1_performance "Some Performance"
    e1_progress "Some Progress"
    is_submit_e2 true # {rand(2)==1}
    submit_e2_on {Date.today+(366*rand()).to_f}

    e2g1q1 {rand(0..10).to_f}
    e2g1q2 {rand(0..10).to_f}
    e2g1q3 {rand(0..10).to_f}
    e2g1q4 {rand(0..10).to_f}
    e2g1q5 {rand(0..10).to_f}
    e2g1_total {rand(0..50).to_f}
    e2g1_percent {rand(0..50).to_f}
    e2g2q1 {rand(0..10).to_f}
    e2g2q2 {rand(0..10).to_f}
    e2g2q3 {rand(0..10).to_f}
    e2g2q4 {rand(0..10).to_f}
    e2g2_total {rand(0..40).to_f}
    e2g2_percent {rand(0..25).to_f}
    e2g3q1 {rand(0..10).to_f}
    e2g3q2 {rand(0..10).to_f}
    e2g3q3 {rand(0..10).to_f}
    e2g3q4 {rand(0..10).to_f}
    e2g3q5 {rand(0..10).to_f}
    e2g3_total {rand(0..50).to_f}
    e2g3_percent {rand(0..20).to_f}
    e2g4 {rand(0..10).to_f}
    e2g4_percent {rand(0..5).to_f}
    e2_total {rand(0..100).to_f}
    e2_years{rand(0..45)}
    e2_months {rand(0..12)}
    e2_performance "Some Performance 2"
    evaluation_total 1.0
    is_complete true #{rand(2)==1}
    is_completed_on {Date.today+(366*rand()).to_f}
  end

  factory :travel_request, :class => 'TravelRequest' do
    association :applicant, factory: :staff_with_login
    association :replacement, factory: :basic_staff
    association :headofdept, factory: :basic_staff
    #association :travel_claim, factory: :travel_claim
    #association :document, factory: :document
    destination "Some destination"
    depart_at {DateTime.now-2.days}
    return_at {DateTime.now-1.days}
    #depart_at {DateTime.now-(366*rand()).to_f}
    #return_at {DateTime.now-(366*rand()).to_f}
    #own_car {rand(2)==1}
    #own_car_notes "Some notes"
    #dept_car {rand(2)==1}
    #others_car {rand(2)==1}
    #taxi {rand(2)==1}
    #bus {rand(2)==1}
    #train {rand(2)==1}
    #plane {rand(2)==1}
    #other {rand(2)==1}
    #other_desc "Some description"
    #is_submitted {rand(2)==1}
    #submitted_on {Date.today+(366*rand()).to_f}
    #mileage {rand(2)==1}
    #mileage_replace {rand(2)==1}
    #hod_accept {rand(2)==1}
    #hod_accept_on {Date.today+(366*rand()).to_f}
    #is_travel_log_complete {rand(2)==1}
    #log_mileage {rand(0..2500).to_f}
    #log_fare {rand(0..5000).to_f}
    #code "Some code"
  end

  factory :travel_claim do
    association :staff, factory: :basic_staff
    association :approver, factory: :basic_staff
    claim_month {Date.today-(366*rand()).to_f}
    advance {rand(0..1000).to_f}
    total {rand(0..5000).to_f}
    is_submitted {rand(2)==1}
    submitted_on {Date.today+(366*rand()).to_f}
    is_checked {rand(2)==1}
    is_returned {rand(2)==1}
    checked_on {Date.today+(366*rand()).to_f}
    notes "Some notes"
    is_approved {rand(2)==1}
    approved_on {Date.today+(366*rand()).to_f}
  end
  
  factory :instructor_appraisal do
    association :checker, factory: :basic_staff
    association :instructor, factory: :basic_staff
    association :college, factory: :college
    appraisal_date {Date.today+(366*rand()).to_f}
  end
  
#   factory :leaveforstaff do
#     association :applicant, factory: :basic_staff
#     association :replacement, factory: :basic_staff
#     association :seconder, factory: :basic_staff
#     association :approver, factory: :basic_staff
#     association :college, factory: :college
#     leavetype 1
#     leavestartdate {Date.today.tomorrow+(366*rand()).to_f}
#     leaveenddate {Date.today+2.days+(366*rand()).to_f}
#     leavedays 1.0
#     reason "Some reason"
#     notes "Some notes"
#     submit {rand(2)==1}
#     approval1 {rand(2)==1}
#     approval1date {Date.today+(366*rand()).to_f}
#     approver2 {rand(2)==1}
#     approval2date {Date.today+(366*rand()).to_f}
#     data {{}}
#     address_on_leave "Some address"
#     phone_on_leave (0...12).map {rand(10).to_s}.join
#   end

end



#
#

    # == Schema Information
    #
    # Table name: staffs
    #
    #  addr                    :string(255)
    #  appointby               :string(255)
    #  appointdt               :date
    #  appointstatus           :string(255)
    #  att_colour              :integer
    #  bank                    :string(255)
    #  bankaccno               :string(255)
    #  bankacctype             :string(255)
    #  birthcertno             :string(255)
    #  bloodtype               :string(255)
    #  cobirthdt               :date
    #  code                    :string(255)
    #  coemail                 :string(255)
    #  confirmdt               :date
    #  cooftelext              :string(255)
    #  cooftelno               :string(255)
    #  country_cd              :integer
    #  country_id              :integer
    #  created_at              :datetime
    #  employscheme            :string(255)
    #  employstatus            :integer
    #  fileno                  :string(255)
    #  gender                  :integer
    #  icno                    :string(255)
    #  id                      :integer          not null, primary key
    #  kwspcode                :string(255)
    #  mrtlstatuscd            :integer
    #  name                    :string(255)
    #  pension_confirm_date    :date
    #  pensiondt               :date
    #  pensionstat             :string(255)
    #  phonecell               :string(255)
    #  phonehome               :string(255)
    #  photo_content_type      :string(255)
    #  photo_file_name         :string(255)
    #  photo_file_size         :integer
    #  photo_updated_at        :datetime
    #  posconfirmdate          :date
    #  position_old            :integer
    #  poskod_id               :integer
    #  promotion_date          :date
    #  race                    :integer
    #  reconfirmation_date     :date
    #  religion                :integer
    #  schemedt                :date
    #  staff_shift_id          :integer
    #  staffgrade_id           :integer
    #  starting_salary         :decimal(, )
    #  statecd                 :integer
    #  svchead                 :string(255)
    #  svctype                 :string(255)
    #  taxcode                 :string(255)
    #  thumb_id                :integer
    #  time_group_id           :integer
    #  titlecd_id              :integer
    #  to_current_grade_date   :date
    #  transportclass_id       :string(255)
    #  uniformstat             :string(255)
    #  updated_at              :datetime
    #  wealth_decleration_date :date
