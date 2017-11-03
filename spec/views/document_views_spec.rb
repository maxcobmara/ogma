require 'spec_helper'

describe "document pages" do
 
  subject { page.html }
  
  describe "Document Index page" do
    before(:each) do 
      @college=FactoryGirl.create(:college)
      @page=FactoryGirl.create(:page)
      @admin_user=FactoryGirl.create(:admin_user)
      sign_in(@admin_user)
      @document = FactoryGirl.create(:document, stafffiled_id: @admin_user)
      visit documents_path
    end
    
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
    before(:each) do 
      @college=FactoryGirl.create(:college)
      @page=FactoryGirl.create(:page)
      @admin_user2=FactoryGirl.create(:admin_user)
      @document = FactoryGirl.create(:document)
      sign_in(@admin_user2)
      visit document_path(@document)
    end
    
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
    before(:each) do 
      @college=FactoryGirl.create(:college)
      @page=FactoryGirl.create(:page)
      @document = FactoryGirl.create(:document)
      @admin_user3=FactoryGirl.create(:admin_user)
      sign_in(@admin_user3)
      visit edit_document_path(@document)
    end

    it {should have_selector('h1', text: "Edit #{@document.refno} : #{@document.title.capitalize}")}
    
    it { should have_selector(:link_or_button, "Back")}    
    it { should have_selector(:link_or_button, "Update")}    
  end
  
end

									