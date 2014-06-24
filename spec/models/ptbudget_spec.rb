require 'spec_helper'

describe Ptbudget do

  before  { @budget = FactoryGirl.create(:ptbudget) }

  subject { @budget }

  it { should respond_to(:budget) }
  it { should respond_to(:fiscalstart) }
  
  it { should be_valid }
  
  describe "when budget is not present" do
    before { @budget.budget = nil }
    it { should_not be_valid }
  end
  
  describe "when icno is not present" do
    before { @budget.fiscalstart = nil }
    it { should_not be_valid }
  end
end

# == Schema Information
#
# Table name: ptbudgets
#
#  budget      :decimal(, )
#  created_at  :datetime
#  fiscalstart :date
#  id          :integer          not null, primary key
#  updated_at  :datetime
#