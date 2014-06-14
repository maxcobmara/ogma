require 'spec_helper'

describe Document do

  before  { @document = FactoryGirl.create(:document) }

  subject { @document }
  
  it { should respond_to(:serialno) }
  it { should respond_to(:refno) }
  it { should respond_to(:title) }
  it { should respond_to(:from) }
  it { should respond_to(:category) }
  it { should be_valid }
  
  
  describe "when serial no is not present" do
    before { @document.serialno = nil }
    it { should_not be_valid }
  end
  
  describe "when icno is not present" do
    before { @document.refno = nil }
    it { should_not be_valid }
  end
  
end
#Validation failed: Serialno cant't be blank, Refno cant't be blank, Category cant't be blank, Title cant't be blank, From cant't be blank, Stafffiled cant't be blank

# == Schema Information
#
# Table name: documents
#
#  category                :integer
#  cc1action               :string(255)
#  cc1actiondate           :date
#  cc1closed               :boolean
#  cc1date                 :date
#  cc1remarks              :text
#  cc1staff_id             :integer
#  cc2action               :string(255)
#  cc2closed               :boolean
#  cc2date                 :date
#  cc2remarks              :text
#  cc2staff_id             :integer
#  cctype_id               :integer
#  closed                  :boolean
#  created_at              :datetime
#  data_content_type       :string(255)
#  data_file_name          :string(255)
#  data_file_size          :integer
#  data_updated_at         :datetime
#  dataaction_content_type :string(255)
#  dataaction_file_name    :string(255)
#  dataaction_file_size    :integer
#  dataaction_updated_at   :datetime
#  file_id                 :integer
#  from                    :string(255)
#  id                      :integer          not null, primary key
#  letterdt                :date
#  letterxdt               :date
#  otherinfo               :text
#  prepared_by             :integer
#  refno                   :string(255)
#  sender                  :string(255)
#  serialno                :string(255)
#  stafffiled_id           :integer
#  title                   :string(255)
#  updated_at              :datetime
#
