require 'spec_helper'

describe "Travel Request pages" do

  before { @staff = FactoryGirl.create(:basic_staff) }
  before { @replacement = FactoryGirl.create(:basic_staff) }
  before { @hod = FactoryGirl.create(:basic_staff) }

  before { @vehicle = FactoryGirl.create(:vehicle, reg_no: "JJJ1234", staff_id: @staff.id) }
  before { @vehicle2 = FactoryGirl.create(:vehicle, reg_no: "JKK 4545", staff_id: @staff.id)}

  before { @travel_request = FactoryGirl.create(:travel_request, is_submitted: true, destination: 'some destination', depart_at: DateTime.now-2.days, return_at: DateTime.now-1.days , hod_accept: true, staff_id: @staff, replaced_by: @replacement, headofdept: @hod) }

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
