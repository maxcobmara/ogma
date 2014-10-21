require 'spec_helper'

describe AssetDefect do

  before  { @asset_defect = FactoryGirl.create(:asset_defect) }

  subject { @asset_defect }

  it { should respond_to(:asset_id) }
  it { should respond_to(:reported_by)}
  
  it { should be_valid }
  
  describe "when asset is not present" do
    before { @asset_defect.asset_id = nil }
    it { should_not be_valid}
  end
  
  describe "when reporter is not present" do
    before { @asset_defect.reported_by = nil }
    it { should_not be_valid}
  end
  
  #validates :asset_id, :reported_by, :presence => true
  
end


# == Schema Information
#
# Table name: asset_defects
#
#  asset_id       :integer
#  created_at     :datetime
#  decision       :boolean
#  decision_by    :integer
#  decision_on    :date
#  description    :text
#  id             :integer          not null, primary key
#  is_processed   :boolean
#  notes          :text
#  process_type   :string(255)
#  processed_by   :integer
#  processed_on   :date
#  recommendation :text
#  reported_by    :integer
#  updated_at     :datetime