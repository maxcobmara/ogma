require 'spec_helper'

describe "position pages" do
  before  { @position = FactoryGirl.create(:position) }
  subject { page }
  

  describe "Staff Index page" do
    before { visit staff_positions_path }
    
    it { should have_selector('h1', text: 'Organisation Chart') }
  end
end