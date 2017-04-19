require 'rails_helper'

RSpec.describe "repositorysearches/new", :type => :view do
  before(:each) do
    assign(:repositorysearch, Repositorysearch.new(
      :keyword => "MyText",
      :college_id => 1,
      :data => "MyText"
    ))
  end

  it "renders new repositorysearch form" do
    render

    assert_select "form[action=?][method=?]", repositorysearches_path, "post" do

      assert_select "textarea#repositorysearch_keyword[name=?]", "repositorysearch[keyword]"

      assert_select "input#repositorysearch_college_id[name=?]", "repositorysearch[college_id]"

      assert_select "textarea#repositorysearch_data[name=?]", "repositorysearch[data]"
    end
  end
end
