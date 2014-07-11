require 'spec_helper'

describe AcademicSession do

  before  { @academic_session = FactoryGirl.create(:academic_session) }

  subject { @academic_session }

  it { should respond_to(:semester) }
  it { should respond_to(:total_week) }
  
  it { should be_valid }
  
end