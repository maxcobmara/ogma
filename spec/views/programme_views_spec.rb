require 'spec_helper'

describe "Programmes pages" do

  before { @programme = FactoryGirl.create(:programme) }
  subject { page }

  describe "Programme Index page" do 
    before { visit training_programmes_path }
  
    it {should have_selector('h1', text: I18n.t('training.programme.title')) }
    it {should have_selector('span.combo_code', text: I18n.t('training.programme.combo_code')) }
    it {should have_selector('span.credits', text: I18n.t('training.programme.credits')) }
    it {should have_selector('span.status', text: I18n.t('training.programme.status')) }
    it {should have_selector('span.duration', text: I18n.t('training.programme.duration')) }
    #it { should have_link(@programme.description), href: training_programme_path(@programme) + "?locale=en" }
    #link_to course_rec.code+" ", training_programme_path(course_rec) 
  end
  
  describe "Programme New page" do
    before { visit new_training_programme_path }
    
    it { should have_selector('h1', text: I18n.t('training.programme.new')) }
  end
  
  describe "Programme Show page" do
    before { visit training_programme_path(@programme) }
    
    it { should have_selector('h1', text: I18n.t('training.programme.title')) }
    it { should have_selector(:link_or_button, I18n.t("helpers.links.back"))}    
    it { should have_selector(:link_or_button, I18n.t("helpers.links.edit"))}    
    it { should have_selector(:link_or_button, I18n.t("helpers.links.destroy"))}  
  end
  
end
  