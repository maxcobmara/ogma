require 'spec_helper'

describe Ptschedule do

  before  { @ptschedule = FactoryGirl.create(:ptschedule) }

  subject { @ptschedule }

  it { should respond_to(:ptcourse_id) }
  it { should respond_to(:start) }
  it { should respond_to(:location) }
  it { should respond_to(:final_price) }
  it { should respond_to(:min_participants) }
  it { should respond_to(:max_participants) }
  it { should respond_to(:budget_ok) }

  it { should be_valid }
  
  describe "when course is not present" do
    before { @ptschedule.ptcourse_id = nil }
    it { should_not be_valid }
  end
  
  describe "when start is not present" do
    before { @ptschedule.start = nil }
    it { should_not be_valid }
  end
  describe "when location is not present" do
    before { @ptschedule.location = nil }
    it { should_not be_valid }
  end
  describe "when min is not present" do
    before { @ptschedule.min_participants = nil }
    it { should_not be_valid }
  end
  describe "when max is not present" do
    before { @ptschedule.max_participants = nil }
    it { should_not be_valid }
  end
  
  describe "min should be less than max" do
    before { @ptschedule.max_participants = 10}
    before { @ptschedule.min_participants = 20}

    it { should_not be_valid }
    #@ptschedule.errors[:min_participants].should include("must be less than or equal to #{@ptschedule.max_participants}")
  end
  
end

# == Schema Information
#
# Table name: ptschedules
#
#  budget_ok        :boolean
#  created_at       :datetime
#  final_price      :decimal(, )
#  id               :integer          not null, primary key
#  location         :string(255)
#  max_participants :integer
#  min_participants :integer
#  ptcourse_id      :integer
#  start            :date
#  updated_at       :datetime

#Start can't be blank, Location can't be blank, Min participants can't be blank, Max participants can't be blank