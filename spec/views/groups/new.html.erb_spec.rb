require 'rails_helper'

RSpec.describe "groups/new", :type => :view do
  before(:each) do
    @staff_user=FactoryGirl.create(:staff_user)
    sign_in(@staff_user)
    @group=FactoryGirl.create(:group)
    @mailboxer=FactoryGirl.create(:mailboxer_conversation)
  end

  it "renders new group form" do
    render

#     assert_select "form[action=?][method=?]", groups_path, "post" do
    assert_select "form[action=?][method=?]", group_path(@group), "post" do   #note - shared form in partial - refer app/views/groups/_form.html.haml
      assert_select "input#group_name[name=?]", "group[name]"
      assert_select "input#group_description[name=?]", "group[description]"
      assert_select "select#group_members_user_ids[name=?]", "group[members][user_ids][]"
    end
    
  end
end
