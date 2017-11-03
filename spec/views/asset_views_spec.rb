require 'spec_helper'

describe "asset pages" do
  
  subject { page }
  
  before  { @college=FactoryGirl.create(:college) }
  before  { @page=FactoryGirl.create(:page) }
  before  { @admin_user=FactoryGirl.create(:admin_user) }
  before  { @asset = FactoryGirl.create(:fixed_asset) }
  before  { @inventory = FactoryGirl.create(:inventory) }
  before  { @staff_user = FactoryGirl.create(:staff_user) }
  before  { @asset_defect = FactoryGirl.create(:asset_defect) }

  describe "Asset Index page" do
    
    before { sign_in(@admin_user) }
    before { visit asset_assets_path }

    it { should have_selector('h1', text: 'Assets') }
    it { should have_link("New",    href: new_asset_asset_path + "?locale=en")}
    it { should have_selector(:link_or_button, "Search")}
    it { should have_selector(:link_or_button, "Print")}
    it { should have_link("", href: kewpa4_asset_assets_path(:format => 'pdf') + "?locale=en")}
    it { should have_link("", href: kewpa5_asset_assets_path(:format => 'pdf') + "?locale=en")}
    it { should have_link("", href: kewpa13_asset_assets_path(:format => 'pdf') + "?locale=en")}
    it { should have_selector('th', text: 'Registration Serial No') }
    it { should have_selector('th', text: 'Manufacturer/Brand') }
    it { should have_selector('th', text: 'Local Order Date (LO Date)')}
    it { should have_selector('th', text: 'Purchase Price')}
    it { should have_link("Fixed Assets", href: '#home')}
    it { should have_link("Inventory", href: '#profile')}
    #it { should have_link(@asset.assetcode, href: asset_asset_path(@asset) + "?locale=en" ); save_and_open_page }
  end

  describe "Fixed Asset Show Page" do
    
    before { sign_in(@admin_user)}
    before { visit asset_asset_path(@asset) }
    
    it { should have_selector('h1', text: @asset.assetcode) }
    #it { should have_link("Details",  href: '#details')}
    #it { should have_link("Description", href: '#description')}
    #it { should have_link("Purchase", href: '#purchase')}
    #it { should have_link("Place",    href: '#placement')}

    #it { should have_link("", href: asset_assets_path + "?locale=en")}
    #it { should have_link("", href: kewpa2_asset_asset_path(@asset, format: "pdf") + "?locale=en")}
    #it { should_not have_link("", href: kewpa3_asset_asset_path(@asset, format: "pdf") + "?locale=en")}
    #it { should have_link("", href: kewpa6_asset_asset_path(@asset, format: "pdf") + "?locale=en")}
    #it { should have_link("", href: new_asset_defect_path(:asset_id => @asset) + "&locale=en")}
    #it { should have_link("", href: edit_asset_asset_path(@asset) + "?locale=en")}
    #it { should have_link("", href: asset_asset_path(@asset)+ "?locale=en")}
  end

  describe "Inventory Show Page" do
    
#     before { sign_in(@admin_user)}
#     before { visit asset_asset_path(@inventory) }
    
    before(:each) do
      sign_in(@admin_user)
      visit asset_asset_path(@inventory)
    end
    
    it { should have_selector('h1', text: @inventory.assetcode) }
    it { should have_link("Details",  href: '#details')}
    it { should have_link("Description", href: '#description')}
    it { should have_link(I18n.t("asset.purchase"), href: '#purchase')}
    it { should have_link("Place",    href: '#placement')}
    it { should_not have_link("Maintenance",    href: '#maintenance')}

    it { should have_link("", href: asset_assets_path + "?locale=en")}
    it { should_not have_link("", href: kewpa2_asset_asset_path(@inventory, format: "pdf") + "?locale=en")}
    it { should have_link("", href: kewpa3_asset_asset_path(@inventory, format: "pdf") + "?locale=en")}
    it { should have_link("", href: kewpa6_asset_asset_path(@inventory, format: "pdf") + "?locale=en")}
    it { should_not have_link("", href: new_asset_defect_path(:asset_id => @inventory) + "&locale=en")}
    it { should have_link("", href: edit_asset_asset_path(@inventory) + "?locale=en")}
    it { should have_link("", href: asset_asset_path(@inventory)+ "?locale=en")}
  end

  describe "Asset Edit Page" do
  end

  describe "Inventory Edit Page" do
  end

  describe "Report New Defect Page" do
    
    before { sign_in(@staff_user)}
    before { visit new_asset_defect_path(:asset_id => @asset.id, :reported_by => @staff_user.userable_id ) }
    
    it { should have_selector('h1', text: I18n.t('asset.defect.new')) }
    #it { should have_field("asset_defect[asset_show]", :disabled => true) }
    #it { should have_field("asset_defect[description]") }
    #it { should have_link(I18n.t("helpers.links.cancel"), href: asset_assets_path + "?locale=en")}
    #it { should have_selector(:link_or_button, "Create")}
  end

  describe "Report Defect Show Page" do
    
    before { sign_in(@admin_user)}
    
  end

  describe "Report Defect Index Page" do
    
    before { sign_in(@admin_user)}
    before  { @asset_defect = FactoryGirl.create(:asset_defect)}
    before { visit asset_defects_path }

    it { should have_selector('h1', text: "Asset Defect") }
    it { should have_selector('th', text: 'Registration Serial No') }
    it { should have_selector('th', text: I18n.t('asset.category.type_name_model')) }
    it { should have_selector('th', text: I18n.t('asset.serial_no'))}
    it { should have_selector('th', text: I18n.t('location.title'))}
    it { should have_selector('th', text: 'Notes')}
    it { should have_selector(:link_or_button, "New")}
    it { should have_selector(:link_or_button, "Search")}
    it { should have_selector(:link_or_button, "Print")}
    #it { should have_link((@asset_defect.asset.assetcode).to_s, href: asset_defect_path(@asset_defect.id) + "?locale=en" )}
  end

end

###### Stationery Pages
describe "stationery Pages" do
  
  subject { page }
  
  before {@college=FactoryGirl.create(:college)}
  before {@page=FactoryGirl.create(:page)}
  before {@admin_user=FactoryGirl.create(:admin_user)}
  
  before { sign_in(@admin_user)}

  describe "Stationery Index page" do
    before { visit asset_stationeries_path }

    it { should have_selector('h1', text: I18n.t('stationery.title')) }
#     it { should have_selector(:link_or_button, I18n.t('actions.new'))}
#     it { should have_selector(:link_or_button, I18n.t('actions.search'))}
#     it { should have_selector(:link_or_button, I18n.t('actions.print'))}
    it { should have_selector(:link_or_button, "New")}
    it { should have_selector(:link_or_button, "Search")}
    it { should have_selector(:link_or_button, "Print")}
    it { should have_selector('th', text: I18n.t('stationery.code')) }
    it { should have_selector('th', text: I18n.t('stationery.category')) }
    it { should have_selector('th', text: I18n.t('stationery.quantity'))}
    it { should have_selector('th', text: I18n.t('stationery.max'))}
    it { should have_selector('th', text: I18n.t('stationery.min'))}
  end

end

#have_field(id, :type => 'textarea', :disabled => true)
#(:link_or_button, arg1)
