require 'rails_helper'

RSpec.describe "groups/show", :type => :view do
  before(:each) do
    @staff_user=FactoryGirl.create(:staff_user)
    sign_in(@staff_user)
    @member1=FactoryGirl.create(:staff_user)
    @member2=FactoryGirl.create(:staff_user)
    @member3=FactoryGirl.create(:staff_user)
    @group=FactoryGirl.create(:group, :members => {user_ids: [@member1.id.to_s, @member2.id.to_s, @member3.id.to_s]})
    @mailboxer=FactoryGirl.create(:mailboxer_conversation)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Some Name/)
    expect(rendered).to match(/Some Description/)
    assert_select "ol" do
      assert_select "li", 3
    end
    assert_select "ol>li", :text => "#{@member1.userable.name} (#{@member1.userable.position_for_staff} - #{@member1.userable.render_unit})", :count => 1
    assert_select "ol>li", :text => "#{@member2.userable.name} (#{@member2.userable.position_for_staff} - #{@member1.userable.render_unit})", :count => 1
    assert_select "ol>li", :text => "#{@member3.userable.name} (#{@member3.userable.position_for_staff} - #{@member1.userable.render_unit})", :count => 1
  end
end
