require 'rails_helper'

RSpec.describe "equery_report/repositorysearches/show", :type => :view do
  before(:each) do
    @repositorysearch = assign(:repositorysearch, Repositorysearch.create!(
      :keyword => {:repotype=> 1, :title => 'Mytitle'},
      :college_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render :template => "equery_report/repositorysearches/show"
    # TODO
    #expect(rendered).to match(/---\n:repotype: 1\n:title: Mytitle\n/)
#     expect(rendered).to match(/{:repotype=>1, :title=>"Mytitle"}/)
#     expect(rendered).to match(/:repotype=>1, :title=>"Mytitle"/)
#     expect(rendered).to match(/{:repotype=>1, :title=>\"Mytitle\"}/)
#     expect(rendered).to match(/Mytitle/)
    expect(rendered).to match(/1/)
   # expect(rendered).to match(/{}/)
    
  end
end
