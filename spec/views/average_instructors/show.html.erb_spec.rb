require 'rails_helper'

RSpec.describe "staff/average_instructors/show", :type => :view do
  before(:each) do
    @staff = FactoryGirl.create(:basic_staff_with_rank)
    @average_instructor = assign(:average_instructor, AverageInstructor.create!(
      :programme_id => 1,
      :instructor_id => @staff.id,
      :evaluate_date => "2017-10-20",
      :start_at => "2017-10-20 08:55:00",
      :end_at => "2017-10-20 09:55:00",
      :title => "Title",
      :objective => "MyText",
      :delivery_type => 3,
      :pbq1 => 5,
      :pbq2 => 5,
      :pbq3 => 5,
      :pbq4 => 5,
      :pbq1review => "Pbq1review",
      :pbq2review => "Pbq2review",
      :pbq3review => "Pbq3review",
      :pbq4review => "Pbq4review",
      :pdq1 => 5,
      :pdq2 => 5,
      :pdq3 => 5,
      :pdq4 => 5,
      :pdq5 => 5,
      :pdq1review => "Pdq1review",
      :pdq2review => "Pdq2review",
      :pdq3review => "Pdq3review",
      :pdq4review => "Pdq4review",
      :pdq5review => "Pdq5review",
      :dq1 => 5,
      :dq2 => 5,
      :dq3 => 5,
      :dq4 => 5,
      :dq5 => 5,
      :dq6 => 5,
      :dq7 => 5,
      :dq8 => 5,
      :dq9 => 5,
      :dq10 => 5,
      :dq11 => 5,
      :dq12 => 5,
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
      :uq1 => 5,
      :uq2 => 5,
      :uq3 => 5,
      :uq4 => 5,
      :uq1review => "Uq1review",
      :uq2review => "Uq2review",
      :uq3review => "Uq3review",
      :uq4review => "Uq4review",
      :vq1 => 5,
      :vq2 => 5,
      :vq3 => 5,
      :vq4 => 5,
      :vq5 => 5,
      :vq1review => "Vq1review",
      :vq2review => "Vq2review",
      :vq3review => "Vq3review",
      :vq4review => "Vq4review",
      :vq5review => "Vq5review",
      :gttq1 => 5,
      :gttq2 => 5,
      :gttq3 => 5,
      :gttq4 => 5,
      :gttq5 => 5,
      :gttq6 => 5,
      :gttq7 => 5,
      :gttq8 => 5,
      :gttq9 => 5,
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
    assert_select "dl>dd", :text => "#{@staff.staff_with_rank}", :count => 1
    expect(rendered).to match(/20-10-2017/)
#     expect(rendered).to match(/2017-10-20 08:55:00/)
#     expect(rendered).to match(/2017-10-20 09:55:00/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
#     expect(rendered).to match(/3/)
    assert_select "dl>dd", :text => "#{@average_instructor.render_delivery}", :count => 1
    expect(rendered).to match(/Pbq1review/)
    expect(rendered).to match(/Pbq2review/)
    expect(rendered).to match(/Pbq3review/)
    expect(rendered).to match(/Pbq4review/)
    expect(rendered).to match(/Pdq1review/)
    expect(rendered).to match(/Pdq2review/)
    expect(rendered).to match(/Pdq3review/)
    expect(rendered).to match(/Pdq4review/)
    expect(rendered).to match(/Pdq5review/)
    expect(rendered).to match(/Dq1review/)
    expect(rendered).to match(/Dq2review/)
    expect(rendered).to match(/Dq3review/)
    expect(rendered).to match(/Dq4review/)
    expect(rendered).to match(/Dq5review/)
    expect(rendered).to match(/Dq6review/)
    expect(rendered).to match(/Dq7review/)
    expect(rendered).to match(/Dq8review/)
    expect(rendered).to match(/Dq9review/)
    expect(rendered).to match(/Dq10review/)
    expect(rendered).to match(/Dq11review/)
    expect(rendered).to match(/Dq12review/)
    expect(rendered).to match(/Uq1review/)
    expect(rendered).to match(/Uq2review/)
    expect(rendered).to match(/Uq3review/)
    expect(rendered).to match(/Uq4review/)
    expect(rendered).to match(/Vq1review/)
    expect(rendered).to match(/Vq2review/)
    expect(rendered).to match(/Vq3review/)
    expect(rendered).to match(/Vq4review/)
    expect(rendered).to match(/Vq5review/)
    expect(rendered).to match(/Gttq1review/)
    expect(rendered).to match(/Gttq2review/)
    expect(rendered).to match(/Gttq3review/)
    expect(rendered).to match(/Gttq4review/)
    expect(rendered).to match(/Gttq5review/)
    expect(rendered).to match(/Gttq6review/)
    expect(rendered).to match(/Gttq7review/)
    expect(rendered).to match(/Gttq8review/)
    expect(rendered).to match(/Gttq9review/)
    assert_select "td>p", :text => "5", :count => 39
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/45/)
  end
end
