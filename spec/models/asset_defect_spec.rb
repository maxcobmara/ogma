require 'spec_helper'

describe AssetDefect do

  before  { @asset_defect = FactoryGirl.create(:asset_defect) }

  subject { @asset_defect }

  it { should respond_to(:asset_id) }
  
  it { should be_valid }
  
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