module LibraryHelper
  
  def self.roman_list2
    #http://rubyquiz.com/quiz22.html
    roman_map = { 1 => "i",4 => "iv",5 => "v",9 => "ix",10 => "x",40 => "xl",50 => "l",90 => "xc",100 => "c",400 => "cd",500 => "d",900 => "cm",1000 => "m" }
    roman_numerals = Array.new(3999) do |index| 
      target = index + 1
	  roman_map.keys.sort { |a, b| b <=> a }.inject("") do |roman, div|
	      times, target = target.divmod(div)
	      roman << roman_map[div]* times
	  end
      end   
      roman_numerals
  end
  
  def self.update_book_accession(spreadsheet)
    spreadsheet.default_sheet = spreadsheet.sheets.first 
    header = spreadsheet.row(1)     
    saved_books=[]
    saved_accessions=[]
    removed_books=[]
    
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose] 
      
      #retrieve UNIQUE fields for a book first   
      callno=row["no_panggilan"]
      auth=row["pengarang"]
      title2=row["judul_utama"]
      isbn2=row["isbn_e"]
    
      #retrieve other SINGLE column(s) of SINGLE value
      accno=row["no_perolehan"].to_i.to_s.rjust(10,"0")	#convert into 10 digits format
      edition2=row["edisi"]
      language2=row["bahasa"]
      subject2=row["tajuk_perkara"]
      indice2=row["ms_indeks"]
      bibliography2=row["ms_bibliografi"]
      purchaseprice2=row["harga_rm"]
      finance_source2=row["sumber_kewangan"]
      location2=row["lokasi"]
      notes2=row["catitan"]
      
      #retrieve other SINGLE column(s) for MULTIPLE values
      #(a)imprint=publish_location, publisher, publish_date 
      imprint2=row["imprint"]
      if imprint2.include?(",")
	  pub_loc=imprint2.split(",")[0]
	  pub=imprint2.split(",")[1].lstrip if imprint2.split(",")[1]!=nil
	  pub_dt=imprint2.split(",")[2].lstrip if imprint2.split(",")[2]!=nil
      end
      #(b)physical_desc/roman=roman, size,pages : data distributed during save action, refer --> before_save :extract_roman_into_size_pages
      roman2=row["deskripsi_fizikal"]
      
      book_recs = Book.where(classlcc: callno, author: auth, title: title2, isbn: isbn2)
      book_rec = book_recs.first || Book.new
      if book_rec.id.nil? || book_rec.id.blank? 	
	  #new book
	  book_rec.classlcc=callno
	  book_rec.author=auth
	  book_rec.title=title2
	  book_rec.isbn=isbn2
      else
	#existing book
      end
      
      #for both - if no value exist yet (first row of excel file affected, but preceeding row of the same row not affected)
      if book_rec.edition.nil? || book_rec.edition.blank?
	  book_rec.edition=edition2
      end
      if book_rec.language.nil? || book_rec.language.blank?
	  book_rec.language=language2
      end
      if book_rec.subject.nil? || book_rec.subject.blank?
	  book_rec.subject=subject2
      end
      if book_rec.publish_date.nil? || book_rec.publish_date.blank?
	  book_rec.publish_date=pub_dt
      end
      if book_rec.publish_location.nil? || book_rec.publish_location.blank?
	  book_rec.publish_location=pub_loc
      end
      if book_rec.publisher.nil? || book_rec.publisher.blank?
	  book_rec.publisher=pub
      end
      if book_rec.backuproman.nil? || book_rec.backuproman.blank?
	  book_rec.backuproman=roman2
      end
      if book_rec.roman.nil? || book_rec.roman.blank?
	  book_rec.roman=roman2
      end
      book_rec.save!
      
      #for previous WRONG saved records
      if book_recs.count>1
	  book_rec_a=[]
	  book_rec_a<< book_rec.id
	  book_rec_ids_to_remove = book_recs.pluck(:id)-book_rec_a
	  book_recs_to_remove = where('id IN (?)', book_rec_ids_to_remove)
	  book_recs_to_remove.each do |book_rem|
	      book_rem.destroy
	  end
      end
      
      #check if row exist in Accession
      accession_rec = Accession.where(accession_no: accno).first || Accession.new
      if accession_rec.id.nil? || accession_rec.id.blank?
	  accession_rec.accession_no=accno
	  accession_rec.book_id=book_rec.id
	  accession_rec.save!
      end
      
      saved_books << book_rec
      saved_accessions << accession_rec
      removed_books << book_rem if book_recs.count>1
    end
    result={:svb=>saved_books, :sva=>saved_accessions,:rmb=>removed_books}
  end
      
end
