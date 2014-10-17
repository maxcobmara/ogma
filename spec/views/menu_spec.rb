require 'spec_helper'

describe "menu pages" do
  before { visit root_path }
  subject { page }
  it { should have_selector('h2', text: 'Staff')}
  it { should have_selector('h2', text: 'Assets')}
  it { should have_link("Assets", href: asset_assets_path + "?locale=en" ) }
  it { should have_selector('h2', text: 'Locations')}
  it { should have_selector('h2', text: I18n.t('student.title')) }
  it { should have_link(I18n.t('position.title'), href: staff_positions_path + "?locale=en" ) }
  it { should have_link(I18n.t('staff.training.budget.title'), href: staff_training_ptbudgets_path + "?locale=en" ) }
end