require 'rails_helper'

RSpec.describe "staff/instructor_appraisals/show", :type => :view do
  before(:each) do
    @instructor_appraisal = assign(:instructor_appraisal, InstructorAppraisal.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/2017-10-20/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/9/)
    expect(rendered).to match(/10/)
    expect(rendered).to match(/11/)
    expect(rendered).to match(/12/)
    expect(rendered).to match(/13/)
    expect(rendered).to match(/14/)
    expect(rendered).to match(/15/)
    expect(rendered).to match(/16/)
    expect(rendered).to match(/17/)
    expect(rendered).to match(/18/)
    expect(rendered).to match(/19/)
    expect(rendered).to match(/20/)
    expect(rendered).to match(/21/)
    expect(rendered).to match(/22/)
    expect(rendered).to match(/23/)
    expect(rendered).to match(/24/)
    expect(rendered).to match(/25/)
    expect(rendered).to match(/26/)
    expect(rendered).to match(/27/)
    expect(rendered).to match(/28/)
    expect(rendered).to match(/29/)
    expect(rendered).to match(/30/)
    expect(rendered).to match(/31/)
    expect(rendered).to match(/32/)
    expect(rendered).to match(/33/)
    expect(rendered).to match(/34/)
    expect(rendered).to match(/35/)
    expect(rendered).to match(/36/)
    expect(rendered).to match(/37/)
    expect(rendered).to match(/38/)
    expect(rendered).to match(/39/)
    expect(rendered).to match(/40/)
    expect(rendered).to match(/41/)
    expect(rendered).to match(/42/)
    expect(rendered).to match(/43/)
    expect(rendered).to match(/44/)
    expect(rendered).to match(/45/)
    expect(rendered).to match(/46/)
    expect(rendered).to match(/47/)
    expect(rendered).to match(/48/)
    expect(rendered).to match(/49/)
    expect(rendered).to match(/50/)
    expect(rendered).to match(/51/)
    expect(rendered).to match(/false/)
  end
end
