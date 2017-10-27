require 'rails_helper'

RSpec.describe "staff/average_instructors/new", :type => :view do
  before(:each) do
    assign(:average_instructor, AverageInstructor.new(
      :programme_id => 1,
      :instructor_id => 1,
      :title => "MyString",
      :objective => "MyText",
      :delivery_type => 1,
      :pbq1 => 1,
      :pbq2 => 1,
      :pbq3 => 1,
      :pbq4 => 1,
      :pbq1review => "MyString",
      :pbq2review => "MyString",
      :pbq3review => "MyString",
      :pbq4review => "MyString",
      :pdq1 => 1,
      :pdq2 => 1,
      :pdq3 => 1,
      :pdq4 => 1,
      :pdq5 => 1,
      :pdq1review => "MyString",
      :pdq2review => "",
      :pdq3review => 1,
      :pdq4review => 1,
      :pdq5review => "MyString",
      :dq1 => 1,
      :dq2 => 1,
      :dq3 => 1,
      :dq4 => 1,
      :dq5 => 1,
      :dq6 => 1,
      :dq7 => 1,
      :dq8 => 1,
      :dq9 => 1,
      :dq10 => 1,
      :dq11 => 1,
      :dq12 => 1,
      :dq1review => "MyString",
      :dq2review => "MyString",
      :dq3review => "MyString",
      :dq4review => "MyString",
      :dq5review => "MyString",
      :dq6review => "MyString",
      :dq7review => "MyString",
      :dq8review => "MyString",
      :dq9review => "MyString",
      :dq10review => "MyString",
      :dq11review => "MyString",
      :dq12review => "MyString",
      :uq1 => 1,
      :uq2 => 1,
      :uq3 => 1,
      :uq4 => 1,
      :uq1review => "MyString",
      :uq2review => "MyString",
      :uq3review => "MyString",
      :uq4review => "MyString",
      :vq1 => 1,
      :vq2 => 1,
      :vq3 => 1,
      :vq4 => 1,
      :vq5 => 1,
      :vq1review => "MyString",
      :vq2review => "MyString",
      :vq3review => "MyString",
      :vq4review => "MyString",
      :vq5review => "MyString",
      :gttq1 => 1,
      :gttq2 => 1,
      :gttq3 => 1,
      :gttq4 => 1,
      :gttq5 => 1,
      :gttq6 => 1,
      :gttq7 => 1,
      :gttq8 => 1,
      :gttq9 => 1,
      :gttq1review => "MyString",
      :gttq2review => "MyString",
      :gttq3review => "MyString",
      :gttq4review => "MyString",
      :gttq5review => "MyString",
      :gttq6review => "MyString",
      :gttq7review => "MyString",
      :gttq8review => "MyString",
      :gttq9review => "MyString",
      :review => "MyText",
      :evaluator_id => 1
    ))
  end

  it "renders new average_instructor form" do
    render

    assert_select "form[action=?][method=?]", average_instructors_path, "post" do

      assert_select "input#average_instructor_programme_id[name=?]", "average_instructor[programme_id]"

      assert_select "input#average_instructor_instructor_id[name=?]", "average_instructor[instructor_id]"

      assert_select "input#average_instructor_title[name=?]", "average_instructor[title]"

      assert_select "textarea#average_instructor_objective[name=?]", "average_instructor[objective]"

      assert_select "input#average_instructor_delivery_type[name=?]", "average_instructor[delivery_type]"

      assert_select "input#average_instructor_pbq1[name=?]", "average_instructor[pbq1]"

      assert_select "input#average_instructor_pbq2[name=?]", "average_instructor[pbq2]"

      assert_select "input#average_instructor_pbq3[name=?]", "average_instructor[pbq3]"

      assert_select "input#average_instructor_pbq4[name=?]", "average_instructor[pbq4]"

      assert_select "input#average_instructor_pbq1review[name=?]", "average_instructor[pbq1review]"

      assert_select "input#average_instructor_pbq2review[name=?]", "average_instructor[pbq2review]"

      assert_select "input#average_instructor_pbq3review[name=?]", "average_instructor[pbq3review]"

      assert_select "input#average_instructor_pbq4review[name=?]", "average_instructor[pbq4review]"

      assert_select "input#average_instructor_pdq1[name=?]", "average_instructor[pdq1]"

      assert_select "input#average_instructor_pdq2[name=?]", "average_instructor[pdq2]"

      assert_select "input#average_instructor_pdq3[name=?]", "average_instructor[pdq3]"

      assert_select "input#average_instructor_pdq4[name=?]", "average_instructor[pdq4]"

      assert_select "input#average_instructor_pdq5[name=?]", "average_instructor[pdq5]"

      assert_select "input#average_instructor_pdq1review[name=?]", "average_instructor[pdq1review]"

      assert_select "input#average_instructor_pdq2review[name=?]", "average_instructor[pdq2review]"

      assert_select "input#average_instructor_pdq3review[name=?]", "average_instructor[pdq3review]"

      assert_select "input#average_instructor_pdq4review[name=?]", "average_instructor[pdq4review]"

      assert_select "input#average_instructor_pdq5review[name=?]", "average_instructor[pdq5review]"

      assert_select "input#average_instructor_dq1[name=?]", "average_instructor[dq1]"

      assert_select "input#average_instructor_dq2[name=?]", "average_instructor[dq2]"

      assert_select "input#average_instructor_dq3[name=?]", "average_instructor[dq3]"

      assert_select "input#average_instructor_dq4[name=?]", "average_instructor[dq4]"

      assert_select "input#average_instructor_dq5[name=?]", "average_instructor[dq5]"

      assert_select "input#average_instructor_dq6[name=?]", "average_instructor[dq6]"

      assert_select "input#average_instructor_dq7[name=?]", "average_instructor[dq7]"

      assert_select "input#average_instructor_dq8[name=?]", "average_instructor[dq8]"

      assert_select "input#average_instructor_dq9[name=?]", "average_instructor[dq9]"

      assert_select "input#average_instructor_dq10[name=?]", "average_instructor[dq10]"

      assert_select "input#average_instructor_dq11[name=?]", "average_instructor[dq11]"

      assert_select "input#average_instructor_dq12[name=?]", "average_instructor[dq12]"

      assert_select "input#average_instructor_dq1review[name=?]", "average_instructor[dq1review]"

      assert_select "input#average_instructor_dq2review[name=?]", "average_instructor[dq2review]"

      assert_select "input#average_instructor_dq3review[name=?]", "average_instructor[dq3review]"

      assert_select "input#average_instructor_dq4review[name=?]", "average_instructor[dq4review]"

      assert_select "input#average_instructor_dq5review[name=?]", "average_instructor[dq5review]"

      assert_select "input#average_instructor_dq6review[name=?]", "average_instructor[dq6review]"

      assert_select "input#average_instructor_dq7review[name=?]", "average_instructor[dq7review]"

      assert_select "input#average_instructor_dq8review[name=?]", "average_instructor[dq8review]"

      assert_select "input#average_instructor_dq9review[name=?]", "average_instructor[dq9review]"

      assert_select "input#average_instructor_dq10review[name=?]", "average_instructor[dq10review]"

      assert_select "input#average_instructor_dq11review[name=?]", "average_instructor[dq11review]"

      assert_select "input#average_instructor_dq12review[name=?]", "average_instructor[dq12review]"

      assert_select "input#average_instructor_uq1[name=?]", "average_instructor[uq1]"

      assert_select "input#average_instructor_uq2[name=?]", "average_instructor[uq2]"

      assert_select "input#average_instructor_uq3[name=?]", "average_instructor[uq3]"

      assert_select "input#average_instructor_uq4[name=?]", "average_instructor[uq4]"

      assert_select "input#average_instructor_uq1review[name=?]", "average_instructor[uq1review]"

      assert_select "input#average_instructor_uq2review[name=?]", "average_instructor[uq2review]"

      assert_select "input#average_instructor_uq3review[name=?]", "average_instructor[uq3review]"

      assert_select "input#average_instructor_uq4review[name=?]", "average_instructor[uq4review]"

      assert_select "input#average_instructor_vq1[name=?]", "average_instructor[vq1]"

      assert_select "input#average_instructor_vq2[name=?]", "average_instructor[vq2]"

      assert_select "input#average_instructor_vq3[name=?]", "average_instructor[vq3]"

      assert_select "input#average_instructor_vq4[name=?]", "average_instructor[vq4]"

      assert_select "input#average_instructor_vq5[name=?]", "average_instructor[vq5]"

      assert_select "input#average_instructor_vq1review[name=?]", "average_instructor[vq1review]"

      assert_select "input#average_instructor_vq2review[name=?]", "average_instructor[vq2review]"

      assert_select "input#average_instructor_vq3review[name=?]", "average_instructor[vq3review]"

      assert_select "input#average_instructor_vq4review[name=?]", "average_instructor[vq4review]"

      assert_select "input#average_instructor_vq5review[name=?]", "average_instructor[vq5review]"

      assert_select "input#average_instructor_gttq1[name=?]", "average_instructor[gttq1]"

      assert_select "input#average_instructor_gttq2[name=?]", "average_instructor[gttq2]"

      assert_select "input#average_instructor_gttq3[name=?]", "average_instructor[gttq3]"

      assert_select "input#average_instructor_gttq4[name=?]", "average_instructor[gttq4]"

      assert_select "input#average_instructor_gttq5[name=?]", "average_instructor[gttq5]"

      assert_select "input#average_instructor_gttq6[name=?]", "average_instructor[gttq6]"

      assert_select "input#average_instructor_gttq7[name=?]", "average_instructor[gttq7]"

      assert_select "input#average_instructor_gttq8[name=?]", "average_instructor[gttq8]"

      assert_select "input#average_instructor_gttq9[name=?]", "average_instructor[gttq9]"

      assert_select "input#average_instructor_gttq1review[name=?]", "average_instructor[gttq1review]"

      assert_select "input#average_instructor_gttq2review[name=?]", "average_instructor[gttq2review]"

      assert_select "input#average_instructor_gttq3review[name=?]", "average_instructor[gttq3review]"

      assert_select "input#average_instructor_gttq4review[name=?]", "average_instructor[gttq4review]"

      assert_select "input#average_instructor_gttq5review[name=?]", "average_instructor[gttq5review]"

      assert_select "input#average_instructor_gttq6review[name=?]", "average_instructor[gttq6review]"

      assert_select "input#average_instructor_gttq7review[name=?]", "average_instructor[gttq7review]"

      assert_select "input#average_instructor_gttq8review[name=?]", "average_instructor[gttq8review]"

      assert_select "input#average_instructor_gttq9review[name=?]", "average_instructor[gttq9review]"

      assert_select "textarea#average_instructor_review[name=?]", "average_instructor[review]"

      assert_select "input#average_instructor_evaluator_id[name=?]", "average_instructor[evaluator_id]"
    end
  end
end
