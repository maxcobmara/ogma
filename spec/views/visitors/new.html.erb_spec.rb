require 'rails_helper'

RSpec.describe "campus/visitors/new", :type => :view do
  before(:each) do
    assign(:visitor, Visitor.new(
      :name => "MyString",
      :icno => "MyString",
      :rank_id => 1,
      :title_id => 1,
      :department => "MyString",
      :phoneno => "MyString",
      :hpno => "MyString",
      :email => "MyString",
      :expertise => "MyString"
    ))
  end
  
  before(:each) do
    assign(:staff_user, [
      User.create!(
	:email => "test@gmmm.com",
	:password => "12345678",
	:password_confirmation => "12345678",
	:college_id => 1,
	:userable_type => "staff",
	:userable_id => 1
      )
    ])
  end
  
  before { sign_in (:staff_user)}

  it "renders new visitor form" do
    render

    assert_select "form[action=?][method=?]", visitors_path, "post" do

      assert_select "input#visitor_name[name=?]", "visitor[name]"

      assert_select "input#visitor_icno[name=?]", "visitor[icno]"

      assert_select "input#visitor_rank_id[name=?]", "visitor[rank_id]"

      assert_select "input#visitor_title_id[name=?]", "visitor[title_id]"

      assert_select "input#visitor_department[name=?]", "visitor[department]"

      assert_select "input#visitor_phoneno[name=?]", "visitor[phoneno]"

      assert_select "input#visitor_hpno[name=?]", "visitor[hpno]"

      assert_select "input#visitor_email[name=?]", "visitor[email]"

      assert_select "input#visitor_expertise[name=?]", "visitor[expertise]"
    end
  end
end
