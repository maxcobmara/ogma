require 'spec_helper'

describe "Timetable pages" do

  before { @timetable = FactoryGirl.create(:timetable) }
#   before { @timetable_period = FactoryGirl.create(:timetable_period, :timetable =>@timetable)}
  #refer app/views/timetables/show.html.haml - line 35 (@timetable.timetable_periods.in_groups_of)   
  
  #Reference : http://www.agileweboperations.com/real-world-example-using-factory_girl-to-simplify-our-test-setup  
  #tm = Factory(:trademark, :name => "A very special name")
  #model = Factory(:model, :name => "Another special name")
  #car = Factory(:car, :model => model, :trademark => tm)
  #Additional Reference : http://www.slideshare.net/gabevanslv/factory-girl-15924188 (page 94-98)
  #Other same condition : spec/views/weeklytimetable_views_spec.rb
  
  #Above Reference FIXED below error:
  #Error : ActionView::Template::Error:invalid slice size
  # ./app/views/training/timetables/show.html.haml:35:in`_app_views_training_timetables_show_html_haml___909498461651148877_2255424380'
  # ./app/controllers/training/timetables_controller.rb:23:in `show'
  # ./spec/views/timetable_views_spec.rb:30:in `block (3 levels) in <top (required)>'
  
  subject { page }

  describe "Timetable Index page" do
    before { visit training_timetables_path}
    
    it { should have_selector('h1', text: I18n.t('training.timetable.title')) }
    it { should have_selector('th', text: I18n.t('training.timetable.code')) }
    it { should have_selector('th', text: I18n.t('training.timetable.name')) }
    it { should have_selector('th', text: I18n.t('training.timetable.description')) }
    it { should have_selector('th', text: I18n.t('training.timetable.created_by')) }
    it { should have_link(@timetable.code), href: training_timetable_path(@timetable) + "?locale=en" }
    
  end
  
  #describe "Timetable New page" do
    #before { visit new_training_timetable_path }
    #it { should have_selector('h1', text: I18n.t('training.timetable.new')) }
  #end
        
  describe "Timetable Show page" do
    before { visit training_timetable_path(@timetable) }
    
    it { should have_selector('h1', text: I18n.t('training.timetable.title')) }
    it { should have_selector(:link_or_button, I18n.t("helpers.links.back"))}    
    it { should have_selector(:link_or_button, I18n.t("helpers.links.edit"))}    
    it { should have_selector(:link_or_button, I18n.t("helpers.links.destroy"))}  
  end
  
end