require 'spec_helper'

describe "menu pages" do
  
  subject { page }
  before {@college=FactoryGirl.create(:college)}
  before {@page=FactoryGirl.create(:page)}
  before {@admin_user=FactoryGirl.create(:admin_user)}
  
  before { sign_in(@admin_user)}
  before  { visit root_path }
  
  it { should have_selector('h2', text: I18n.t('staff.title'))}
  it { should have_selector('h2', text: 'Assets')}
  it { should have_link("Assets", href: asset_assets_path + "?locale=en" ) }
  it { should have_selector('h2', text: I18n.t('location.title'))}
  it { should have_selector('h2', text: I18n.t('student.title')) }
  it { should have_link(I18n.t('position.index'), href: staff_positions_path + "?locale=en" ) }
  it { should have_link(I18n.t('staff.training.budget.title'), href: staff_training_ptbudgets_path + "?locale=en" ) }
end
