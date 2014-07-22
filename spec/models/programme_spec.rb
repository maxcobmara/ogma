require 'spec_helper'

describe Programme do
  
  before { @programme = FactoryGirl.create(:programme) }
  subject { @programme }
  
  it { should respond_to(:code) }
  it { should respond_to(:ancestry_depth) }
  it { should respond_to(:name) }
  it { should respond_to(:course_type) }

  it { should be_valid }    

end