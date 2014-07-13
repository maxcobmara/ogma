require 'spec_helper'

describe TimetablePeriod do

  #before { @timetable_period = FactoryGirl.create(:timetable_period) }
  #have to create 15 set of matching 'timetable_periods' records for EACH created 'timetable' OR error in timetable_views_spec.rb, #29-32 will arise
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 1) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 2) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 3) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 4) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 5) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 6) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 7) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 8) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 9) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 10) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 11) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 12) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 13) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 14) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 15) }
      
  subject { @timetable_period }
  
  it { should respond_to(:timetable_id) }
  it { should respond_to(:sequence) }
  it { should respond_to(:day_name) }
  it { should respond_to(:start_at) }
  it { should respond_to(:end_at) }
  it { should respond_to(:is_break) }
  
  it { should be_valid }
  
end