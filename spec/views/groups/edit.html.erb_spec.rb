require 'rails_helper'

RSpec.describe "groups/edit", :type => :view do
  before(:each) do
    @group = assign(:group, Group.create!(
      :name => "MyString",
      :description => "MyString",
      :members => "MyText"
    ))
  end

  it "renders the edit group form" do
    render

    assert_select "form[action=?][method=?]", group_path(@group), "post" do

      assert_select "input#group_name[name=?]", "group[name]"

      assert_select "input#group_description[name=?]", "group[description]"

      assert_select "textarea#group_members[name=?]", "group[members]"
    end
  end
end