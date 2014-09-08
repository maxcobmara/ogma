require 'spec_helper'

describe StaffAppraisal do

  before  { @staff_appraisal = FactoryGirl.create(:staff_appraisal) }

  subject { @staff_appraisal }
  
  #it { should respond_to(:) }