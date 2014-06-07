require 'spec_helper'

describe "staff pages" do
  before  { @staff = FactoryGirl.create(:staff) }
  subject { page }
  

  describe "Staff Index page" do
    before { visit staff_infos_path }
    
    it { should have_selector('h1', text: 'List') }
    it { should have_selector('th', text: 'MyKad No') }
    it { should have_selector('th', text: 'Name') }
    it { should have_selector('th', text: 'Position')}
    it { should have_link(formatted_mykad(@staff.icno), href: staff_info_path(@staff) + "?locale=en" ) }
  end
end