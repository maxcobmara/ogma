require 'spec_helper'

describe "Staff Appraisal pages" do
  
  before { @employgrade = FactoryGirl.create(:employgrade)}
  before { @appraised = FactoryGirl.create(:staff, :staffgrade => @employgrade)}
  before { @staff_appraisal = FactoryGirl.create(:staff_appraisal, :appraised => @appraised) }
  
  subject { page }

  describe "Staff Appraisal Index page" do 
    before { visit staff_staff_appraisals_path }
      it { should have_selector('h1', text: I18n.t('staff.staff_appraisal.title')) }
      it { should have_link("New",    href: new_staff_staff_appraisal_path + "?locale=en")}
      it { should have_selector(:link_or_button, "Search")}    
      it { should have_selector(:link_or_button, "Print")}
      it { should have_selector('th', text: I18n.t('staff.icno')) }
      it { should have_selector('th', text: I18n.t('staff.name')) }
      it { should have_selector('th', text: I18n.t('staff.position'))}
      it { should have_selector('th', text: I18n.t('helpers.label.staff_appraisal.evaluation_year'))}
      it { should have_selector('th', text: "Status")}
      it { should have_link(formatted_mykad(@staff_appraisal.appraised.icno), staff_staff_appraisal_path(@staff_appraisal.appraised) + "?locale=en") }
    end
end