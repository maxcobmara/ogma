require 'spec_helper'

describe "asset pages" do
  before  { @asset = FactoryGirl.create(:asset) }
  subject { page }
  

  describe "Asset Index page" do
    before { visit asset_assets_path }
    
    it { should have_selector('h1', text: 'Assets') }
    it { should have_selector('th', text: 'Registration Serial No') }
    it { should have_selector('th', text: 'Manufacturer/Brand') }
    it { should have_selector('th', text: 'Local Order Date (LO Date)')}
    it { should have_selector('th', text: 'Purchase Price')}
    it { should have_link("Fixed Assets", href: '#home')}
    it { should have_link("Inventory", href: '#profile')}
    #it { should have_link(@asset.assetcode, href: asset_asset_path(@asset) + "?locale=en" ); save_and_open_page }
  end
  
  describe "Asset Show Page" do
    before { visit asset_asset_path(@asset) }
    it { should have_selector('h1', text: @asset.assetcode) }
  end
  
  describe "Asset Edit Page" do
  end
  
  
end

			