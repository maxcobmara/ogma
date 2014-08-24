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

  def self.all_digits(str)
    str[/[0-9]+/] == str
  end

  def self.all_letters(str)
    # Use 'str[/[a-zA-Z]*/] == str' to let all_letters
    # yield true for the empty string
    str[/[a-zA-Z]+/] == str
  end
  
  def self.update_book_accession(spreadsheet)
    spreadsheet.default_sheet = spreadsheet.sheets.first 
    header = spreadsheet.row(1)     
    saved_books=[]
    saved_accessions=[]
    removed_books=[]
    wrong_price_types=[]
    books_wo_acc=[]
    #duplicate_acc=[]
    duplicate_acc=1
    
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose] 
      
      #retrieve UNIQUE fields of a book
      #additional Float check required for numbers-only data
      #lstrip required for string to remove leading/preceeding spaces
      callno=row["no_panggilan"]     
      if callno.is_a? Float
	callno=callno.to_i.to_s
      elsif callno.is_a? String
	callno=callno.lstrip if callno
      end
      auth=row["pengarang"]
      if auth.is_a? String
	auth=auth.lstrip if auth
      end
      title2=row["judul_utama"]
      if title2.is_a? String
	title2=title2.lstrip if title2
      end
      isbn2=row["isbn_e"]
      if isbn2.is_a? Float
	isbn2=isbn2.to_i.to_s
      end
      
      #accession no format : 10 digits (etc: 0000000001)
      accno=row["no_perolehan"].to_i.to_s.rjust(10,"0").to_s
      
      #language
      language2=row["bahasa"]
      language2=language2.downcase if language2
      if language2
	if language2.include?("ing") || language2.include?("en")
	  language2="EN"
	elsif language2.include?("mel") || language2.include?("ms_MY")
	  language2="ms_MY"
	else
	  language2="lain"
	end
      end
      
      #bibliography - integer (1 page only) or 1-2 or includes
      bibliography3=row["ms_bibliografi"]
      if bibliography3.is_a? String
	biblio_num=LibraryHelper.all_digits(bibliography3) if bibliography3
	if biblio_num
	  bibliography2=bibliography3.to_i.to_s
	else
	  bibliography2=bibliography3
	end
      elsif bibliography3.is_a? Numeric
	bibliography2=bibliography3.to_i.to_s
      end
      
      #imprint=publish_location, publisher, publish_date 
      imprint2=row["imprint"]
      if imprint2
	sepa="," if imprint2.include?(",") && imprint2.count(",")==2    
	sepa=";" if imprint2.include?(";") && imprint2.count(";")==2  
	sepa=":" if imprint2.include?(":") && imprint2.count(":")==2
	if sepa
	  pub_loc=imprint2.split(sepa)[0]
	  pub=imprint2.split(sepa)[1].lstrip if imprint2.split(sepa)[1]!=nil
	  pub_dt=imprint2.split(sepa)[2].lstrip if imprint2.split(sepa)[2]!=nil
	end
      end
      
      #price from excel - numbers or 'Sumbangan' 
      purchaseprice3=row["harga_rm"]
      if (purchaseprice3.is_a? Float) || (purchaseprice3.is_a? Numeric)		#In Excel : format cell -> Number = In Postgresql : Numeric
	 purchaseprice2=purchaseprice3
      elsif purchaseprice3.is_a? Integer
	purchaseprice2=purchaseprice3.to_f
      elsif purchaseprice3.is_a? String
	pprice = LibraryHelper.all_letters(purchaseprice3) if purchaseprice3
	pprice2 = LibraryHelper.all_digits(purchaseprice3) if purchaseprice3
	if pprice
	  if purchaseprice3.downcase.include?("sumb")
	    purchaseprice2=0.0
	  else
	    #wrong values will be ignored
	  end
	end
	if pprice2
	    purchaseprice2=purchaseprice3.to_f
	end
      elsif purchaseprice3.is_a? Date
	wrong_price_types << accno
      end
      
      #notes from excel - integer or comp/supplier's name?
      notes3=row["catitan"]
      if notes3.is_a? String
	notes_num=LibraryHelper.all_digits(notes3) if notes3
	if notes_num
	  notes2=notes3.to_i.to_s
	else
	  notes2=notes3
	end
      elsif notes3.is_a? Numeric
	notes2=notes3.to_i.to_s
      end
      
      #based on above UNIQUE fields, retrieve existing record(s) Or create new
      book_recs = Book.where(classlcc: callno, author: auth, isbn: isbn2, title: title2)
      book_rec = book_recs.first || Book.new
       
      #columns in excel - title & accno MUST EXIST
      if title2 && accno
	
	#exsiting record - data remains unchange
	book_rec.classlcc=callno
	book_rec.author=auth
	book_rec.title=title2
	book_rec.isbn=isbn2
      
	book_rec.attributes = row.to_hash.slice("edisi","tajuk_perkara","ms_indeks","sumber_kewangan","lokasi","deskripsi_fizikal")
      
	book_rec.edition=book_rec.edisi
	book_rec.subject=book_rec.tajuk_perkara
	book_rec.indice=book_rec.ms_indeks
	book_rec.finance_source=book_rec.sumber_kewangan
	book_rec.location=book_rec.lokasi
     
	#language
	book_rec.language=language2
	
	#bibliography
	book_rec.bibliography=bibliography2
	
	#imprint data
	book_rec.publish_date=pub_dt
	book_rec.publish_location=pub_loc
	book_rec.publisher=pub
      
	#physical_desc/roman=roman no, size, pages : data distributed during save action, refer --> before_save :extract_roman_into_size_pages
	book_rec.backuproman=book_rec.deskripsi_fizikal
	book_rec.roman=book_rec.deskripsi_fizikal
      
	book_rec.purchaseprice = purchaseprice2 if purchaseprice2
	book_rec.notes=notes2 if notes2

	book_rec.save!

	#update Or create Accession(s) for saved book_rec
	accession_rec = Accession.where(accession_no: accno).first || Accession.new
	if accession_rec.id.nil? || accession_rec.id.blank?
	  accession_rec.accession_no=accno
	  accession_rec.book_id=book_rec.id
	  accession_rec.save!
	else		#accession no already exist (in Accessions table)
	  books_wo_acc << "("+duplicate_acc.to_s+") "+book_rec.title[0,15]+"(#{accno}) "
	end

      end #end for if title2 && accno
      
      #for previous WRONG saved records (existing), ignore the first found book record (A) and retrieve the rest (B)
      #for each (B) book record, if accession(s) exist, set its corresponding accession(s) to (A) (copy book_id)
      #remove (B) book records
      if book_recs.count>1
	 book_rec_ids_to_remove = book_recs.pluck(:id)-book_rec.pluck(:id)
	  if book_rec_ids_to_remove.count>0
	      book_recs_to_remove = Book.where('id IN (?)', book_rec_ids_to_remove)
	      book_recs_to_remove.each do |book_rem|
		  total_accs = book_rem.accessions.count
		  if total_accs>0
		      book_rem.accessions.each do |b_rem_acc|
			b_rem_acc.book_id = book_rec.id
			b_rem_acc.save!
		      end
		  end
		  book_rem.destroy
	      end
	  end
      end
     
      #collect records for messaging purposes
      saved_books << book_rec
      saved_accessions << accession_rec
      removed_books << book_rem if book_recs.count>1
      
    end
    result={:svb=>saved_books, :sva=>saved_accessions,:rmb=>removed_books, :wpt=> wrong_price_types, :bwoacc=>books_wo_acc}
  end
  
  def self.msg_import(a) 
    if a[:svb].count>0 || a[:rmb].count>0# || a[:sva].count>0 
      msg="" 
      if a[:svb].count>0
	msg+=a[:svb].count.to_s+(I18n.t 'actions.records')+(I18n.t 'actions.imported_updated') 
      end
      if a[:rmb].count>0
	msg+=(I18n.t'library.book.and')+a[:rmb].count.to_s+(I18n.t'library.book.book2')+(I18n.t 'actions.removed') 
      end 
    end
    msg
  end
  
  def self.msg_import2(a) 
    msg=""  
    #wrong price type 
    if a[:wpt].count>0
      stt=""
      a[:wpt].each_with_index do |wp,ind|
	stt+="(#{ind+1}) #{wp}"
	stt+=", " if ind+1<a[:wpt].count
      end
      msg+=(I18n.t'library.book.wrong_price_types')+(I18n.t'library.book.wrong_price_types2')+stt
    end
    msg
  end
      
end
