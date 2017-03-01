require 'rails_helper'

RSpec.describe "insurance_companies/edit", :type => :view do
  before(:each) do
    @insurance_company = assign(:insurance_company, InsuranceCompany.create!(
      :short_name => "MyString",
      :long_name => "MyString",
      :active => false,
      :college_id => 1,
      :data => "MyText"
    ))
  end

  it "renders the edit insurance_company form" do
    render

    assert_select "form[action=?][method=?]", insurance_company_path(@insurance_company), "post" do

      assert_select "input#insurance_company_short_name[name=?]", "insurance_company[short_name]"

      assert_select "input#insurance_company_long_name[name=?]", "insurance_company[long_name]"

      assert_select "input#insurance_company_active[name=?]", "insurance_company[active]"

      assert_select "input#insurance_company_college_id[name=?]", "insurance_company[college_id]"

      assert_select "textarea#insurance_company_data[name=?]", "insurance_company[data]"
    end
  end
end
