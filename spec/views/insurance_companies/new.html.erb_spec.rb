require 'rails_helper'

RSpec.describe "insurance_companies/new", :type => :view do
  before(:each) do
    assign(:insurance_company, InsuranceCompany.new(
      :short_name => "MyString",
      :long_name => "MyString",
      :active => false,
      :college_id => 1,
      :data => "MyText"
    ))
  end

  it "renders new insurance_company form" do
    render

    assert_select "form[action=?][method=?]", insurance_companies_path, "post" do

      assert_select "input#insurance_company_short_name[name=?]", "insurance_company[short_name]"

      assert_select "input#insurance_company_long_name[name=?]", "insurance_company[long_name]"

      assert_select "input#insurance_company_active[name=?]", "insurance_company[active]"

      assert_select "input#insurance_company_college_id[name=?]", "insurance_company[college_id]"

      assert_select "textarea#insurance_company_data[name=?]", "insurance_company[data]"
    end
  end
end
