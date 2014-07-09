require 'spec_helper'

describe Exam do
  
  before { @exam = FactoryGirl.create(:exam) } 
  
  subject { @exam }
  
  it { should respond_to(:programme_id)}
  it { should respond_to(:name) } 
  it { should respond_to(:description) } 
  it { should respond_to(:created_by) } 
  it { should respond_to(:subject_id) } 
  it { should respond_to(:exam_on) } 
  it { should respond_to(:full_marks) } 
  it { should respond_to(:starttime) } 
  it { should respond_to(:endtime) } 
  it { should respond_to(:sequ) }
  it { should be_valid }

  describe "when programme id is not present" do
    before { @exam.programme_id = nil }
    it { should_not be_valid }
  end
  
  describe "when subject id is not present" do
    before { @exam.subject_id = nil }
    it { should_not be_valid }
  end
  
  describe "when name is not present" do
    before { @exam.name = nil }
    it { should_not be_valid }
  end
 
  describe "when name is not unique within the same subject" do
    before do 
      @exam.subject_id = 1
      @exam.name = "Some Name_test"
      @exam2 = FactoryGirl.create(:exam, name: "Some Name_test", subject_id: 1)
    end
    it { should_not be_valid}
  end
  
  #didn't work yet - note - att_accessor : seq, table field : sequ
  #describe "when sequence is not present" do
    #before { @exam.sequ = "Select"} #before { @exam.seq == "Select"}
    #it { should_not be_valid} 
  #end
  
  #describe "when selected sequence is not unique" do
    ##before{ @exam.seq != "Select" && @exam.seq.uniq.length != @exam.seq.length}
    #before do
      #@exam.sequ = "1,2,3,4,5,6,7,8,9,9,9" 
      ##@exam.sequ.split(",").uniq.length < @exam.sequ.split(",").length 
      #a=@exam.sequ.split(",").length# = 10
      #b=@exam.sequ.split(",").uniq.length# = 9
      #a.should_not == b
      #end
    #it { should_not be_valid}
    #end  
  
end

#Validation failed: programme_id can't be blank, subject_id can't be blank, name can't be blank.
#Validation failed: name must be unique (within/for a) subject (subject_id).

#didn't work yet - note - att_accessor : seq, table field : sequ
#Validation failed: sequence can't be blank (must be selected) and sequence must be unique.


# == Schema Information
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
#
