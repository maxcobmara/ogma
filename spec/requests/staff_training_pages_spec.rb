require 'spec_helper'

describe "staff training pages" do
  before  { @budget = FactoryGirl.create(:ptbudget) }
  subject { page }
  
  describe "Create New Training Budget" do
    before { visit staff_training_budgets_path }
    click "New"
  end
  
end
