require 'rails_helper'

RSpec.describe "average_instructors/show", :type => :view do
  before(:each) do
    @average_instructor = assign(:average_instructor, AverageInstructor.create!(
      :programme_id => 1,
      :instructor_id => 2,
      :title => "Title",
      :objective => "MyText",
      :delivery_type => 3,
      :pbq1 => 4,
      :pbq2 => 5,
      :pbq3 => 6,
      :pbq4 => 7,
      :pbq1review => "Pbq1review",
      :pbq2review => "Pbq2review",
      :pbq3review => "Pbq3review",
      :pbq4review => "Pbq4review",
      :pdq1 => 8,
      :pdq2 => 9,
      :pdq3 => 10,
      :pdq4 => 11,
      :pdq5 => 12,
      :pdq1review => "Pdq1review",
      :pdq2review => "",
      :pdq3review => 13,
      :pdq4review => 14,
      :pdq5review => "Pdq5review",
      :dq1 => 15,
      :dq2 => 16,
      :dq3 => 17,
      :dq4 => 18,
      :dq5 => 19,
      :dq6 => 20,
      :dq7 => 21,
      :dq8 => 22,
      :dq9 => 23,
      :dq10 => 24,
      :dq11 => 25,
      :dq12 => 26,
      :dq1review => "Dq1review",
      :dq2review => "Dq2review",
      :dq3review => "Dq3review",
      :dq4review => "Dq4review",
      :dq5review => "Dq5review",
      :dq6review => "Dq6review",
      :dq7review => "Dq7review",
      :dq8review => "Dq8review",
      :dq9reiew => "Dq9reiew",
      :dq10review => "Dq10review",
      :dq11review => "Dq11review",
      :dq12review => "Dq12review",
      :uq1 => 27,
      :uq2 => 28,
      :uq3 => 29,
      :uq4 => 30,
      :uq1review => "Uq1review",
      :uq2review => "Uq2review",
      :uq3review => "Uq3review",
      :uq4review => "Uq4review",
      :vq1 => 31,
      :vq2 => 32,
      :vq3 => 33,
      :vq4 => 34,
      :vq5 => 35,
      :vq1review => "Vq1review",
      :vq2review => "Vq2review",
      :vq3review => "Vq3review",
      :vq4review => "Vq4review",
      :vq5review => "Vq5review",
      :gttq1 => 36,
      :gttq2 => 37,
      :gttq3 => 38,
      :gttq4 => 39,
      :gttq5 => 40,
      :gttq6 => 41,
      :gttq7 => 42,
      :gttq8 => 43,
      :gttq9 => 44,
      :gttq1review => "Gttq1review",
      :gttq2review => "Gttq2review",
      :gttq3review => "Gttq3review",
      :gttq4review => "Gttq4review",
      :gttq5review => "Gttq5review",
      :gttq6review => "Gttq6review",
      :gttq7review => "Gttq7review",
      :gttq8review => "Gttq8review",
      :gttq9review => "Gttq9review",
      :review => "MyText",
      :evaluator_id => 45
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/Pbq1review/)
    expect(rendered).to match(/Pbq2review/)
    expect(rendered).to match(/Pbq3review/)
    expect(rendered).to match(/Pbq4review/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/9/)
    expect(rendered).to match(/10/)
    expect(rendered).to match(/11/)
    expect(rendered).to match(/12/)
    expect(rendered).to match(/Pdq1review/)
    expect(rendered).to match(//)
    expect(rendered).to match(/13/)
    expect(rendered).to match(/14/)
    expect(rendered).to match(/Pdq5review/)
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
    expect(rendered).to match(/Dq1review/)
    expect(rendered).to match(/Dq2review/)
    expect(rendered).to match(/Dq3review/)
    expect(rendered).to match(/Dq4review/)
    expect(rendered).to match(/Dq5review/)
    expect(rendered).to match(/Dq6review/)
    expect(rendered).to match(/Dq7review/)
    expect(rendered).to match(/Dq8review/)
    expect(rendered).to match(/Dq9reiew/)
    expect(rendered).to match(/Dq10review/)
    expect(rendered).to match(/Dq11review/)
    expect(rendered).to match(/Dq12review/)
    expect(rendered).to match(/27/)
    expect(rendered).to match(/28/)
    expect(rendered).to match(/29/)
    expect(rendered).to match(/30/)
    expect(rendered).to match(/Uq1review/)
    expect(rendered).to match(/Uq2review/)
    expect(rendered).to match(/Uq3review/)
    expect(rendered).to match(/Uq4review/)
    expect(rendered).to match(/31/)
    expect(rendered).to match(/32/)
    expect(rendered).to match(/33/)
    expect(rendered).to match(/34/)
    expect(rendered).to match(/35/)
    expect(rendered).to match(/Vq1review/)
    expect(rendered).to match(/Vq2review/)
    expect(rendered).to match(/Vq3review/)
    expect(rendered).to match(/Vq4review/)
    expect(rendered).to match(/Vq5review/)
    expect(rendered).to match(/36/)
    expect(rendered).to match(/37/)
    expect(rendered).to match(/38/)
    expect(rendered).to match(/39/)
    expect(rendered).to match(/40/)
    expect(rendered).to match(/41/)
    expect(rendered).to match(/42/)
    expect(rendered).to match(/43/)
    expect(rendered).to match(/44/)
    expect(rendered).to match(/Gttq1review/)
    expect(rendered).to match(/Gttq2review/)
    expect(rendered).to match(/Gttq3review/)
    expect(rendered).to match(/Gttq4review/)
    expect(rendered).to match(/Gttq5review/)
    expect(rendered).to match(/Gttq6review/)
    expect(rendered).to match(/Gttq7review/)
    expect(rendered).to match(/Gttq8review/)
    expect(rendered).to match(/Gttq9review/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/45/)
  end
end
