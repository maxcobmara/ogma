require 'spec_helper'


describe "Fixed Assets Damage cycle" do
  context "Create Fixed Asset" do
    let(:asset) { FactoryGirl.create(:asset) }
    it "creates and saves fixed asset" do
      visit asset_assets_path
      click_link('New')
      page.should have_selector('h1', text: "Register New Asset")
      select("H", from: "asset[assettype]" )
      select(Time.now.year, from: "asset[receiveddate(1i)]" )
      #page.should have_xpath %q(//*[@data-id="asset_assettype"])
      #page.should have_xpath %q(//*["asset_assettype"])
    end
  end
end

			