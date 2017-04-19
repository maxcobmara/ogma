require 'rails_helper'

RSpec.describe "repositorysearches/edit", :type => :view do
  before(:each) do
    @repositorysearch = assign(:repositorysearch, Repositorysearch.create!(
      :keyword => "MyText",
      :college_id => 1,
      :data => "MyText"
    ))
  end

  it "renders the edit repositorysearch form" do
    render

    assert_select "form[action=?][method=?]", repositorysearch_path(@repositorysearch), "post" do

      assert_select "textarea#repositorysearch_keyword[name=?]", "repositorysearch[keyword]"

      assert_select "input#repositorysearch_college_id[name=?]", "repositorysearch[college_id]"

      assert_select "textarea#repositorysearch_data[name=?]", "repositorysearch[data]"
    end
  end
end
