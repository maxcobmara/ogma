require 'spec_helper'

describe "Address Book views" do
  
  subject { page }
  

  describe "Address Book Index page" do
    before  { @contact = FactoryGirl.create(:address_book) }
    before { visit campus_address_books_path }
    
    it { should have_selector('h1', text: I18n.t('campus.address.title')) }
    it { should have_selector('th', text: I18n.t('campus.address.shortname')) }
    it { should have_selector('th', text: I18n.t('campus.address.name')) }
    it { should have_selector('th', text: I18n.t('campus.address.internet')) }
    it { should have_link(@contact.name), href: campus_address_book_path(@contact) + "?locale=en" }
  end

  describe "Address Book Create/Edit Page" do
    #do stuff here
  end
end