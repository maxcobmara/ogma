require 'spec_helper'

describe "Intake pages" do

  before { @intake = FactoryGirl.create(:intake) }
  subject { page }

  describe "Intake Index page" do 
    before { visit training_intakes_path }
  
    it {should have_selector('h1', text: I18n.t('training.intake.title')) }
    it {should have_selector('th', text: I18n.t('training.intake.description')) }
    it {should have_selector('th', text: I18n.t('training.intake.register_on')) }
    it {should have_selector('th', text: I18n.t('training.intake.programme_id')) }
    it {should have_selector('th', text: I18n.t('training.intake.is_active')) }
    it { should have_link(@intake.description), href: training_intake_path(@intake) + "?locale=en" }
      
  end
  
  describe "Intake New page" do
    before { visit new_training_intake_path }
    
    it { should have_selector('h1', text: I18n.t('training.intake.new')) }
  end
  
  describe "Intake Show page" do
    before { visit training_intake_path(@intake) }
    
    it { should have_selector('h1', text: I18n.t('training.intake.title')) }
    it { should have_selector(:link_or_button, I18n.t("helpers.links.back"))}    
    it { should have_selector(:link_or_button, I18n.t("helpers.links.edit"))}    
    it { should have_selector(:link_or_button, I18n.t("helpers.links.destroy"))}  
  end
  
end
  