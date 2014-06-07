require 'spec_helper'

describe "menu pages" do
  before { visit root_path }
  subject { page }
  it { should have_selector('h2', text: 'Staff')}
  it { should have_selector('h2', text: 'Assets')}
  it { should have_selector('h2', text: 'Locations')}
  it { should have_selector('h2', text: 'Students')}
  it { should have_link("Task & Responsibilities", href: staff_positions_path + "?locale=en" ) }
end