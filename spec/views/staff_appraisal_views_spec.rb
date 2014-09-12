require 'spec_helper'

describe "Staff Appraisal pages" do

  before { @staff_appraisal = FactoryGirl.create(:staff_appraisal) }
  subject { page }

  describe "Staff Appraisal Index page" do 
    before { visit staff_staff_appraisals_path }
    
     end
   end