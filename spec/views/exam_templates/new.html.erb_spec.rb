require 'rails_helper'

RSpec.describe "exam_templates/new", :type => :view do
  before(:each) do
    assign(:exam_template, ExamTemplate.new(
      :name => "",
      :created_by => "",
      :data => ""
    ))
  end

  it "renders new exam_template form" do
    render

    assert_select "form[action=?][method=?]", exam_templates_path, "post" do

      assert_select "input#exam_template_name[name=?]", "exam_template[name]"

      assert_select "input#exam_template_created_by[name=?]", "exam_template[created_by]"

      assert_select "input#exam_template_data[name=?]", "exam_template[data]"
    end
  end
end
