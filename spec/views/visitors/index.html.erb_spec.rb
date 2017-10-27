require 'rails_helper'

RSpec.describe "campus/visitors/index", :type => :view do
  before(:each) do
    assign(:visitors, [
      Visitor.create!(
        :name => "Name",
        :icno => "Icno",
        :rank_id => 1,
        :title_id => 1,
        :department => "Department",
        :phoneno => "Phoneno",
        :hpno => "Hpno",
        :email => "Email",
        :expertise => "Expertise"
      ),
      Visitor.create!(
        :name => "Name",
        :icno => "Icno",
        :rank_id => 1,
        :title_id => 1,
        :department => "Department",
        :phoneno => "Phoneno",
        :hpno => "Hpno",
        :email => "Email",
        :expertise => "Expertise"
      )
    ])
  end

  it "renders a list of visitors" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Icno".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "1", :count => 2
    assert_select "tr>td", :text => "Department".to_s, :count => 2
    assert_select "tr>td", :text => "Phoneno".to_s, :count => 2
    assert_select "tr>td", :text => "Hpno".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Expertise".to_s, :count => 2
  end
end
