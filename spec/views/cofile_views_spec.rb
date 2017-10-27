require 'spec_helper'

describe "cofile pages" do
  
  subject { page }
  
  describe "Cofile Index page" do
    before {@owner=FactoryGirl.create(:basic_staff)}
    before  { @cofiles = FactoryGirl.create(:cofile, :owner_id => @owner.id) }
    before { visit cofiles_path }
    
    it { should have_selector('h1', text: 'List') }
    it { should have_selector('th', text: 'Cofileno') }
    it { should have_selector('th', text: 'Name') }
    it { should have_selector('th', text: 'Location') }
    it { should have_selector('th', text: 'Owner') }
    it { should have_selector('th', text: 'Onloan To') }
    it { should have_selector('th', text: 'Onloandt') }
    it { should have_link(@cofiles.cofileno), href: cofiles_path(@cofiles) + "?locale=en" }
  end
end