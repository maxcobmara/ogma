require 'rails_helper'

RSpec.describe "campus/visitors/new", :type => :view do
  before(:each) do
    @visitor=FactoryGirl.create(:visitor)
    @staff_user=FactoryGirl.create(:staff_user)
    sign_in(@staff_user)
  end

  it "renders new visitor form" do
    
    render :template => 'campus/visitors/new'    
    
    assert_select "form[action=?][method=?]", campus_visitor_path(@visitor), "post" do

      assert_select "input#visitor_name[name=?]", "visitor[name]"
      assert_select "input#visitor_icno[name=?]", "visitor[icno]"
      assert_select "select#visitor_rank_id[name=?]", "visitor[rank_id]"
      assert_select "select#visitor_title_id[name=?]", "visitor[title_id]"
      assert_select "input#visitor_department[name=?]", "visitor[department]"
      assert_select "select#visitor_address_book_id[name=?]", "visitor[address_book_id]"
      assert_select "input#visitor_corporate[name=?]", "visitor[corporate]"
      assert_select "input#visitor_phoneno[name=?]", "visitor[phoneno]"
      assert_select "input#visitor_hpno[name=?]", "visitor[hpno]"
      assert_select "input#visitor_email[name=?]", "visitor[email]"
      assert_select "input#visitor_expertise[name=?]", "visitor[expertise]"
      
    end
  end
end
