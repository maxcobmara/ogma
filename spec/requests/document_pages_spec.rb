require 'spec_helper'

describe "document pages" do
  
  subject { page }
  

  describe "Document Index page" do
    before  { @document = FactoryGirl.create(:document) }
    before { visit documents_path }
    
    it { should have_selector('h1', text: 'Document List') }
    it { should have_selector('th', text: 'Serial No') }
    it { should have_selector('th', text: 'Ref No') }
    it { should have_selector('th', text: 'Category')}
    it { should have_selector('th', text: 'Title')}
    it { should have_selector('th', text: 'Letter Date')}
    it { should have_selector('th', text: 'Received Date')}
    it { should have_selector('th', text: 'From')}
    it { should have_selector('th', text: 'Circulate To')}
    it { should have_selector('th', text: 'Actions/Notifications')}
    it { should have_selector('th', text: 'Closed')}
    it { should have_link(@document.serialno), href: document_path(@document) + "?locale=en" }
  end
end

									