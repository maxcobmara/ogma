require 'spec_helper'

describe Stationery do

  before { @address = FactoryGirl.create(:address_book)}

  subject { @address }
  
  it { should respond_to(:name) }
  it { should respond_to(:shortname) }
  it { should respond_to(:address) }
  it { should respond_to(:fax) }
  it { should respond_to(:mail) }
  it { should respond_to(:phone) }
  it { should respond_to(:web) }
  it { should be_valid }
  
  
  describe "when name is not present" do
    before { @address.name = nil }
    it { should_not be_valid }
  end
  
end


# == Schema Information
#
# Table name: address_books
#
#  address    :string(255)
#  created_at :datetime
#  fax        :string(255)
#  id         :integer          not null, primary key
#  mail       :string(255)
#  name       :string(255)
#  phone      :string(255)
#  shortname  :string(255)
#  updated_at :datetime
#  web        :string(255)
#