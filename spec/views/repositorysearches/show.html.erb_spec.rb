require 'rails_helper'

RSpec.describe "repositorysearches/show", :type => :view do
  before(:each) do
    @repositorysearch = assign(:repositorysearch, Repositorysearch.create!(
      :keyword => "MyText",
      :college_id => 1,
      :data => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/MyText/)
  end
end
