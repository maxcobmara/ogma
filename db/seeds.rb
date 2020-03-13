# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
heavy_false_data = [[true, 1],[false,99]]

puts "Creating Academic Sessions"
(2012..2020).each do | y |
  AcademicSession.create!([
    {semester: "1/#{y}", total_week: 26},
    {semester: "2/#{y}", total_week: 26}
  ])
end

puts "Not Creating Accessions"


puts "Creating Address Book"
60.times do
  comp = Faker::Company.name
  domain  = comp.parameterize.underscore
  AddressBook.create!({
    name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.street_address,
    mail: "#{Faker::Name.first_name}@#{domain}.com",
    web: "www.#{domain}.com",
    fax: Faker::PhoneNumber.phone_number,
    shortname: nil
  })
end

puts "Creating Assetcategory"
Assetcategory.create!([
  {id: 1, parent_id: nil, description: "Loji",            cattype_id: 1},
  {id: 2, parent_id: nil, description: "Jentera Berat",   cattype_id: 1},
  {id: 3, parent_id: nil, description: "Kenderaan",       cattype_id: 1},
  {id: 4, parent_id: nil, description: "Peralatan",       cattype_id: 1},
  {id: 5, parent_id: nil, description: "Kelengkapan ICT", cattype_id: 1},
  {id: 6, parent_id: nil, description: "Telekomunikasi",  cattype_id: 1},
  {id: 7, parent_id: nil, description: "Penyiaran",       cattype_id: 1},
  {id: 9, parent_id: nil, description: "Pejabat",         cattype_id: 1},
  {id: 8, parent_id: nil, description: "Peralatan Perubatan", cattype_id: 1},
  {id: 10, parent_id: nil, description: "Makmal",         cattype_id: 1},
  {id: 11, parent_id: nil, description: "Bengkel",        cattype_id: 1},
  {id: 12, parent_id: nil, description: "Dapur",          cattype_id: 1},
  {id: 13, parent_id: nil, description: "Sukan",          cattype_id: 1},
  {id: 14, parent_id: 3, description: "Kereta",           cattype_id: 1},
  {id: 15, parent_id: 3, description: "Motosikal",        cattype_id: 1},
  {id: 16, parent_id: 3, description: "Van",              cattype_id: 1},
  {id: 17, parent_id: 3, description: "Bas",              cattype_id: 1},
  {id: 18, parent_id: 8, description: "Mesin X-Ray",      cattype_id: 1},
  {id: 19, parent_id: 8, description: "Radiographic Unit",cattype_id: 1}
])


puts "Creating Assets"
1000.times do
  status_hvf = heavy_false_data.max_by { |_, weight| rand ** (1.0 / weight) }
  pd = Faker::Date.birthday(0, 12)
  Asset.create!({
    assetcode: Faker::Number.hexadecimal(19),
    cardno: "",
    assettype: [1,2].sample,
    bookable: [true, false].sample,
    name: Faker::Commerce.product_name,
    typename: Faker::App.name,
    manufacturer_id: nil,
    modelname: "",
    serialno: Faker::Number.hexadecimal(21),
    otherinfo: "",
    orderno: "",
    purchaseprice:  ((19999 - 5.0) * rand()).round(2),
    purchasedate: pd,
    receiveddate: pd + (rand(14..60).days),
    receiver_id: nil,
    supplier_id: nil,
    assignedto_id: 36, #human
    locassigned: false,
    status: nil,
    location_id: nil,
    country_id: nil,
    warranty_length: nil,
    warranty_length_type: nil,
    category_id: Assetcategory.where('parent_id IS ?', nil).sample.id,
    subcategory: "",
    quantity: nil,
    quantity_type: "",
    engine_type_id: nil,
    engine_no: "",
    registration: "",
    nationcode: "",
     mark_disposal: status_hvf,
     mark_as_lost: false,
     is_disposed: false,
     is_maintainable: true,
     remark: nil})
end


puts "Create Asset defects"
30.times do
  init_date = Faker::Date.birthday(0, 12)
  AssetDefect.create!({
    asset_id: Asset.all.sample.id,
    reported_by: 98, #Staff.all.sample.id
    notes: nil,
    description: "",
    process_type: ["repair", "dispose"].sample,
    recommendation: "",
    is_processed: [true, false, nil].sample,
    processed_by: 96, #Staff.all.sample.id
    processed_on: init_date,
    decision: [true, false, nil].sample,
    decision_by: 58, #Staff.all.sample.id
    decision_on: init_date + rand(7..60).days
  })
end


puts "Create AssetDisposal"
9.times do
  init_date       = Faker::Date.birthday(0, 12)
  core_asset      = AssetDefect.where(process_type: "dispose").sample.asset
  current_value   = (core_asset.purchaseprice/2).round(2)
  est_repair_cost = (current_value + (current_value * rand(0.01..0.9))).round(2)
  est_value_post  = (current_value + (current_value * rand(0.01..0.9))).round(2)
  revalue         = (current_value - (current_value * rand(0.01..0.9))).round(2)
  disposal_type   = ["discard", "sold", "transfer"].sample
  discard_options = (disposal_type == "discard" ? ["bury", "throw", "burn", nil].sample : nil)
  is_checked      = [true, false].sample
  verified_on     = init_date + rand(7..60).days
  is_disposed     = [true, false].sample
  disposed_on     = is_disposed == true ? (verified_on + rand(7..60).days) : nil
  is_discarded    = is_disposed == true ? [true, false].sample : nil

  AssetDisposal.create!({
    asset_id: core_asset.id,
    quantity: nil,
    asset_defect_id: nil,
    description: nil,
    running_hours: 5,
    mileage: nil,
    current_condition: "Rosak",
    current_value: current_value,
    est_repair_cost: est_repair_cost,
    est_value_post_repair: est_value_post,
    est_time_next_fail: "1.0",
    repair1_needed: "monitor",
    repair2_needed: "cpu",
    repair3_needed: "",
    justify1_disposal: ["tidak ekonomik dibaiki",""].sample,
    justify2_disposal: "",
    justify3_disposal: "",
    is_checked: is_checked,
    checked_on: (init_date if is_checked == true),
    is_verified: ([true, false].sample unless is_checked == false),
    verified_on: verified_on,
    revalue: revalue,
    revalued_by: 96,
    revalued_on: verified_on + rand(7..60).days ,
    document_id: 28,
    disposal_type: disposal_type,
    type_others_desc: "",
    discard_options: discard_options,
    receiver_name: "",
    documentation_no: "",
    is_disposed: is_disposed,
    inform_hod: nil,
    disposed_by: (58 unless is_disposed == false),
    disposed_on: (verified_on + rand(7..60).days unless is_disposed == false),
    is_discarded: is_discarded,
    discarded_on: (disposed_on + rand(7..60).days if is_discarded == true),
    discard_location: "Johor Bahru",
    discard_witness_1: 39,
    discard_witness_2: 38,
    checked_by: 96,
    verified_by: 58,
    examiner1: "",
    examiner2: "",
    is_staff1: [true,false,nil].sample,
    is_staff2: [true,false,nil].sample,
    examiner_staff1: 25,
    examiner_staff2: 36,
    witness_outsider1: nil,
    witness_outsider2: nil,
    witness_is_staff1: [true,false,nil].sample,
    witness_is_staff2: [true,false,nil].sample
  })
end

puts "create Asset Loan"
25.times do
  is_approved = [true, false].sample
  approved_on = Faker::Date.birthday(0, 12)
  loaned_on   = approved_on + rand(7..60).days
  expected_on = loaned_on + rand(1..14).days
  is_returned = [true, false].sample
  returned_on = (is_returned == true ? loaned_on + rand(1..21).days : nil)
  AssetLoan.create!({
    asset_id: Asset.all.sample.id,
    staff_id: 93,
    reasons: Faker::Company.catch_phrase,
    loaned_by: 25,
    is_approved: is_approved,
    approved_date: approved_on,
    loaned_on: loaned_on,
    expected_on: expected_on,
    is_returned: is_returned,
    returned_on: returned_on,
    remarks: "",
    loan_officer: 25,
    hod: is_approved == true ? rand(1..200) : nil,
    hod_date: nil,
    loantype: [1,2].sample,
    received_officer: is_returned == true ? rand(1..200) : nil
  })
end

puts "Creating Lost Assets "
rand(5..20).times do
  init_date = Faker::Date.birthday(0, 12)
  submitted = [true, false].sample
  AssetLoss.create!({
    form_type: nil,
    loss_type: "asset",
    asset_id: Asset.all.sample.id,
    cash_type: "",
    est_value: nil,
    is_used: nil,
    ownership: nil,
    value_state: nil,
    value_federal: nil,
    location_id: nil,
    lost_at: init_date,
    how_desc: Faker::Company.catch_phrase,
    report_code: Faker::Number.hexadecimal(6),
    last_handled_by: 20,
    is_prima_facie: [true, false].sample,
    is_staff_action: false,
    is_police_report_made: false,
    police_report_code: "",
    why_no_report: "",
    police_action_status: "",
    is_rule_broken: nil,
    rules_broken_desc: nil,
    preventive_action_dept: nil,
    prev_action_enforced_by: nil,
    preventive_measures: Faker::Hacker.adjective,
    new_measures: Faker::Hacker.noun ,
    recommendations: nil,
    surcharge_notes: nil,
    notes: Faker::Hacker.say_something_smart,
    investigated_by: nil,
    investigation_code: nil,
    investigation_completed_on: nil,
    security_officer_notes: nil,
    security_officer_id: nil,
    security_code: nil,
    is_submit_to_hod: submitted,
    endorsed_hod_by: (58 if submitted),
    endorsed_on: (init_date + rand(7..60).days if submitted),
    is_writeoff: nil,
    document_id: nil,
  })
end


puts "Moving Assets to Location"
Asset.all.sample(rand(10..100)).each do | asset |
  q = (asset.assettype == 2 ? rand(1..99) : nil)
  AssetPlacement.create!({
    asset_id: asset.id,
    location_id: 22,
    staff_id: 70,
    reg_on: Faker::Date.birthday(0, 12),
    quantity:  q
  })
end

puts "Not creating Attachments"
puts ""
