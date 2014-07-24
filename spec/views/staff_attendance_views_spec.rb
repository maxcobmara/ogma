require 'spec_helper'

describe "Staff Attendance pages" do

  before { @staff_attendance = FactoryGirl.create(:staff_attendance) }
  subject { page }

  describe "Staff Attendance Index page" do 
    before { visit staff_staff_attendances_path }
  
    #it {should have_selector('h1', text: I18n.t('staff.staff_attendance.title')) }
    #it {should have_selector('th', text: I18n.t('staff.staff_attendance.flag')) }
    #it {should have_selector('th', text: I18n.t('staff.staff_attendance.thumb_id')) }
    #it {should have_selector('th', text: I18n.t('staff.staff_attendance.logged_in')) }
    #it {should have_selector('th', text: I18n.t('staff.staff_attendance.logged_out')) }
    #it {should have_selector('th', text: I18n.t('staff.staff_attendance.shift')) }
    #it {should have_selector('th', text: I18n.t('staff.staff_attendance.late')) }
    #it {should have_selector('th', text: I18n.t('staff.staff_attendance.early')) }
    #it {should have_selector('th', text: I18n.t('staff.staff_attendance.action')) }
    #it {should have_selector('th', text: I18n.t('staff.staff_attendance.ignore')) }
    #it { should have_link(@staff_attendance.attended.name), href: staff_staff_attendance_path(@staff_attendance) + "?locale=en" }
      
  end
  
  #describe "Staff Attendance New page" do
    #before { visit new_staff_staff_attendance_path }
    
    #it { should have_selector('h1', text: I18n.t('staff.staff_attendance.title')) }
    #end
  
  #describe "Staff Attendance Show page" do
    #before { visit staff_staff_attendance_path(@staff_attendance) }
    
    #it { should have_selector('h1', text: I18n.t('staff.staff_attendance.title')) }
    #it { should have_selector(:link_or_button, I18n.t("helpers.links.back"))}    
    #it { should have_selector(:link_or_button, I18n.t("helpers.links.edit"))}    
    #it { should have_selector(:link_or_button, I18n.t("helpers.links.destroy"))}  
    
    #end
  
end
  