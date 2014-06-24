require 'spec_helper'

describe "staff training pages" do
  before  { @budget = FactoryGirl.create(:ptbudget) }
  subject { page }
  
  describe "Training Budget page" do
    before { visit staff_training_budgets_path }
    
    it { should have_selector('h1', text: I18n.t('staff.training.budget.title')) }
    it { should have_link("New",    href: new_staff_training_budget_path + "?locale=en")}
    it { should have_selector(:link_or_button, "Search")}    
    it { should have_selector(:link_or_button, "Print")}
    it { should have_selector('th', text: I18n.t('staff.training.budget.start')) }
    it { should have_selector('th', text: I18n.t('staff.training.budget.budget')) }
    it { should have_selector('th', text: I18n.t('staff.training.budget.used'))}
    it { should have_selector('th', text: I18n.t('staff.training.budget.balance'))}
    it { should have_link( budget_range(@budget), href: staff_training_budget_path(@budget) + "?locale=en") }
  end
  
end
