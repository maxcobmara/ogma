
EvaluateCourse.create!({
  course_id: 5,
  subject_id: 74,
  staff_id: 86,
  student_id: nil,
  evaluate_date: "2014-12-11",
  comment: "test",
  ev_obj: rand(1..9),
  ev_knowledge: rand(1..9),
  ev_deliver: rand(1..9),
  ev_content: rand(1..9),
  ev_tool: rand(1..9),
  ev_topic: rand(1..9),
   ev_work: rand(1..9),
   ev_note: rand(1..9),
   ev_assessment: rand(1..9),
   invite_lec: "okok",
   average_course_id: nil,
   created_at: "2014-11-24 04:48:08",
   updated_at: "2014-12-11 13:09:10",
   invite_lec_topic: nil
  })


(Time.now.year - 12 .. Time.now.year).each do | y |
  ["01", "03", "07", "09"].each do | m |
    d = format('%02d',  rand(1..7))
    init_date = (y.to_s + m + d).to_date

    Intake.create!({
      name: init.strftime("%b %Y"),
      description: "23",
      register_on: init_date,
      programme_id: 11,
      is_active: true,
      monthyear_intake: init_date,
      staff_id: nil
    }
  end
end

Student.all.sample(rand(5..999))
  init_date = Faker::Date.birthday(0, 12)
  hol_date  = init_date + rand(7..21).days
  duration  = rand(1..7)
  submitted = [true, false].sample
  approve   = submitted == true ? [true, false].sample : false
  approve_d = submitted == true ? init_date + rand(0..14).days : nil
  Leaveforstudent.create!({
    student_id: 2189,
    leavetype: DropDown::STUDENTLEAVETYPE.sample[1],
    requestdate: init_date,
    reason: "",
    address: Faker::Address.street_address,
    telno: Faker::PhoneNumber.phone_number,
    leave_startdate: hol_date,
    leave_enddate: hol_date + duration.days,
    studentsubmit: submitted,
    approved: approve,
    staff_id: nil,
    approvedate: approve_d,
    notes: nil,
    approved2: true,
    staff_id2: 103,
    approvedate2: approve_d + rand(0..7).days
  })
end
