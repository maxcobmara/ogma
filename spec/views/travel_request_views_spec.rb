require 'spec_helper'

describe "Travel Request pages" do
  
  #before { @applicant = FactoryGirl.create(:staff) }
  #before { @travel_request = FactoryGirl.create(:travel_request, applicant: @applicant, is_submitted: true, hod_accept: true) }
  before { @travel_request = FactoryGirl.create(:travel_request, staff_id: 25, is_submitted: true, hod_accept: true) }
  
  subject { page }

  describe "Travel Request Index page" do 
    before { visit staff_travel_requests_path }
      it { should have_selector('h1', text: I18n.t('staff.travel_request.title')) }
      it { should have_link("New",    href: new_staff_travel_request_path + "?locale=en")}
      it { should have_selector(:link_or_button, I18n.t('actions.search'))}    
      it { should have_selector(:link_or_button, I18n.t('actions.print'))}
      it { should have_selector('th', text: I18n.t('staff.travel_request.document_id')) }
      it { should have_selector('th', text: I18n.t('staff.travel_request.staff_id')) }
      it { should have_selector('th', text: I18n.t('staff.travel_request.destination')) }
      it { should have_selector('th', text: I18n.t('staff.travel_request.depart_at')) }      
      it { should have_selector('th', text: I18n.t('staff.travel_request.return_at')) }
      it { should have_selector('th', text: I18n.t('staff.travel_request.purpose')) }
      it { should have_selector('th', text: I18n.t('staff.travel_request.is_submitted')) }
      it { should have_selector('th', text: I18n.t('staff.travel_request.hod_accept')) } 
      it { should have_link(@travel_request.applicant.try(:staff_name_with_position), href: staff_travel_request_path(@travel_request) + "?locale=en") }                                    
    end
   
    
  describe "Travel Request Show Page" do
    before { visit staff_travel_request_path(@travel_request)}   
      it {should have_selector('h1', text: I18n.t('staff.travel_request.title'))}
      it { should have_selector(:link_or_button, I18n.t( 'staff.travel_request.details'))}    
      it { should have_selector(:link_or_button, I18n.t('staff.travel_request.submission'))}
      it { should have_selector(:link_or_button, I18n.t('staff.travel_request.approval2'))}
      it { should have_selector(:link_or_button, I18n.t('staff.travel_request.log_details2'))}
      it { should have_selector(:link_or_button, I18n.t('helpers.links.back'))} 
      it { should have_selector(:link_or_button, I18n.t('actions.edit'))}    
      it { should have_selector(:link_or_button, I18n.t('helpers.links.destroy'))}
      it { should have_selector(:link_or_button, I18n.t('staff.travel_request.approval'))}
      it { should have_selector(:link_or_button, I18n.t('staff.travel_request.log_details'))}
  end
  
  describe "Travel Request New page" do
    before { visit new_staff_travel_request_path }
     it { should have_selector('h1', text: I18n.t('staff.travel_request.new')) }
     it { should have_selector(:link_or_button, I18n.t('.back'))}    
     it { should have_selector(:link_or_button, I18n.t('create'))}    
  end
    
  describe "Travel Request Edit page" do
    before { visit edit_staff_travel_request_path(@travel_request)}
     it { should have_selector('h1', text: I18n.t('staff.travel_request.edit')) }
     it { should have_selector(:link_or_button, I18n.t('.back'))}  
     it { should have_selector(:link_or_button, I18n.t('update'))}
  end
    
end 