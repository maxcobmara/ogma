require 'spec_helper'

describe "Bulletin views" do
  
  subject { page }
  
  describe "Bulletin Index page" do
    before  { @bulletins = FactoryGirl.create(:bulletin) }
    before { visit bulletins_path }
    
    it { should have_selector('h1', text: 'List of Bulletins') }
    it { should have_selector('th', text: 'Headline') }
    it { should have_selector('th', text: 'Content') }
    it { should have_selector('th', text: 'Posted By') }
    it { should have_selector('th', text: 'Publish Date') }
    it { should have_link(@bulletins.headline), href: bulletins_path(@bulletins) + "?locale=en" }
  end
end