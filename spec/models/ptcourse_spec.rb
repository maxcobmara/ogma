require 'spec_helper'

describe Ptcourse do

  before  { @ptcourse = FactoryGirl.create(:ptcourse) }

  subject { @ptcourse }

  it { should respond_to(:name) }
  it { should respond_to(:course_type) }
  it { should respond_to(:duration) }
  it { should respond_to(:duration_type) }
  it { should respond_to(:cost) }
  it { should respond_to(:description) }
  it { should respond_to(:approved) }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { @ptcourse.name = nil }
    it { should_not be_valid }
  end
  
end