require 'rails_helper'

RSpec.describe "staff/instructor_appraisals/edit", :type => :view do
  before  { @instructor_appraisal = FactoryGirl.create(:instructor_appraisal) }
  
  before(:each) do
    @instructor_appraisal = assign(:instructor_appraisal, InstructorAppraisal.create!(
      :staff_id => 1,
      :qc_sent => false,
      :appraisal_date => "2017-10-20",
      :q1 => 1,
      :q2 => 1,
      :q3 => 1,
      :q4 => 1,
      :q5 => 1,
      :q6 => 1,
      :q7 => 1,
      :q8 => 1,
      :q9 => 1,
      :q10 => 1,
      :q11 => 1,
      :q12 => 1,
      :q13 => 1,
      :q14 => 1,
      :q15 => 1,
      :q16 => 1,
      :q17 => 1,
      :q18 => 1,
      :q19 => 1,
      :q20 => 1,
      :q21 => 1,
      :q22 => 1,
      :q23 => 1,
      :q24 => 1,
      :q25 => 1,
      :q26 => 1,
      :q27 => 1,
      :q28 => 1,
      :q29 => 1,
      :q30 => 1,
      :q31 => 1,
      :q32 => 1,
      :q33 => 1,
      :q34 => 1,
      :q35 => 1,
      :q36 => 1,
      :q37 => 1,
      :q38 => 1,
      :q39 => 1,
      :q40 => 1,
      :q41 => 1,
      :q42 => 1,
      :q43 => 1,
      :q44 => 1,
      :q45 => 1,
      :q46 => 1,
      :q47 => 1,
      :q48 => 1,
      :total_mark => 1,
      :check_qc => 1,
      :checked => false
    ))
  end

  it "renders the edit instructor_appraisal form" do
    render

    assert_select "form[action=?][method=?]", instructor_appraisal_path(@instructor_appraisal), "post" do

      assert_select "input#instructor_appraisal_staff_id[name=?]", "instructor_appraisal[staff_id]"

      assert_select "input#instructor_appraisal_qc_sent[name=?]", "instructor_appraisal[qc_sent]"
      
      assert_select "input#instructor_appraisal_appraisal_date[name=?]", "instructor_appraisal[appraisal_date]"

      assert_select "input#instructor_appraisal_q1[name=?]", "instructor_appraisal[q1]"

      assert_select "input#instructor_appraisal_q2[name=?]", "instructor_appraisal[q2]"

      assert_select "input#instructor_appraisal_q3[name=?]", "instructor_appraisal[q3]"

      assert_select "input#instructor_appraisal_q4[name=?]", "instructor_appraisal[q4]"

      assert_select "input#instructor_appraisal_q5[name=?]", "instructor_appraisal[q5]"

      assert_select "input#instructor_appraisal_q6[name=?]", "instructor_appraisal[q6]"

      assert_select "input#instructor_appraisal_q7[name=?]", "instructor_appraisal[q7]"

      assert_select "input#instructor_appraisal_q8[name=?]", "instructor_appraisal[q8]"

      assert_select "input#instructor_appraisal_q9[name=?]", "instructor_appraisal[q9]"

      assert_select "input#instructor_appraisal_q10[name=?]", "instructor_appraisal[q10]"

      assert_select "input#instructor_appraisal_q11[name=?]", "instructor_appraisal[q11]"

      assert_select "input#instructor_appraisal_q12[name=?]", "instructor_appraisal[q12]"

      assert_select "input#instructor_appraisal_q13[name=?]", "instructor_appraisal[q13]"

      assert_select "input#instructor_appraisal_q14[name=?]", "instructor_appraisal[q14]"

      assert_select "input#instructor_appraisal_q15[name=?]", "instructor_appraisal[q15]"

      assert_select "input#instructor_appraisal_q16[name=?]", "instructor_appraisal[q16]"

      assert_select "input#instructor_appraisal_q17[name=?]", "instructor_appraisal[q17]"

      assert_select "input#instructor_appraisal_q18[name=?]", "instructor_appraisal[q18]"

      assert_select "input#instructor_appraisal_q19[name=?]", "instructor_appraisal[q19]"

      assert_select "input#instructor_appraisal_q20[name=?]", "instructor_appraisal[q20]"

      assert_select "input#instructor_appraisal_q21[name=?]", "instructor_appraisal[q21]"

      assert_select "input#instructor_appraisal_q22[name=?]", "instructor_appraisal[q22]"

      assert_select "input#instructor_appraisal_q23[name=?]", "instructor_appraisal[q23]"

      assert_select "input#instructor_appraisal_q24[name=?]", "instructor_appraisal[q24]"

      assert_select "input#instructor_appraisal_q25[name=?]", "instructor_appraisal[q25]"

      assert_select "input#instructor_appraisal_q26[name=?]", "instructor_appraisal[q26]"

      assert_select "input#instructor_appraisal_q27[name=?]", "instructor_appraisal[q27]"

      assert_select "input#instructor_appraisal_q28[name=?]", "instructor_appraisal[q28]"

      assert_select "input#instructor_appraisal_q29[name=?]", "instructor_appraisal[q29]"

      assert_select "input#instructor_appraisal_q30[name=?]", "instructor_appraisal[q30]"

      assert_select "input#instructor_appraisal_q31[name=?]", "instructor_appraisal[q31]"

      assert_select "input#instructor_appraisal_q32[name=?]", "instructor_appraisal[q32]"

      assert_select "input#instructor_appraisal_q33[name=?]", "instructor_appraisal[q33]"

      assert_select "input#instructor_appraisal_q34[name=?]", "instructor_appraisal[q34]"

      assert_select "input#instructor_appraisal_q35[name=?]", "instructor_appraisal[q35]"

      assert_select "input#instructor_appraisal_q36[name=?]", "instructor_appraisal[q36]"

      assert_select "input#instructor_appraisal_q37[name=?]", "instructor_appraisal[q37]"

      assert_select "input#instructor_appraisal_q38[name=?]", "instructor_appraisal[q38]"

      assert_select "input#instructor_appraisal_q39[name=?]", "instructor_appraisal[q39]"

      assert_select "input#instructor_appraisal_q40[name=?]", "instructor_appraisal[q40]"

      assert_select "input#instructor_appraisal_q41[name=?]", "instructor_appraisal[q41]"

      assert_select "input#instructor_appraisal_q42[name=?]", "instructor_appraisal[q42]"

      assert_select "input#instructor_appraisal_q43[name=?]", "instructor_appraisal[q43]"

      assert_select "input#instructor_appraisal_q44[name=?]", "instructor_appraisal[q44]"

      assert_select "input#instructor_appraisal_q45[name=?]", "instructor_appraisal[q45]"

      assert_select "input#instructor_appraisal_q46[name=?]", "instructor_appraisal[q46]"

      assert_select "input#instructor_appraisal_q47[name=?]", "instructor_appraisal[q47]"

      assert_select "input#instructor_appraisal_q48[name=?]", "instructor_appraisal[q48]"

      assert_select "input#instructor_appraisal_total_mark[name=?]", "instructor_appraisal[total_mark]"

      assert_select "input#instructor_appraisal_check_qc[name=?]", "instructor_appraisal[check_qc]"

      assert_select "input#instructor_appraisal_checked[name=?]", "instructor_appraisal[checked]"
    end
  end
end
