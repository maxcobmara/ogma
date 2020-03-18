

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
