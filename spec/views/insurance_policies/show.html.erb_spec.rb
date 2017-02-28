require 'rails_helper'

RSpec.describe "insurance_policies/show", :type => :view do
  before(:each) do
    @insurance_policy = assign(:insurance_policy, InsurancePolicy.create!(
      :insurance_type => 1,
      :company_id => 2,
      :policy_no => "Policy No",
      :college_id => 3,
      :data => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Policy No/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/MyText/)
  end
end
