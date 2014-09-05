require 'spec_helper'

describe "Weeklytimetable pages" do

  before { @weeklytimetable = FactoryGirl.create(:weeklytimetable) }
  subject { page }

  describe "Weeklytimetable Index page" do 
    before { visit training_weeklytimetables_path }
  
    it {should have_selector('h1', text: I18n.t('training.weeklytimetable.title')) }
    it {should have_selector('th', text: I18n.t('training.weeklytimetable.programme_id')) }
    it {should have_selector('th', text: I18n.t('training.weeklytimetable.intake_id')) }
    it {should have_selector('th', text: I18n.t('training.weeklytimetable.startdate')) }
    it {should have_selector('th', text: I18n.t('training.weeklytimetable.enddate')) }
    it {should have_selector('th', text: I18n.t('training.weeklytimetable.semester')) }
    it {should have_selector('th', text: I18n.t('training.weeklytimetable.prepared_by')) }
    it {should have_selector('th', text: I18n.t('training.weeklytimetable.is_submitted')) }
    it {should have_selector('th', text: I18n.t('training.weeklytimetable.is_approved')) }
    it { should have_link(@weeklytimetable.schedule_programme.programme_list), href: training_weeklytimetable_path(@weeklytimetable) + "?locale=en" }
      
  end
  
  describe "Weeklytimetable New page" do
    before { visit new_training_weeklytimetable_path }
    
    it { should have_selector('h1', text: I18n.t('training.weeklytimetable.new')) }
  end
  
  describe "Weeklytimetable Show page" do
    before { visit training_weeklytimetable_path(@weeklytimetable) }
    
    it { should have_selector('h1', text: I18n.t('training.weeklytimetable.title')) }
    it { should have_selector(:link_or_button, I18n.t("helpers.links.back"))}    
    #it { should have_selector(:link_or_button, I18n.t("helpers.links.edit"))}    
    #it { should have_selector(:link_or_button, I18n.t("helpers.links.destroy"))}  
    
  end
  
  #Error : Weeklytimetable pages Weeklytimetable Show page - Failure/Error: before { visit training_weeklytimetable_path(@weeklytimetable) }
  #ActionView::Template::Error: invalid slice size
  # ./app/views/training/weeklytimetables/_tab_timetable_period.html.haml:8:in `_app_views_training_weeklytimetables__tab_timetable_period_html_haml___3293879218971612429_2262758020'
  # ./app/views/training/weeklytimetables/show.html.haml:50:in `_app_views_training_weeklytimetables_show_html_haml__2462618168911437335_2158135320'
  # ./app/controllers/training/weeklytimetables_controller.rb:62:in `show'
  # ./spec/views/weeklytimetable_views_spec.rb:31:in `block (3 levels) in <top (required)>'
  
end
  