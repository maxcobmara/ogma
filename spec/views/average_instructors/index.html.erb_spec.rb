require 'rails_helper'

RSpec.describe "staff/average_instructors/index", :type => :view do
  before(:each) do
    assign(:average_instructors, [
      AverageInstructor.create!(
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
        :dq9review => "Dq9review",
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
      ),
      AverageInstructor.create!(
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
        :dq9review => "Dq9review",
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
      )
    ])
  end

  it "renders a list of average_instructors" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => "Pbq1review".to_s, :count => 2
    assert_select "tr>td", :text => "Pbq2review".to_s, :count => 2
    assert_select "tr>td", :text => "Pbq3review".to_s, :count => 2
    assert_select "tr>td", :text => "Pbq4review".to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => 11.to_s, :count => 2
    assert_select "tr>td", :text => 12.to_s, :count => 2
    assert_select "tr>td", :text => "Pdq1review".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 13.to_s, :count => 2
    assert_select "tr>td", :text => 14.to_s, :count => 2
    assert_select "tr>td", :text => "Pdq5review".to_s, :count => 2
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
    assert_select "tr>td", :text => "Dq1review".to_s, :count => 2
    assert_select "tr>td", :text => "Dq2review".to_s, :count => 2
    assert_select "tr>td", :text => "Dq3review".to_s, :count => 2
    assert_select "tr>td", :text => "Dq4review".to_s, :count => 2
    assert_select "tr>td", :text => "Dq5review".to_s, :count => 2
    assert_select "tr>td", :text => "Dq6review".to_s, :count => 2
    assert_select "tr>td", :text => "Dq7review".to_s, :count => 2
    assert_select "tr>td", :text => "Dq8review".to_s, :count => 2
    assert_select "tr>td", :text => "Dq9review".to_s, :count => 2
    assert_select "tr>td", :text => "Dq10review".to_s, :count => 2
    assert_select "tr>td", :text => "Dq11review".to_s, :count => 2
    assert_select "tr>td", :text => "Dq12review".to_s, :count => 2
    assert_select "tr>td", :text => 27.to_s, :count => 2
    assert_select "tr>td", :text => 28.to_s, :count => 2
    assert_select "tr>td", :text => 29.to_s, :count => 2
    assert_select "tr>td", :text => 30.to_s, :count => 2
    assert_select "tr>td", :text => "Uq1review".to_s, :count => 2
    assert_select "tr>td", :text => "Uq2review".to_s, :count => 2
    assert_select "tr>td", :text => "Uq3review".to_s, :count => 2
    assert_select "tr>td", :text => "Uq4review".to_s, :count => 2
    assert_select "tr>td", :text => 31.to_s, :count => 2
    assert_select "tr>td", :text => 32.to_s, :count => 2
    assert_select "tr>td", :text => 33.to_s, :count => 2
    assert_select "tr>td", :text => 34.to_s, :count => 2
    assert_select "tr>td", :text => 35.to_s, :count => 2
    assert_select "tr>td", :text => "Vq1review".to_s, :count => 2
    assert_select "tr>td", :text => "Vq2review".to_s, :count => 2
    assert_select "tr>td", :text => "Vq3review".to_s, :count => 2
    assert_select "tr>td", :text => "Vq4review".to_s, :count => 2
    assert_select "tr>td", :text => "Vq5review".to_s, :count => 2
    assert_select "tr>td", :text => 36.to_s, :count => 2
    assert_select "tr>td", :text => 37.to_s, :count => 2
    assert_select "tr>td", :text => 38.to_s, :count => 2
    assert_select "tr>td", :text => 39.to_s, :count => 2
    assert_select "tr>td", :text => 40.to_s, :count => 2
    assert_select "tr>td", :text => 41.to_s, :count => 2
    assert_select "tr>td", :text => 42.to_s, :count => 2
    assert_select "tr>td", :text => 43.to_s, :count => 2
    assert_select "tr>td", :text => 44.to_s, :count => 2
    assert_select "tr>td", :text => "Gttq1review".to_s, :count => 2
    assert_select "tr>td", :text => "Gttq2review".to_s, :count => 2
    assert_select "tr>td", :text => "Gttq3review".to_s, :count => 2
    assert_select "tr>td", :text => "Gttq4review".to_s, :count => 2
    assert_select "tr>td", :text => "Gttq5review".to_s, :count => 2
    assert_select "tr>td", :text => "Gttq6review".to_s, :count => 2
    assert_select "tr>td", :text => "Gttq7review".to_s, :count => 2
    assert_select "tr>td", :text => "Gttq8review".to_s, :count => 2
    assert_select "tr>td", :text => "Gttq9review".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 45.to_s, :count => 2
  end
end
