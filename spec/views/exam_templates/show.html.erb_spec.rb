require 'rails_helper'

RSpec.describe "exam_templates/show", :type => :view do
  before(:each) do
    @exam_template = assign(:exam_template, ExamTemplate.create!(
      :name => "",
      :created_by => "",
      :data => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
