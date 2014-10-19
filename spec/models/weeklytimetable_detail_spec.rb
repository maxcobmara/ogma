require 'spec_helper'

describe WeeklytimetableDetail do
  
  before { @weeklytimetable_detail = FactoryGirl.create(:weeklytimetable_detail) }
  
  subject { @weeklytimetable_detail }
  
  it { should respond_to(:subject) }
  it { should respond_to(:topic) } 
  it { should respond_to(:time_slot)}
  it { should respond_to(:lecturer_id)}
  it { should respond_to(:weeklytimetable_id)} 
  it { should respond_to(:day2)}
  it { should respond_to(:is_friday)}
  it { should respond_to(:time_slot2)}
  it { should respond_to(:location)}
  it { should respond_to(:lecture_method)}
 
  it { should be_valid }    
  
  describe "when weeklytimetable is not present" do
    before { @weeklytimetable_detail.weeklytimetable_id = nil }
    it { should_not be_valid}
  end

end