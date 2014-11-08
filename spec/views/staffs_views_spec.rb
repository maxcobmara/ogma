require 'spec_helper'

describe "staff views" do

  subject { page }

  describe "staff Index page" do
    before  { @staffs = FactoryGirl.create(:staff) }
    before { visit staff_infos_path }

    it { should have_selector('h1', text: 'List') }
    it { should have_selector('th', text: 'MyKad No') }
    it { should have_selector('th', text: 'Name') }
    it { should have_selector('th', text: 'Position') }
    it { should have_link(formatted_mykad(@staffs.icno)), href: staff_info_path(@staffs) + "?locale=en" }
  end

  describe "staff new page" do
    before { visit new_staff_info_path }

    it { should have_selector('h1', text: I18n.t('staff.new')) }
    it { should have_selector(:link_or_button, I18n.t('staff.personal_details'))}
  end

  describe "staff edit page" do
    before  { @staff = FactoryGirl.create(:staff) }
    before { visit edit_staff_info_path(@staff) }

    it { should have_selector('h1', text: ("Edit " + @staff.name)) }
    it { should have_selector(:link_or_button, I18n.t('staff.personal_details'))}
  end
end
