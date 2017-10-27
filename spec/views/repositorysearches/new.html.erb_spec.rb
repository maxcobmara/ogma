require 'rails_helper'

RSpec.describe "equery_report/repositorysearches/new", :type => :view do
  

  before(:each) do
#     @college=FactoryGirl.create(:college)
#     @page=FactoryGirl.create(:page)
#     @admin_user=FactoryGirl.create(:admin_user)
#     sign_in @admin_user

#     https://stackoverflow.com/questions/4308094/all-ruby-tests-raising-undefined-method-authenticate-for-nilnilclass
    allow(view).to receive(:current_user).and_return(FactoryGirl.create(:admin_user))
  end
  
  before(:each) do
    assign(:repositorysearch, Repositorysearch.new(
      :keyword => {},
      :college_id => 1,
      :data => {}
    ))
  end

  it "renders new repositorysearch form" do
#     render
#     
#     https://stackoverflow.com/questions/8014038/rails-3-rspec-2-testing-content-for
#     render :template => 'companies/index', :layout => 'layouts/companies'
#     
    render :template => 'equery_report/repositorysearches/new'

    assert_select "form[action=?][method=?]", equery_report_repositorysearches_path, "post" do
      assert_select "input#repositorysearch_repotype[name=?]", "repositorysearch[repotype]"
      assert_select "input#repositorysearch_college_id[name=?]", "repositorysearch[college_id]"
      assert_select "input#repositorysearch_title[name=?]", "repositorysearch[title]"
    end
  end
end
