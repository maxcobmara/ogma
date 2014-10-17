require 'spec_helper'

describe AssetDisposal do

  before  { @asset_disposal = FactoryGirl.create(:asset_disposal) }

  subject { @asset_disposal }

  it { should respond_to(:asset_id) }
  it { should respond_to(:current_value)}
  
  it { should be_valid }
  
  describe "when asset is not present" do
    before {@asset_disposal.asset_id= nil}
    it { should_not be_valid }
  end
  
   describe "when current value is not present" do
    before {@asset_disposal.current_value= nil}
    it { should_not be_valid }
  end
  
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