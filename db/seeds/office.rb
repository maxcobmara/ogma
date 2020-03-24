

50.times do
  init_date = Faker::Time.between(180.days.ago, Date.today, :all)
  Bulletin.create!({
    headline: Faker::SiliconValley.motto,
    content: Faker::BojackHorseman.quote,
    postedby_id: 25,
    publishdt: init_date.to_date,
    data_file_name: "Chrysanthemum.jpg",
    data_content_type: "image/jpeg",
    data_file_size: 879394,
    data_updated_at: init_date,
    created_at: init_date,
    updated_at: init_date
  })
end

100.times do
  init_date = Faker::Time.between(180.days.ago, Date.today, :all)
  Circulation.create!({
    document_id: 111,
    staff_id: 93,
    action_date: init_date,
    action_taken: ["maklum", nil, "OK"].sample,
    action_remarks: "",
    action_closed: [true, false].sample,
    action_file_name: nil,
    action_content_type: nil,
    action_file_size: nil,
    action_updated_at: init_date + rand(1..21).days
  })
end

25.times do
  init_date = Faker::Time.between(180.days.ago, Date.today, :all)
  Evactivity.create!({
    appraisal_id: 28,
    evaldt: nil,
    evactivity: Faker::TheITCrowd.quote,
    actlevel: DropDown::EVACT.sample[1].to_i,
    actdt: init_date.to_date + rand(7..21).days,
    created_at: init_date,
    updated_at: init_date
  })
end

50.times do
  init_date   = Faker::Time.between(180.days.ago, Date.today, :all)
  event_date  = init_date + rand(7..21).days
  Event.create!({
    id: 29,
    eventname: Faker::BackToTheFuture.quote,
    location: ["Sekitar KSKBJB", "KSKB JB", "Dewan Serbaguna"].sample,
    participants: ["Semua Staff", "Semua Pelajar", "Semua Staff & Pelajar"," Semua Pelajar Baru"].sample,
    officiated: "",
    start_at: event_date,
    end_at:  event_date + rand(1..8).hours,
    createdby: 180,
    event_is_publik: [true, false].sample,
    created_at: init_date,
    updated_at: init_date
  })
end
