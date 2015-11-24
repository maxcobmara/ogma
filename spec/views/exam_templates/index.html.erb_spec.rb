require 'rails_helper'

RSpec.describe "exam_templates/index", :type => :view do
  before(:each) do
    assign(:exam_templates, [
      ExamTemplate.create!(
        :name => "",
        :created_by => "",
        :data => ""
      ),
      ExamTemplate.create!(
        :name => "",
        :created_by => "",
        :data => ""
      )
    ])
  end

  it "renders a list of exam_templates" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
