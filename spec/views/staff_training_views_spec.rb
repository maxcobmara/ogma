require 'spec_helper'

describe "staff training pages" do
  
  before  { @budget = FactoryGirl.create(:ptbudget) }
  before  { @course = FactoryGirl.create(:ptcourse) }
  before  { @ptschedule = FactoryGirl.create(:ptschedule) }
  subject { page }
  
  describe "Staff Training Budget Index page" do
    before  { @college = FactoryGirl.create(:college) }
    before { visit staff_training_ptbudgets_path }
    
    it { should have_selector('h1', text: I18n.t('staff.training.budget.title')) }
    it { should have_link("New",    href: new_staff_training_ptbudget_path + "?locale=en")}
    it { should have_selector(:link_or_button, "Search")}    
    it { should have_selector(:link_or_button, "Print")}
    it { should have_selector('th', text: I18n.t('staff.training.budget.start')) }
    it { should have_selector('th', text: I18n.t('staff.training.budget.budget')) }
    it { should have_selector('th', text: I18n.t('staff.training.budget.used'))}
    it { should have_selector('th', text: I18n.t('staff.training.budget.balance'))}
    it { should have_link( budget_range(@budget), href: staff_training_ptbudget_path(@budget) + "?locale=en") }
  end
  
  describe "Staff Training Budget New page" do
    before  { @college = FactoryGirl.create(:college) }
    before { visit new_staff_training_ptbudget_path }
    
    it { should have_selector('h1', text: I18n.t('staff.training.budget.new')) }
  end
  
  describe "Staff Training Budget Show page" do
    before  { @college = FactoryGirl.create(:college) }
    before { visit staff_training_ptbudget_path(@budget) }
    
    it { should have_selector('h1', text: budget_range(@budget)) }
    it { should have_selector(:link_or_button, "Back")}    
    it { should have_selector(:link_or_button, "Edit")}    
    it { should have_selector(:link_or_button, "Destroy")}    
  end
  
  describe "Staff Training Courses Index page" do
    before  { @college = FactoryGirl.create(:college) }
    before { visit staff_training_ptcourses_path }
    
    it { should have_selector('h1', text: I18n.t('staff.training.course.title')) }
    it { should have_link("New",    href: new_staff_training_ptcourse_path + "?locale=en")}
    it { should have_selector(:link_or_button, "Search")}    
    it { should have_selector(:link_or_button, "Print")}
    it { should have_selector('th', text: I18n.t('staff.training.course.name')) }
    it { should have_selector('th', text: I18n.t('staff.training.course.provider')) }
    it { should have_selector('th', text: I18n.t('staff.training.course.costs'))}
    it { should have_selector('th', text: I18n.t('staff.training.course.description'))}
    it { should have_selector('th', text: I18n.t('staff.training.course.approval'))}
    #it { should have_link( budget_range(@budget), href: staff_training_ptbudget_path(@budget) + "?locale=en") }
  end
  
  describe "Staff Training Course New page" do
    before  { @college = FactoryGirl.create(:college) }
    before { visit new_staff_training_ptcourse_path }
    it { should have_selector('h1', text: I18n.t('staff.training.course.new')) }
    it { should have_selector(:link_or_button, "Back")}    
    it { should have_selector(:link_or_button, "Create")}    
  end
  
  describe "Staff Training Course Show page" do
    before  { @college = FactoryGirl.create(:college) }
    before { visit staff_training_ptcourse_path(@course) }
    
    it { should have_selector('h1', text: @course.name) }
    it { should have_selector(:link_or_button, "Back")}    
    it { should have_selector(:link_or_button, "Edit")}    
    it { should have_selector(:link_or_button, "Destroy")}    
  end
  
  describe "Staff Training Course Edit page" do
    before  { @college = FactoryGirl.create(:college) }
    before { visit edit_staff_training_ptcourse_path(@course) }
    
    it { should have_selector('h1', text: @course.name) }
    #it { should have_selector(:link_or_button, "Save")}    
  end
  
  describe "Staff Training Schedule Index page" do
    before  { @college = FactoryGirl.create(:college) }
    before { visit staff_training_ptschedules_path }
    
    it { should have_selector('h1', text: I18n.t('staff.training.schedule.title')) }
    #it { should_not have_selector(:link_or_button, "New")}    
    it { should have_selector(:link_or_button, I18n.t('search'))}    
    it { should have_selector(:link_or_button, I18n.t('print'))}
    #it { should have_css('div.calendar_list')}
    #it { should have_link( budget_range(@budget), href: staff_training_ptbudget_path(@budget) + "?locale=en") }
  end

  describe "Staff Training Schedule New page" do
    before  { @college = FactoryGirl.create(:college) }
    before { visit new_staff_training_ptschedule_path(ptcourse_id: @ptschedule.ptcourse_id) }
    
    it { should have_selector('h1', text: I18n.t('staff.training.schedule.new')) }   
    it { should have_selector(:link_or_button, "Create")}    
  end
  
  describe "Staff Training Request Index page" do
    before  { @college = FactoryGirl.create(:college) }
    before { visit staff_training_ptdos_path }
    
    it { should have_selector('h1', text: I18n.t('staff.training.do.title')) }
    #it { should_not have_selector(:link_or_button, "New")}    
    it { should have_selector(:link_or_button, I18n.t('search'))}    
    it { should have_selector(:link_or_button, I18n.t('print'))}
    #it { should have_link( budget_range(@budget), href: staff_training_ptbudget_path(@budget) + "?locale=en") }
    
    #TODO have a my training chart
  end
end
