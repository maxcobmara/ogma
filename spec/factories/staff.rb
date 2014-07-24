FactoryGirl.define do

  sequence(:icno) do |n|
    @ic_nos ||= rand(10 ** 12).to_s
    #@ic_nos[n]
  end
  
  # Staffs
  factory :staff do
    sequence(:coemail) { |n| "slatest#{n}@example.com" }
    sequence(:name) { |n| "Bob#{n} Uncle" }
    icno {(0...12).map {rand(10).to_s}.join }
    code {(0...8).map { (65 + rand(26)).chr }.join}
    appointdt {Time.at(rand * Time.now.to_f)}
    cobirthdt {Time.at(rand * Time.now.to_f)}
    addr "Some Address"
    poskod_id {rand(10 ** 5).to_s}
    staffgrade_id 1 #make factory
    statecd 1
    country_id 1
    country_cd 1
    fileno {(0...8).map { (65 + rand(26)).chr }.join}
    #association :users, factory: :user not ready
    #association :timetables, factory: :timetable
  end
  
  factory :position do
    sequence(:name) { |n| "Position#{n} Orgchart" }
    sequence(:code) { |n| "Code#{n}" }
  end
  
  factory :staff_attendance do
    #sequence(:thumb_id) { |n| }
    association :attended, factory: :staff
    logged_at {Time.at(rand * Time.now.to_f)}
    log_type "Some Type"
    reason "Some Reason"
    trigger {rand(2) == 1}
    association :approver, factory: :staff
    is_approved {rand(2) == 1}
    approved_on {Date.today+(366*rand()).to_f}
    status 1
    review "Some Review"
  end
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