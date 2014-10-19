require 'spec_helper'

describe TimetablePeriod do

  before { @timetable_period = FactoryGirl.create(:timetable_period) }
      
  subject { @timetable_period }
  
  it { should respond_to(:timetable_id) }
  it { should respond_to(:sequence) }
  it { should respond_to(:day_name) }
  it { should respond_to(:start_at) }
  it { should respond_to(:end_at) }
  it { should respond_to(:is_break) }
  
  it { should be_valid }
  
  describe "when timetable is not present" do
    before { @timetable_period.timetable_id = nil }
    it { should_not be_valid }
  end
  
end