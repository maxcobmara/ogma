
1000.times do
  size = rand(10..50).to_s + "cm"
  pages = rand(10..999).to_s + "ms"
  Book.create!({
    tagno: "2",
    controlno: nil,
    isbn: Faker::Code.isbn,
    bookcode: nil,
    accessionno: nil,
    catsource: nil,
    classlcc: Faker::Code.asin,
    classddc: nil,
    title: Faker::Book.title,
    author: Faker::Book.author,
    publisher: Faker::Book.publisher,
    description: nil,
    loantype: nil,
    mediatype: nil,
    status: nil,
    series: nil,
    location: ["Rak Terbuka", "Bilik Rujukan"].sample,
    topic: nil,
    orderno: nil,
    purchaseprice: nil,
    purchasedate: nil,
    receiveddate: nil,
    receiver_id: nil,
    supplier_id: nil,
    issn: nil,
    edition: rand(1..9).to_s + "th",
    photo_file_name: nil,
    photo_content_type: nil,
    photo_file_size: nil,
    photo_updated_at: nil,
    publish_date: "1993",
    publish_location: ["USA", "UK", "Malaysia"].sample,
    language: ["EN", "MY"].sample,
    links: nil,
    subject: Faker::Book.genre,
    quantity: nil,
    roman: "xviii",
    size: size,
    pages: pages,
    bibliography: nil,
    indice: "519-539",
    notes: "474",
    backuproman: "xviii;#{pages};#{size}",
    finance_source: ["KRJB", "KKJB", "Sumbangan", "Belian", "MOH", "WHO", "KKM"].sample
  })
end


counter = 0
Book.all.each do | book |
  rand(1..9).times do
    counter += 1
    Accession.create!({
      book_id: book.id,
      accession_no: format('%010d', counter),
      order_no: nil,
      purchase_price: nil,
      received: nil,
      received_by: nil,
      supplied_by: nil,
      status: nil})
  end
end
