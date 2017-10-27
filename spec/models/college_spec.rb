require 'spec_helper'

describe College do

  before  { @college = FactoryGirl.create(:college) }

  subject { @college }

  it { should respond_to(:code) }
  it { should respond_to(:name) }
#   it { should respond_to(:) }
#   it { should respond_to(:) }
#   it { should respond_to(:) }
  
  it { should be_valid }
  
end

# rspec ./spec/models/college_spec.rb:10 # College 
# rspec ./spec/models/college_spec.rb:15 # College 
# rspec ./spec/models/college_spec.rb:9 # College

