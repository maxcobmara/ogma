require 'spec_helper'

describe "Address Book views" do
  
  subject { page }
  

  describe "Address Book Index page" do
    before  { @contact = FactoryGirl.create(:address_book) }
    before { visit campus_address_books_path }
    
    it { should have_selector('h1', text: 'Event List') }
    it { should have_selector('th', text: 'Start Date') }
    it { should have_selector('th', text: 'End Date') }
    it { should have_selector('th', text: 'Event Name') }
    it { should have_selector('th', text: 'Location') }
    it { should have_selector('th', text: 'Officiated By') }
    it { should have_selector('th', text: 'Created By')}
    it { should have_link(@contact.name), href: campus_address_book_path(@contact) + "?locale=en" }
  end
end