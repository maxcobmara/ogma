require 'spec_helper'

describe Stationery do

  before { @bulletin = FactoryGirl.create(:bulletin)}

  subject { @bulletin }
  
  it { should respond_to(:headline) }
  it { should respond_to(:content) }
  it { should respond_to(:postedby_id) }
  it { should respond_to(:publishdt) }
  it { should be_valid }
  
  
  describe "when headline is not present" do
    before { @bulletin.headline = nil }
    it { should_not be_valid }
  end

  describe "when contents is not present" do
    before { @bulletin.content = nil }
    it { should_not be_valid }
  end

  describe "when postedby_id is not present" do
    before { @bulletin.postedby_id = nil }
    it { should_not be_valid }
  end

  describe "when publishdt is not present" do
    before { @bulletin.publishdt = nil }
    it { should_not be_valid }
  end
  
end


# == Schema Information
#
# Table name: bulletins
#
#  content           :text
#  created_at        :datetime
#  data_content_type :string(255)
#  data_file_name    :string(255)
#  data_file_size    :integer
#  data_updated_at   :datetime
#  headline          :string(255)
#  id                :integer          not null, primary key
#  postedby_id       :integer
#  publishdt         :date
#  updated_at        :datetime
#
