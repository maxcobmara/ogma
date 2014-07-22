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
  #have to create additional 62 lines of timetable_period in order to match EACH created 'weeklytimetable' OR error in weeklytimetable_views_spec.rb #40-45 will arise
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 16) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 17) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 18) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 19) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 20) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 21) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 22) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 23) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 24) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 25) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 26) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 27) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 28) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 29) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 30) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 31) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 32) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 33) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 34) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 35) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 36) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 37) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 38) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 39) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 40) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 41) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 42) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 43) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 44) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 45) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 46) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 47) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 48) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 49) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 50) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 51) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 52) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 53) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 54) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 55) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 56) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 57) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 58) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 59) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 60) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 61) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 62) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 63) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 64) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 65) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 66) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 67) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 68) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 69) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 70) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 71) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 72) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 73) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 74) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 75) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 76) }
  before { @timetable_period = FactoryGirl.create(:timetable_period, timetable_id: 77) }  
      
  subject { @timetable_period }
  
  it { should respond_to(:timetable_id) }
  it { should respond_to(:sequence) }
  it { should respond_to(:day_name) }
  it { should respond_to(:start_at) }
  it { should respond_to(:end_at) }
  it { should respond_to(:is_break) }
  
  it { should be_valid }
  
end