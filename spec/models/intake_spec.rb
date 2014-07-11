require 'spec_helper'

describe Intake do
  
  before { @intake = FactoryGirl.create(:intake) }
  subject { @intake }
  
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:register_on) }
  it { should respond_to(:programme_id) }
  it { should respond_to(:is_active) }
  it { should respond_to(:monthyear_intake) }
  
  it { should be_valid }    

end