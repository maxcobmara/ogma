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



def multiple5
  (15..180).select do |i|
    i % 5 == 0
  end
end
