FactoryGirl.define do
  # exams
  factory :exam do
    sequence(:name) { |n| "Some Name_#{n}" }
    description "Some Description"
    association :creator, factory: :basic_staff
    programme_id 5#1
    association :subject, factory: :programme  #- not ready
    #subject_id 100 #if 1 is use - will failed - refer exams_controller.rb, line 92 (@programme_id = @exam.subject.root.id)
    exam_on {Date.today+(183*rand()).to_f}
    #full_marks rand(1..100) #{rand(1..100).to_f} - refer full_marks method in model/exam.rb
    starttime {Time.at(rand * Time.now.to_f)}
    endtime {Time.at(rand * Time.now.to_f)}   
    sequ "1,2,3,4,5,6,7,8,9,10" 
  end
  
  factory :examquestion do
    #association :subject, factory: :programme
    subject_id 1
    questiontype "Some Question Type"
    question "Some Question"
    answer "Some Answer"
    marks {rand(1.0..30.0).round(2)}
    category "Some Category"
    qkeyword "Some Keyword"
    qstatus "Some Status"
    association :creator, factory: :staff
    createdt {Date.today+(183*rand()).to_f}
    difficulty "Some Difficulty"
    statusremark "Some Status Remark"
    association :editor, factory: :staff
    editdt {Date.today+(183*rand()).to_f}
    association :approver, factory: :staff
    approvedt {Date.today+(183*rand()).to_f}
    bplreserve "True or False"
    bplsent "True or False"
    bplsentdt {Date.today+(183*rand()).to_f}
    diagram_file_name "Some Diagram Name"
    diagram_content_type "Some Content Type"
    diagram_file_size 1
    diagram_updated_at {Time.at(rand * Time.now.to_f)}
    association :topic, factory: :programme
    construct "Some Construct"
    conform_curriculum "True or False"
    conform_specification "True or False"
    conform_opportunity "True or False"
    accuracy_construct "True or False"
    accuracy_topic "True or False"
    accuracy_component "True or False"
    fit_difficulty "True or False"
    fit_important "True or False"
    fit_fairness "True or False"
    diagram_caption "Some diagram caption"
  end
end


#sequence(:coemail) { |n| "slatest#{n}@example.com" }
#sequence(:name) { |n| "Bob#{n} Uncle" }
#icno {(0...12).map {rand(10).to_s}.join }
#code {(0...8).map { (65 + rand(26)).chr }.join}
#appointdt {Time.at(rand * Time.now.to_f)}
#cobirthdt {Time.at(rand * Time.now.to_f)}
#addr "Some Address"
#poskod_id {rand(10 ** 5).to_s}
#staffgrade_id 1 #make factory
#statecd 1
#country_id 1
#country_cd 1
#fileno {(0...8).map { (65 + rand(26)).chr }.join}


# == Schema Information
#
# Table name: examquestions
#
#  accuracy_component    :boolean
#  accuracy_construct    :boolean
#  accuracy_topic        :boolean
#  answer                :text
#  approvedt             :date
#  approver_id           :integer
#  bplreserve            :boolean
#  bplsent               :boolean
#  bplsentdt             :date
#  category              :string(255)
#  conform_curriculum    :boolean
#  conform_opportunity   :boolean
#  conform_specification :boolean
#  construct             :string(255)
#  created_at            :datetime
#  createdt              :date
#  creator_id            :integer
#  diagram_caption       :string(255)
#  diagram_content_type  :string(255)
#  diagram_file_name     :string(255)
#  diagram_file_size     :integer
#  diagram_updated_at    :datetime
#  difficulty            :string(255)
#  editdt                :date
#  editor_id             :integer
#  fit_difficulty        :boolean
#  fit_fairness          :boolean
#  fit_important         :boolean
#  id                    :integer          not null, primary key
#  marks                 :decimal(, )
#  programme_id          :integer
#  qkeyword              :string(255)
#  qstatus               :string(255)
#  question              :text
#  questiontype          :string(255)
#  statusremark          :text
#  subject_id            :integer
#  topic_id              :integer
#  updated_at            :datetime
#

#== Schema Information
#
# Table name: exams
#
#  course_id   :integer
#  created_at  :datetime
#  created_by  :integer
#  description :text
#  duration    :integer
#  endtime     :time
#  exam_on     :date
#  full_marks  :integer
#  id          :integer          not null, primary key
#  klass_id    :integer
#  name        :string(255)
#  sequ        :string(255)
#  starttime   :time
#  subject_id  :integer
#  topic_id    :integer
#  updated_at  :datetime

