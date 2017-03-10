require 'rails_helper'

RSpec.describe "visitors/show", :type => :view do
  before(:each) do
    @visitor = assign(:visitor, Visitor.create!(
      :name => "Name",
      :icno => "Icno",
      :rank_id => 1,
      :title => 2,
      :department => "Department",
      :officeno => "Officeno",
      :hpno => "Hpno",
      :email => "Email",
      :expertise => "Expertise"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Icno/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Department/)
    expect(rendered).to match(/Officeno/)
    expect(rendered).to match(/Hpno/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Expertise/)
  end
end
