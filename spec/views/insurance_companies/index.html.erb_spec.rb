require 'rails_helper'

RSpec.describe "insurance_companies/index", :type => :view do
  before(:each) do
    assign(:insurance_companies, [
      InsuranceCompany.create!(
        :short_name => "Short Name",
        :long_name => "Long Name",
        :active => false,
        :college_id => 1,
        :data => "MyText"
      ),
      InsuranceCompany.create!(
        :short_name => "Short Name",
        :long_name => "Long Name",
        :active => false,
        :college_id => 1,
        :data => "MyText"
      )
    ])
  end

  it "renders a list of insurance_companies" do
    render
    assert_select "tr>td", :text => "Short Name".to_s, :count => 2
    assert_select "tr>td", :text => "Long Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
