require 'spec_helper'

describe "staff training pages" do
  before  { @budget = FactoryGirl.create(:ptbudget) }
  before  { @course = FactoryGirl.create(:ptcourse) }
  subject { page }
  
  describe "Staff Training Budget Index page" do
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
    before { visit new_staff_training_ptbudget_path }
    
    it { should have_selector('h1', text: I18n.t('staff.training.budget.new')) }
  end
  
  describe "Staff Training Budget Show page" do
    before { visit staff_training_ptbudget_path(@budget) }
    
    it { should have_selector('h1', text: budget_range(@budget)) }
    it { should have_selector(:link_or_button, "Back")}    
    it { should have_selector(:link_or_button, "Edit")}    
    it { should have_selector(:link_or_button, "Destroy")}    
  end
  
  describe "Staff Training Courses Index page" do
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
  
  describe "Staff Training Course Show page" do
    before { visit staff_training_ptcourse_path(@course) }
    
    it { should have_selector('h1', text: @course.name) }
    it { should have_selector(:link_or_button, "Back")}    
    it { should have_selector(:link_or_button, "Edit")}    
    it { should have_selector(:link_or_button, "Destroy")}    
  end
  
end
