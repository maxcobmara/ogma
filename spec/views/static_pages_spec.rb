require 'spec_helper'

describe "Static pages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }
    
    it { should have_content('Campus Events') }
    it { should have_title("Ogma") }
    it { should_not have_title('| Home') }
    it { should have_selector('h1', text: 'About Us') }
  end
  
  describe "Help page" do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1', text: 'Contact') }
    it { should have_content('Contact Page') }
  end
end