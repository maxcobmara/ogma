
puts "Creating Students"
rand(1000.2000).times do
  gender = DropDown::GENDER.sample[1]
  fname  =  gender[0] == "Female"? Faker::Name.female_first_name : Faker::Name.male_first_name
  dob    = Faker::Date.birthday(17, 35)
  intake = Intake.all.sample
  Student.create!({
      icno: dob.strftime("%Y%m%d") + Faker::Number.leading_zero_number(6),
      name: fname + Faker::Name.last_name,
      matrixno: "PB 2/2012-0515",
      sstatus: Student::STATUS.sample[1],
      stelno: Faker::PhoneNumber.cell_phone,
      ssponsor: Student::SPONSOR.sample[1],
      gender: gender[1],
      sbirthdt: dob,
      mrtlstatuscd: Student::MARITAL_STATUS.sample[1],
      semail: fname + Faker::Number.leading_zero_number(3) + "domain.com",
      regdate: Faker::Date.birthday(0, 12),
      course_id: Programme.all.sample,
      specilisation: nil,
      group_id: 2,
      physical: "",
      allergy: "nil",
      disease: "nil",
      bloodtype: DropDown::BLOOD_TYPE.sample[1],
      medication: "",
      remarks: "",
      offer_letter_serial: "",
      race: DropDown::RACE.sample[0],
      photo_file_name: nil,
      photo_content_type: nil,
      photo_file_size: nil,
      photo_updated_at: nil,
      address: "#{Faker::Address.secondary_address}, #{Faker::Address.street_address},\r\n#{Faker::Address.postcode} #{Faker::Address.community},\r\n#{Faker::Address.city},\r\n#{Faker::Address.country}.",
      address_posbasik: "Hospital #{Faker::Address.community},\r\n#{Faker::Address.postcode}#{Faker::Address.city},\r\n#{Faker::Address.country}.",
      end_training: Intake.register_on + 18.months,
      intake: Intake.register_on,
      specialisation: nil,
      intake_id: intake.id,
      course_remarks: nil,
      race2: DropDown::RACE.sample[0],
      sstatus_remark: nil
  })
end


puts "Creating Student Course Evaluations"
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

puts "Creating Student Intakes"
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

puts "Creating Student Leave Applications"
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
