require 'rails_helper'

RSpec.describe "repositorysearches/index", :type => :view do
  before(:each) do
    assign(:repositorysearches, [
      Repositorysearch.create!(
        :keyword => "MyText",
        :college_id => 1,
        :data => "MyText"
      ),
      Repositorysearch.create!(
        :keyword => "MyText",
        :college_id => 1,
        :data => "MyText"
      )
    ])
  end

  it "renders a list of repositorysearches" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
