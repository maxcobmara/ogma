require 'spec_helper'

describe Stationery do

  before { @stationery = FactoryGirl.create(:stationery)}
    

  subject { @stationery }
  
  it { should respond_to(:category) }
  it { should respond_to(:code) }
  it { should respond_to(:maxquantity) }
  it { should respond_to(:minquantity) }
  it { should respond_to(:unittype) }
  it { should be_valid }
  
  
  describe "when category no is not present" do
    before { @stationery.category = nil }
    it { should_not be_valid }
  end
  
  describe "when category is already taken" do
    before do
      @stationery.category = "some_category"
      FactoryGirl.create(:stationery, category: "some_category")
    end
    it { should_not be_valid }
  end
  
  describe "when code is not unique" do
    before do
      @stationery.category = "some_code"
      @stationery2 = FactoryGirl.create(:stationery, category: "some_code")
    end
    it { should_not be_valid }
  end
  
  
  
  
end

# == Schema Information
#
# Table name: stationeries
#
#  category    :string(255)
#  code        :string(255)
#  created_at  :datetime
#  id          :integer          not null, primary key
#  maxquantity :decimal(, )
#  minquantity :decimal(, )
#  unittype    :string(255)
#  updated_at  :datetime
#
