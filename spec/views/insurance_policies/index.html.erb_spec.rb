require 'rails_helper'

RSpec.describe "insurance_policies/index", :type => :view do
  before(:each) do
    assign(:insurance_policies, [
      InsurancePolicy.create!(
        :insurance_type => 1,
        :company_id => 2,
        :policy_no => "Policy No",
        :college_id => 3,
        :data => "MyText"
      ),
      InsurancePolicy.create!(
        :insurance_type => 1,
        :company_id => 2,
        :policy_no => "Policy No",
        :college_id => 3,
        :data => "MyText"
      )
    ])
  end

  it "renders a list of insurance_policies" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Policy No".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
