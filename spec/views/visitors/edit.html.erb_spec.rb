require 'rails_helper'

RSpec.describe "visitors/edit", :type => :view do
  before(:each) do
    @visitor = assign(:visitor, Visitor.create!(
      :name => "MyString",
      :icno => "MyString",
      :rank_id => 1,
      :title => 1,
      :department => "MyString",
      :officeno => "MyString",
      :hpno => "MyString",
      :email => "MyString",
      :expertise => "MyString"
    ))
  end

  it "renders the edit visitor form" do
    render

    assert_select "form[action=?][method=?]", visitor_path(@visitor), "post" do

      assert_select "input#visitor_name[name=?]", "visitor[name]"

      assert_select "input#visitor_icno[name=?]", "visitor[icno]"

      assert_select "input#visitor_rank_id[name=?]", "visitor[rank_id]"

      assert_select "input#visitor_title[name=?]", "visitor[title]"

      assert_select "input#visitor_department[name=?]", "visitor[department]"

      assert_select "input#visitor_officeno[name=?]", "visitor[officeno]"

      assert_select "input#visitor_hpno[name=?]", "visitor[hpno]"

      assert_select "input#visitor_email[name=?]", "visitor[email]"

      assert_select "input#visitor_expertise[name=?]", "visitor[expertise]"
    end
  end
end
