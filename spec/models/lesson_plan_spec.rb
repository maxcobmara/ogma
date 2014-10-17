 require 'spec_helper'

describe LessonPlan do
  
  before { @lesson_plan = FactoryGirl.create(:lesson_plan) }
 
  subject { @lesson_plan }
  
  it { should respond_to(:prepared_by) }
  it { should respond_to(:intake_id) }
  it { should respond_to(:student_qty) }
  it { should respond_to(:semester) }
  it { should respond_to(:topic) }
  it { should respond_to(:lecture_title) }
  it { should respond_to(:lecture_date) }
  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }
  it { should respond_to(:reference) }
  it { should respond_to(:is_submitted) }
  it { should respond_to(:submitted_on) }
  it { should respond_to(:hod_approved) }
  it { should respond_to(:hod_approved_on) }
  it { should respond_to(:hod_rejected) }
  it { should respond_to(:hod_rejected_on) }
  it { should respond_to(:data_file_name) }
  it { should respond_to(:data_content_type) }
  it { should respond_to(:data_file_size) }  
  it { should respond_to(:data_updated_ot) }  
  it { should respond_to(:prerequisites) }
  it { should respond_to(:year) }
  it { should respond_to(:reason) }  
  it { should respond_to(:endorsed_by) }
  it { should respond_to(:condition_isgood) }
  it { should respond_to(:condition_isnotgood) }  
  it { should respond_to(:condition_desc) }
  it { should respond_to(:training_aids) }
  it { should respond_to(:summary) }  
  it { should respond_to(:total_absent) }
  it { should respond_to(:report_submit) }
  it { should respond_to(:report_submit_on) } 
  it { should respond_to(:report_endorsed) }
  it { should respond_to(:report_endorsed_on) }  
  it { should respond_to(:report_summary) }
  it { should respond_to(:schedule) }  
  
  it { should be_valid }    
  
   describe "when attachment format is not valid" do
    before { @lesson_plan.data_content_type = "Other type"}
    it { should_not be_valid }
  end

end