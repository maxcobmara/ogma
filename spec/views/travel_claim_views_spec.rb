require 'spec_helper'

describe "Travel Claim pages" do
  
  before { @college = FactoryGirl.create(:college) }
  before { @travel_claim = FactoryGirl.create(:travel_claim) }
  
  subject { page }

  describe "Travel Claim Index page" do 
    before { visit staff_travel_claims_path }
      it { should have_selector('h1', text: I18n.t('staff.travel_claim.title')) }
      it { should have_link("New",    href: new_staff_travel_claim_path + "?locale=en")}
      it { should have_selector(:link_or_button, I18n.t('actions.search'))}    
      it { should have_selector(:link_or_button, I18n.t('actions.print'))}
      it { should have_selector('th', text: I18n.t('staff.travel_claim.month_year')) }
      it { should have_selector('th', text: I18n.t('staff.travel_claim.name')) }
      it { should have_selector('th', text: I18n.t('staff.travel_claim.total')) }
      it { should have_selector('th', text: "Status")}
      it { should have_link(@travel_claim.claim_month.try(:strftime,'%B %Y'), href: staff_travel_claim_path(@travel_claim) + "?locale=en") }
                                      
  end
  
  describe "Travel Claim Show Page" do
    before { visit staff_travel_claim_path(@travel_claim)}   
      it {should have_selector('h1', text: I18n.t('staff.travel_claim.title'))}
      it { should have_selector(:link_or_button, I18n.t('staff.travel_claim.request_travel_log'))}    
      it { should have_selector(:link_or_button, I18n.t('staff.travel_claim.claims_details'))}
      it { should have_selector(:link_or_button, I18n.t('staff.travel_claim.claims_approval'))}
      it { should have_selector(:link_or_button, I18n.t('helpers.links.back'))} 
      it { should have_selector(:link_or_button, I18n.t('helpers.links.edit'))}
      it { should have_selector(:link_or_button, I18n.t('helpers.links.finance_check'))}    
      it { should have_selector(:link_or_button, I18n.t('helpers.links.approve'))}
      it { should have_selector(:link_or_button, I18n.t('helpers.links.destroy'))}
  end
  
  describe "Travel Claim New page" do
    before { visit new_staff_travel_claim_path }
     it { should have_selector('h1', text: I18n.t('staff.travel_claim.new')) }
     it { should have_selector(:link_or_button, I18n.t('.back'))}    
     it { should have_selector(:link_or_button, I18n.t('create'))}    
  end
    
  describe "Travel Claim Edit page" do
    before { visit edit_staff_travel_claim_path(@travel_claim)}
     it { should have_selector('h1', text: I18n.t('staff.travel_claim.edit')) }
     it { should have_selector(:link_or_button, I18n.t('.back'))}  
     it { should have_selector(:link_or_button, I18n.t('update'))}
  end

end


