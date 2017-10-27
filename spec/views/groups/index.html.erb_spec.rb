require 'rails_helper'

RSpec.describe "groups/index", :type => :view do
  
  before(:each) do
    @admin_user=FactoryGirl.create(:admin_user)
    sign_in(@admin_user)
    @member1=FactoryGirl.create(:staff_user)
    @member2=FactoryGirl.create(:staff_user)
    @member3=FactoryGirl.create(:staff_user)
    @member4=FactoryGirl.create(:staff_user)
    @member5=FactoryGirl.create(:staff_user)
    @member6=FactoryGirl.create(:staff_user)
    @group1=FactoryGirl.create(:group, :members => {user_ids: [@member1.id.to_s, @member2.id.to_s, @member3.id.to_s]})
    @group2=FactoryGirl.create(:group, :members => {user_ids: [@member4.id.to_s, @member5.id.to_s, @member6.id.to_s]})
    @mailboxer=FactoryGirl.create(:mailboxer_conversation)
    
    @search=Group.search(params[:q])
    @groups=@search.result.page(params[:page]).per(5)
  end

  it "renders a list of groups" do
    render
    assert_select "tr>td", :text => "#{@group1.name}".to_s, :count => 1
    assert_select "tr>td", :text => "#{@group2.name}".to_s, :count => 1
    assert_select "tr>td", :text => "Some Description".to_s, :count => 2
    assert_select "ol" do
      assert_select "li", 6
    end
    assert_select "ol>li", :text => "#{@member1.userable.name}    (#{@member1.userable.position_for_staff})", :count => 1
    assert_select "ol>li", :text => "#{@member2.userable.name}    (#{@member2.userable.position_for_staff})", :count => 1
    assert_select "ol>li", :text => "#{@member3.userable.name}    (#{@member3.userable.position_for_staff})", :count => 1
    assert_select "ol>li", :text => "#{@member4.userable.name}    (#{@member4.userable.position_for_staff})", :count => 1
    assert_select "ol>li", :text => "#{@member5.userable.name}    (#{@member5.userable.position_for_staff})", :count => 1
    assert_select "ol>li", :text => "#{@member6.userable.name}    (#{@member6.userable.position_for_staff})", :count => 1
  end
end
