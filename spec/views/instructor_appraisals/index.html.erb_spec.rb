require 'rails_helper'

RSpec.describe "staff/instructor_appraisals/index", :type => :view do
  before(:each) do
    assign(:instructor_appraisals, [
      InstructorAppraisal.create!(
        :staff_id => 1,
        :qc_sent => false,
        :appraisal_date => "2017-10-20",
        :q1 => 2,
        :q2 => 3,
        :q3 => 4,
        :q4 => 5,
        :q5 => 6,
        :q6 => 7,
        :q7 => 8,
        :q8 => 9,
        :q9 => 10,
        :q10 => 11,
        :q11 => 12,
        :q12 => 13,
        :q13 => 14,
        :q14 => 15,
        :q15 => 16,
        :q16 => 17,
        :q17 => 18,
        :q18 => 19,
        :q19 => 20,
        :q20 => 21,
        :q21 => 22,
        :q22 => 23,
        :q23 => 24,
        :q24 => 25,
        :q25 => 26,
        :q26 => 27,
        :q27 => 28,
        :q28 => 29,
        :q29 => 30,
        :q30 => 31,
        :q31 => 32,
        :q32 => 33,
        :q33 => 34,
        :q34 => 35,
        :q35 => 36,
        :q36 => 37,
        :q37 => 38,
        :q38 => 39,
        :q39 => 40,
        :q40 => 41,
        :q41 => 42,
        :q42 => 43,
        :q43 => 44,
        :q44 => 45,
        :q45 => 46,
        :q46 => 47,
        :q47 => 48,
        :q48 => 49,
        :total_mark => 50,
        :check_qc => 51,
        :checked => false
      ),
      InstructorAppraisal.create!(
        :staff_id => 1,
        :qc_sent => false,
        :appraisal_date => "2017-10-20",
        :q1 => 2,
        :q2 => 3,
        :q3 => 4,
        :q4 => 5,
        :q5 => 6,
        :q6 => 7,
        :q7 => 8,
        :q8 => 9,
        :q9 => 10,
        :q10 => 11,
        :q11 => 12,
        :q12 => 13,
        :q13 => 14,
        :q14 => 15,
        :q15 => 16,
        :q16 => 17,
        :q17 => 18,
        :q18 => 19,
        :q19 => 20,
        :q20 => 21,
        :q21 => 22,
        :q22 => 23,
        :q23 => 24,
        :q24 => 25,
        :q25 => 26,
        :q26 => 27,
        :q27 => 28,
        :q28 => 29,
        :q29 => 30,
        :q30 => 31,
        :q31 => 32,
        :q32 => 33,
        :q33 => 34,
        :q34 => 35,
        :q35 => 36,
        :q36 => 37,
        :q37 => 38,
        :q38 => 39,
        :q39 => 40,
        :q40 => 41,
        :q41 => 42,
        :q42 => 43,
        :q43 => 44,
        :q44 => 45,
        :q45 => 46,
        :q46 => 47,
        :q47 => 48,
        :q48 => 49,
        :total_mark => 50,
        :check_qc => 51,
        :checked => false
      )
    ])
  end

  it "renders a list of instructor_appraisals" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "2017-10-20", :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => 11.to_s, :count => 2
    assert_select "tr>td", :text => 12.to_s, :count => 2
    assert_select "tr>td", :text => 13.to_s, :count => 2
    assert_select "tr>td", :text => 14.to_s, :count => 2
    assert_select "tr>td", :text => 15.to_s, :count => 2
    assert_select "tr>td", :text => 16.to_s, :count => 2
    assert_select "tr>td", :text => 17.to_s, :count => 2
    assert_select "tr>td", :text => 18.to_s, :count => 2
    assert_select "tr>td", :text => 19.to_s, :count => 2
    assert_select "tr>td", :text => 20.to_s, :count => 2
    assert_select "tr>td", :text => 21.to_s, :count => 2
    assert_select "tr>td", :text => 22.to_s, :count => 2
    assert_select "tr>td", :text => 23.to_s, :count => 2
    assert_select "tr>td", :text => 24.to_s, :count => 2
    assert_select "tr>td", :text => 25.to_s, :count => 2
    assert_select "tr>td", :text => 26.to_s, :count => 2
    assert_select "tr>td", :text => 27.to_s, :count => 2
    assert_select "tr>td", :text => 28.to_s, :count => 2
    assert_select "tr>td", :text => 29.to_s, :count => 2
    assert_select "tr>td", :text => 30.to_s, :count => 2
    assert_select "tr>td", :text => 31.to_s, :count => 2
    assert_select "tr>td", :text => 32.to_s, :count => 2
    assert_select "tr>td", :text => 33.to_s, :count => 2
    assert_select "tr>td", :text => 34.to_s, :count => 2
    assert_select "tr>td", :text => 35.to_s, :count => 2
    assert_select "tr>td", :text => 36.to_s, :count => 2
    assert_select "tr>td", :text => 37.to_s, :count => 2
    assert_select "tr>td", :text => 38.to_s, :count => 2
    assert_select "tr>td", :text => 39.to_s, :count => 2
    assert_select "tr>td", :text => 40.to_s, :count => 2
    assert_select "tr>td", :text => 41.to_s, :count => 2
    assert_select "tr>td", :text => 42.to_s, :count => 2
    assert_select "tr>td", :text => 43.to_s, :count => 2
    assert_select "tr>td", :text => 44.to_s, :count => 2
    assert_select "tr>td", :text => 45.to_s, :count => 2
    assert_select "tr>td", :text => 46.to_s, :count => 2
    assert_select "tr>td", :text => 47.to_s, :count => 2
    assert_select "tr>td", :text => 48.to_s, :count => 2
    assert_select "tr>td", :text => 49.to_s, :count => 2
    assert_select "tr>td", :text => 50.to_s, :count => 2
    assert_select "tr>td", :text => 51.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
