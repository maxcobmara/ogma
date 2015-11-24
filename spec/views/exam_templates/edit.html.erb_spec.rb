require 'rails_helper'

RSpec.describe "exam_templates/edit", :type => :view do
  before(:each) do
    @exam_template = assign(:exam_template, ExamTemplate.create!(
      :name => "",
      :created_by => "",
      :data => ""
    ))
  end

  it "renders the edit exam_template form" do
    render

    assert_select "form[action=?][method=?]", exam_template_path(@exam_template), "post" do

      assert_select "input#exam_template_name[name=?]", "exam_template[name]"

      assert_select "input#exam_template_created_by[name=?]", "exam_template[created_by]"

      assert_select "input#exam_template_data[name=?]", "exam_template[data]"
    end
  end
end
