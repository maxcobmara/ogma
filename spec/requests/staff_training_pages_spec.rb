require 'spec_helper'

describe "Staff Training Cycle " do
  context "Create New Training Budget" do
    let(:ptbudget) { FactoryGirl.create(:ptbudget) }
    it "creates and saves budget" do
      visit staff_training_ptbudgets_path
      click_link('New')
    end
  end
end