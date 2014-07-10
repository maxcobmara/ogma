require 'spec_helper'

describe "academic sessions pages" do
  before  { @academic_session = FactoryGirl.create(:academic_session) }
  subject { page }
  
  describe "Academic Session Index page" do
    
    before { visit training_academic_sessions_path }
    
    it { should have_selector('h1', text: I18n.t('training.academic_session.title')) }
    it { should have_selector('th', text: I18n.t('training.academic_session.semester')) }
    it { should have_selector('th', text: I18n.t('training.academic_session.total_week')) }
    it { should have_link(@academic_session.semester), href: training_academic_session_path(@academic_session) + "?locale=en" }
  end
  
  describe "Academic Session New page" do
    before { visit new_training_academic_session_path }   
    it { should have_selector('h1', text: I18n.t('training.academic_session.new')) }
  end
  
  describe "Academic Session Show page" do
    before { visit training_academic_session_path(@academic_session) }
    
    it { should have_selector('h1', text: I18n.t('training.academic_session.title')) }
    it { should have_selector(:link_or_button, I18n.t("helpers.links.back"))}    
    it { should have_selector(:link_or_button, I18n.t("helpers.links.edit"))}    
    it { should have_selector(:link_or_button, I18n.t("helpers.links.destroy"))}    
  end
end