require 'spec_helper'

describe "staff views" do
  
  subject { page }
  
  describe "staff Index page" do
    before  { @staffs = FactoryGirl.create(:staff) }
    before { visit staff_path }
    
    it { should have_selector('h1', text: 'List') }
    it { should have_selector('th', text: 'MyKad No') }
    it { should have_selector('th', text: 'Name') }
    it { should have_selector('th', text: 'Position') }
    it { should have_link(@staffs.icno), href: staff_path(@staffs) + "?locale=en" }
  end
end