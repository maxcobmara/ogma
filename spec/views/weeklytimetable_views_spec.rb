require 'spec_helper'

describe "Weeklytimetable pages" do

  #refer app/views/weeklytimetables/_tab_timetable_period.html.haml - line 8 (@weeklytimetable.timetable_monthurs.timetable_periods)
  
  #Reference : http://www.agileweboperations.com/real-world-example-using-factory_girl-to-simplify-our-test-setup  
  #tm = Factory(:trademark, :name => "A very special name")
  #model = Factory(:model, :name => "Another special name")
  #car = Factory(:car, :model => model, :trademark => tm)
  #Additional Reference : http://www.slideshare.net/gabevanslv/factory-girl-15924188 (page 94-98)
  #Other same condition : spec/views/timetable_views_spec.rb
  
  #Above Reference FIXED - "Invalid Slice Size" error by replacing (#before { @weeklytimetable = FactoryGirl.create(:weeklytimetable) }) with 5 LINES below:
  
  before { @timetable_monthurs = FactoryGirl.create(:timetable) }
  before { @timetable_friday = FactoryGirl.create(:timetable) }
  
#   before { @timetable_period = FactoryGirl.create(:timetable_period, :timetable => @timetable_monthurs) }
#   before { @timetable_period = FactoryGirl.create(:timetable_period, :timetable => @timetable_friday) }
  
  before { @weeklytimetable = FactoryGirl.create(:weeklytimetable, :timetable_monthurs => @timetable_monthurs, :timetable_friday => @timetable_friday) }
 
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
  
end
  