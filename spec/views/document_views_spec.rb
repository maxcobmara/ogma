require 'spec_helper'

describe "document pages" do
 
  subject { page }
   
  before {@college=FactoryGirl.create(:college)}
  before {@page=FactoryGirl.create(:page)}
  before {@admin_user=FactoryGirl.create(:admin_user)}
  before {@document = FactoryGirl.create(:document)}
  before (:each) do 
    sign_in(@admin_user)
  end
  
  describe "Document Index page" do
    before { visit documents_path }
    
    it { should have_selector('h1', text: 'Document List') }
    it { should have_link("New",    href: new_document_path + "?locale=en")}
    it { should have_selector(:link_or_button, "Search")}    
    it { should have_selector(:link_or_button, "Print")}
    it { should have_selector('th', text: I18n.t('document.serial_no')) }
    it { should have_selector('th', text: 'Ref No') }
    it { should have_selector('th', text: 'Category')}
    it { should have_selector('th', text: 'Title')}
    it { should have_selector('th', text: I18n.t('document.letter_date'))}
    it { should have_selector('th', text: I18n.t('document.received_date'))}
    it { should have_selector('th', text: 'From')}
    it { should have_selector('th', text: "Status / "+(I18n.t 'document.circulation_date') )}
    it { should have_selector('th', text: 'Actions/Notifications')}
    it { should have_selector('th', text: I18n.t('document.file_closed'))}
    it { should have_link(@document.refno), href: document_path(@document) + "?locale=en" }
  end
  
  describe "Document Show Page" do
    before { visit document_path(@document)}   
    it {should have_selector('h1', text: "#{@document.refno} : #{@document.title.capitalize}")}   
    #amsas
    it { should have_selector(:link_or_button, I18n.t('document.staff_action'))} 
    #kskbjb
    #it { should have_selector(:link_or_button, "Action Details")}
    it { should have_selector(:link_or_button, "Document Details")}
    
    it { should have_selector(:link_or_button, "Back")}    
    it { should have_selector(:link_or_button, "Edit")}    
    it { should have_selector(:link_or_button, "Destroy")}    
  end
  
  describe "Document Edit Page" do
    before { visit edit_document_path(@document)}   
    it {should have_selector('h1', text: "Edit #{@document.refno} : #{@document.title.capitalize}")}
    
    it { should have_selector(:link_or_button, "Back")}    
    it { should have_selector(:link_or_button, "Update")}    
  end
  
end

									