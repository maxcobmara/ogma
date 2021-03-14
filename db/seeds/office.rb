puts "Attaching Bulletin to Boards"
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

puts "Creating Appraisal Activities"
rand(20..60).times do
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

puts "Creating Event"
50.times do
  init_date   = Faker::Time.between(180.days.ago, Date.today, :all)
  event_date  = init_date + rand(7..21).days
  Event.create!({
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

puts "Organising Files"
50.times do
  Cofile.create!({
    cofileno: Faker::Code.npi,
    name: Faker::Commerce.department(2, true),
    location: "BILIK FAIL",
    owner_id: Staff.all.sample,
    onloan: false,
    staffloan_id: nil,
    onloandt: nil,
    onloanxdt: nil
  })
end

puts "Creating and filing documents"
Cofile.each do | file |
  rand(1..25).times do | i |
    init_date = Faker::Date.birthday(0, 12)
    staff     = Staff.all.sample
    Document.create!({
      serialno: i.to_s,
      refno: file.cofileno + "/" + i.to_s,
      category: DropDown::DOCUMENT_CATEGORY,
      title: Faker::Company.catch_phrase,
      letterdt: init_date,
      letterxdt: init_date,
      from: "JKNJ",
      stafffiled_id: staff.id,
      file_id: file.id,
      closed: true,
      data_file_name: nil,
      data_content_type: nil,
      data_file_size: nil,
      data_updated_at: nil,
      otherinfo: Faker::TheITCrowd.quote,
      cctype_id: 1,
      cc1staff_id: nil,
      cc1date: init_date,
      cc1action: nil,
      cc1remarks: nil,
      cc1closed: nil,
      cc2staff_id: nil,
      cc2date: nil,
      cc2action: nil,
      cc2remarks: nil,
      cc2closed: nil,
      cc1actiondate: nil,
      dataaction_file_name: nil,
      dataaction_content_type: nil,
      dataaction_file_size: nil,
      dataaction_updated_at: nil,
      prepared_by: staff.id,
      sender: nil
    })
  end
end

puts "Circulating Documents"
end_count = Document.count
Document.all.sample(rand(10..endcount)).each do | doc |
  init_date = Faker::Time.between(180.days.ago, Date.today, :all)
  Circulation.create!({
    document_id: doc.id,
    staff_id: Staff.all.sample.id,
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


puts "Creating Stationary"
rand(25..100).times do
  min = rand(25..500)
  max = min + rand(25..500)
  Stationery.create!({
    code: Faker::Number.hexadecimal(5),
    category: Faker::Commerce.color + Faker::Commerce.product_name,
    unittype: "items",
    maxquantity: max,
    minquantity: min
  })
end

puts "Creating Stationary Stock Records"
Stationery.each do | s |
  rand(0..6).times do
    StationeryAdd.create!({
      stationery_id: s.id,
      lpono: Faker::Invoice.creditor_reference,
      document: "",
      unitcost: Faker::Commerce.price,
      received: Faker::Date.birthday(0, 12),
      quantity: rand(20..100)
    })
  end
  rand(0..25).times do
    StationeryUse.create!({
      stationery_id: s.id,
      issuedby: Staff.all.sample.id,
      receivedby: Staff.all.sample.id,
      issuedate: Faker::Date.birthday(0, 12),
      quantity: rand(1..25)
    })
  end
end
