require 'rails_helper'

RSpec.describe "groups/edit", :type => :view do
  before(:each) do
    @staff_user=FactoryGirl.create(:staff_user)
    sign_in(@staff_user)
    @group=FactoryGirl.create(:group)
    @mailboxer=FactoryGirl.create(:mailboxer_conversation)

    # TODO - find solution for mailbox_helper.rb ... how to define mailbox (like current_user)
    #Mailboxer::Receipt.inbox(all records)=mailbox.inbox(current_user)
  end

  it "renders the edit group form" do
    render

    assert_select "form[action=?][method=?]", group_path(@group), "post" do
      assert_select "input#group_name[name=?]", "group[name]"
      assert_select "input#group_description[name=?]", "group[description]"
      assert_select "select#group_members_user_ids[name=?]", "group[members][user_ids][]"
    end
  end
end
