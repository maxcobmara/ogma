require 'spec_helper'

describe Asset do

  before  { @asset = FactoryGirl.create(:asset) }

  subject { @asset }

  it { should respond_to(:assetcode) }
  it { should be_valid }
  
end