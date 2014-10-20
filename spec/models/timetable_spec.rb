require 'spec_helper'

describe Timetable do

  before { @timetable = FactoryGirl.create(:timetable) }
  
  subject { @timetable }
  
  it { should respond_to(:code) }
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:created_by) }
  
  it { should be_valid }
  
end