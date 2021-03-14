puts "Creating Exams"
100.times do
  init_date   = Faker::Time.between(2.years.ago, Date.today, :all)
  duration    = multiple5.sample
  event_date  = init_date + rand(7..21).days
  Exam.create!({
    name: DropDown::EXAMTYPE.sample[1],
    description: "49", #@final_exams
    created_by: 104,
    course_id: nil,
    subject_id: 28,
    klass_id: 0,
    exam_on: init_date.to_date,
    duration: duration,
    full_marks: rand(10..100).sample,
    starttime: init_date,
    endtime: init_date + duration.minutes,
    topic_id: 4,
    sequ: nil
  })
end

puts "Creating Exam Analysis"
Exam.each do | exam |
  Examanalysis.create!({
    exam_id: exam.id,
    gradeA:       rand(0..99),
    gradeAminus:  rand(0..99),
    gradeBplus:   rand(0..99),
    gradeB:       rand(0..99),
    gradeBminus:  rand(0..99),
    gradeCplus:   rand(0..99),
    gradeC:       rand(0..99),
    gradeCminus:  rand(0..99),
    gradeDplus:   rand(0..99),
    gradeD:       rand(0..99),
    gradeE:       rand(0..99)}
  )
end

puts "Creating Exam Questions"
rand(100..999).times do
  cd = Faker::Date.birthday(0, 12)
  ed = cd + rand(1..21).days
  ad = ed + rand(1..21).days
  Examquestion.create!({
    subject_id: 26,
    questiontype: DropDown::QTYPE.sample[1],
    question: "what is the cause of hypertention",
    answer: "stress",
    marks: rand(1..10).to_f.to_s,
    category: DropDown::QCATEGORY.sample[1],
    qkeyword: "",
    qstatus: DropDown::QSTATUS.sample[1]"Edited",
    creator_id: 15,
    createdt: pd,
    difficulty: rand(1..5).to_s,
    statusremark: "",
    editor_id: nil,
    editdt: ed,
    approver_id: 1,
    approvedt: ad,
    bplreserve: false,
    bplsent: [true, false].sample,
    bplsentdt: ad + rand(1..21).days,
    diagram_file_name: nil,
    diagram_content_type: nil,
    diagram_file_size: nil,
    diagram_updated_at: nil,
    topic_id: 400,
    construct: nil,
    conform_curriculum: nil,
    conform_specification: nil,
    conform_opportunity: nil,
    accuracy_construct: nil,
    accuracy_topic: nil,
    accuracy_component: nil,
    fit_difficulty: nil,
    fit_important: nil,
    fit_fairness: nil,
    programme_id: nil,
    diagram_caption: nil
  })
end

puts "Creating Exam Results"
20.times do
  dts = Faker::Date.birthday(0, 12)
  Examresult.create!({
    programme_id: 1,
    total: nil,
    pngs17: nil,
    status: nil,
    remark: nil,
    semester: rand(1..4).to_s,
    examdts: dts,
    examdte: dts + rand(7..31).days
  })
end

puts "Creating Exam Template"
25.times do
  Examtemplate.create!({
    quantity: 40,
    exam_id: 24,
    total_marks: "40.0",
    questiontype: "MCQ"
  })
end

def multiple5
  (15..180).select do |i|
    i % 5 == 0
  end
end
