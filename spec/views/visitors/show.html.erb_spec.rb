require 'rails_helper'

RSpec.describe "campus/visitors/show", :type => :view do
  before(:each) do
    @visitor=FactoryGirl.create(:visitor)
  end

  it "renders attributes in <p>" do
    render :template => 'campus/visitors/show'
    
    assert_select "dl>dd", :text => "#{@visitor.rank.shortname} #{@visitor.name}", :count => 1
    assert_select "dl>dd", :text => "#{formatted_mykad(@visitor.icno)}", :count => 1
    expect(rendered).to match(/1/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Department/)
    assert_select "dl>dd", :text => "#{@visitor.phoneno}", :count => 1
    assert_select "dl>dd", :text => "#{@visitor.hpno}", :count => 1
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Expertise/)
  end
end
