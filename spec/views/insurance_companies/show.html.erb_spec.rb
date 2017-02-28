require 'rails_helper'

RSpec.describe "insurance_companies/show", :type => :view do
  before(:each) do
    @insurance_company = assign(:insurance_company, InsuranceCompany.create!(
      :short_name => "Short Name",
      :long_name => "Long Name",
      :active => false,
      :college_id => 1,
      :data => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Short Name/)
    expect(rendered).to match(/Long Name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/MyText/)
  end
end
