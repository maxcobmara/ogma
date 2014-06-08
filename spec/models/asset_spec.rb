require 'spec_helper'

describe Asset do

  before  { @asset = FactoryGirl.create(:asset) }

  subject { @asset }

  it { should respond_to(:assetcode) }
  it { should respond_to(:assettype) }
  it { should respond_to(:assignedto_id) }
  it { should respond_to(:bookable) }
  it { should respond_to(:cardno) }
  it { should respond_to(:category_id) }
  it { should respond_to(:country_id) }
  it { should respond_to(:engine_no) }
  it { should respond_to(:engine_type_id) }
  it { should respond_to(:is_disposed) }
  
  it { should be_valid }
  
end

# == Schema Information
#
# Table name: assets
#
#  assetcode            :string(255)
#  assettype            :integer
#  assignedto_id        :integer
#  bookable             :boolean
#  cardno               :string(255)
#  category_id          :integer
#  country_id           :integer
#  created_at           :datetime
#  engine_no            :string(255)
#  engine_type_id       :integer
#  id                   :integer          not null, primary key
#  is_disposed          :boolean
#  is_maintainable      :boolean
#  locassigned          :boolean
#  location_id          :integer
#  manufacturer_id      :integer
#  mark_as_lost         :boolean
#  mark_disposal        :boolean
#  modelname            :string(255)
#  name                 :string(255)
#  nationcode           :string(255)
#  orderno              :string(255)
#  otherinfo            :text
#  purchasedate         :date
#  purchaseprice        :decimal(, )
#  quantity             :integer
#  quantity_type        :string(255)
#  receiveddate         :date
#  receiver_id          :integer
#  registration         :string(255)
#  serialno             :string(255)
#  status               :integer
#  subcategory          :string(255)
#  supplier_id          :integer
#  typename             :string(255)
#  updated_at           :datetime
#  warranty_length      :integer
#  warranty_length_type :integer
#
