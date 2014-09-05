require 'spec_helper'

describe Timetable do

  before { @timetable = FactoryGirl.create(:timetable) }
  #before { @timetable2 = FactoryGirl.create(:timetable) }
  #create 2 timetable records in order to match with 1 weeklytimetable
  #before { @timetable = FactoryGirl.create(:timetable, id: 1) }
  #before { @timetable2 = FactoryGirl.create(:timetable, id: 2) }
  
  subject { @timetable }
  
  it { should respond_to(:code) }
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:created_by) }
  
  it { should be_valid }
  
end