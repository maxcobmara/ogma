require 'rails_helper'

RSpec.describe "campus/visitors/show", :type => :view do
  before(:each) do
    @visitor = assign(:visitor, Visitor.create!(
      :name => "Name",
      :icno => "Icno",
      :rank_id => 1,
      :title_id => 1,
      :department => "Department",
      :phoneno => "Phoneno",
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
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Department/)
    expect(rendered).to match(/Phoneno/)
    expect(rendered).to match(/Hpno/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Expertise/)
  end
end
