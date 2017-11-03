require 'spec_helper'

describe "Address Book views" do
  
  subject { page }
  
  describe "Address Book Index page" do
    before(:each) do
      @college = FactoryGirl.create(:college)
      @contact = FactoryGirl.create(:address_book)
      @admin_user = FactoryGirl.create(:admin_user) 
      sign_in(@admin_user)
      #https://stackoverflow.com/questions/12605692/how-do-i-re-use-capybara-sessions-between-tests
      page.instance_variable_set(:@touched, false)
      visit campus_address_books_path
    end
    
    #https://stackoverflow.com/questions/15118245/ruby-on-rails-3-rspec-fail-although-it-suppose-to-succeed
    
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