require 'spec_helper'

describe StaffAppraisal do

  before  { @staff_appraisal = FactoryGirl.create(:staff_appraisal) }

  subject { @staff_appraisal }
  
  it { should respond_to(:staff_id) }
  it { should respond_to(:eval1_by) }
  it { should respond_to(:eval2_by) }
  it { should respond_to(:evaluation_year) }
  it { should respond_to(:is_skt_submit) }
  it { should respond_to(:skt_submit_on) }
  it { should respond_to(:is_skt_endorsed) }
  it { should respond_to(:skt_endorsed_on) }
  it { should respond_to(:skt_pyd_report) }
  it { should respond_to(:is_skt_pyd_report_done) }
  it { should respond_to(:skt_pyd_report_on) }
  it { should respond_to(:skt_ppp_report) }
  it { should respond_to(:is_skt_ppp_report_done) }
  it { should respond_to(:skt_ppp_report_on) }
  it { should respond_to(:is_submit_for_evaluation) }
  it { should respond_to(:submit_for_evaluation_on) }
  it { should respond_to(:g1_questions) }
  it { should respond_to(:g2_questions) }
  it { should respond_to(:g3_questions) }
  it { should respond_to(:e1g1q1) }
  it { should respond_to(:e1g1q2) }
  it { should respond_to(:e1g1q3) }
  it { should respond_to(:e1g1q4) }
  it { should respond_to(:e1g1q5) }
  it { should respond_to(:e1g1_total) }
  it { should respond_to(:e1g1_percent) }
  it { should respond_to(:e1g2q1) }
  it { should respond_to(:e1g2q2 ) }
  it { should respond_to(:e1g2q3) }
  it { should respond_to(:e1g2q4) }
  it { should respond_to(:e1g2_total ) }
  it { should respond_to(:e1g2_percent) }
  it { should respond_to(:e1g3q1) }
  it { should respond_to(:e1g3q2) }
  it { should respond_to(:e1g3q3) }
  it { should respond_to(:e1g3q4) }
  it { should respond_to(:e1g3q5) }    
  it { should respond_to(:e1g3_total) }
  it { should respond_to(:e1g3_percent) }
  it { should respond_to(:e1g4) }
  it { should respond_to(:e1g4_percent) }  
  it { should respond_to(:e1_total) }
  it { should respond_to(:e1_years) }
  it { should respond_to(:e1_months) }
  it { should respond_to(:e1_performance) }
  it { should respond_to(:e1_progress) }
  it { should respond_to(:is_submit_e2) }  
  it { should respond_to(:submit_e2_on) }    
  it { should respond_to(:e2g1q1) }
  it { should respond_to(:e2g1q2) }
  it { should respond_to(:e2g1q3) }  
  it { should respond_to(:e2g1q4) }
  it { should respond_to(:e2g1q5) }
  it { should respond_to(:e2g1_total) }
  it { should respond_to(:e2g1_percent ) }
  it { should respond_to(:e2g2q1) }
  it { should respond_to(:e2g2q2) }
  it { should respond_to(:e2g2q3) }
  it { should respond_to(:e2g2q4) }  
  it { should respond_to(:e2g2_total ) }
  it { should respond_to(:e2g2_percent) }
  it { should respond_to(:e2g3q1) }
  it { should respond_to(:e2g3q2) }
  it { should respond_to(:e2g3q3) }
  it { should respond_to(:e2g3q4) }  
  it { should respond_to(:e2g3q5) }
  it { should respond_to(:e2g3_total) }
  it { should respond_to(:e2g3_percent) }
  it { should respond_to(:e2g4) }  
  it { should respond_to(:e2g4_percent) }
  it { should respond_to(:e2_total) }
  it { should respond_to(:e2_years) }
  it { should respond_to(:e2_months) }
  it { should respond_to(:e2_performance) }
  it { should respond_to(:evaluation_total) }
  it { should respond_to(:is_complete) }
  it { should respond_to(:is_completed_on) }  
  
  it { should be_valid }
  
  describe "evaluation year is not present" do
    before { @staff_appraisal.evaluation_year=nil}
    it {should_not be_valid}
  end
  
  describe "appraisal for this year already exist" do
    before do
      @staff_appraisal.evaluation_year='2010-01-01'
      @staff_appraisal.staff_id=1
      @staff_appraisal2.eavaluation_year='2010-01-01'
      @staff_appraisal2.staff_id=1
    end
  end
  
end
  