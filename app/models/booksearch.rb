class Booksearch < ActiveRecord::Base
  before_save :set_stock_summary, :set_title_accessionno
  
  belongs_to :college
  
  attr_accessor :method                   #to cater college.code for use of 'classlcc' / 'classddc' field
  
  def sbooks
    @sbooks ||= find_sbooks
  end
  
  def set_stock_summary
    self.stock_summary=stock_summary.to_i
  end
  
  def set_title_accessionno
    unless accessionno.blank?
      a,b =accessionno.split(" - ")
      self.title=b
      self.accessionno=a
    end
  end
  
  private

  def find_sbooks
    Book.where(conditions).order(orders)   
  end

#   def title_conditions
#     ["title ILIKE ?","%#{title}%" ] unless title.blank?
#   end
  
  def author_conditions
    ["author ILIKE ?", "%#{author}%" ] unless author.blank?      
  end
  
  def isbn_conditions
    ["isbn LIKE ?", "%#{isbn}%" ] unless isbn.blank?      
  end
  
  def accessionno_conditions
    unless accessionno.blank?
      a,b =accessionno.split(" - ")
      book_id=Accession.where(accession_no: a).first.book_id
      ["books.id=?", book_id]
    end
#     ["accessionno ILIKE ?", "%#{accessionno}%" ] unless accessionno.blank?      
  end
  
  def classno_conditions
    #["classlcc LIKE ?", "%#{classno}%"] if classno.blank? == false && stock_summary == 1
    if (method=='kskbjb' && classno.blank? == false) && (stock_summary == 2 || stock_summary == 3)
      ["classlcc ILIKE ?", "%#{classno}%"]
    else
      ["classddc ILIKE ? ", "%#{classno}%"]
    end
    #["classlcc ILIKE ? OR classddc ILIKE ? ", "%#{classno}%", "%#{classno}%"] if (classno.blank? == false && stock_summary == 2)||(classno.blank? == false && stock_summary == 3)
  end 
  
  def accessionno_start_conditions
    #if (accessionno_start.blank? == false && stock_summary == 2)||(accessionno_start.blank? == false && stock_summary == 3)
    
    if accessionno_start.blank? == false && accessionno_end.blank? == true && (stock_summary == 2 || stock_summary == 3)
      book_ids=Accession.where('accession_no>=?', accessionno_start).pluck(:book_id).uniq
    elsif accessionno_start.blank? == false && accessionno_end.blank? == false && (stock_summary == 2 || stock_summary == 3)
      book_ids=Accession.where('accession_no>=? and accession_no<=?', accessionno_start, accessionno_end).pluck(:book_id).uniq
    end
    if book_ids.count > 0
      a="books.id=?" 
      0.upto(book_ids.count-2) do |x|
        a+=" OR books.id=? "
      end
      ["("+a+")", book_ids] 
    end
    
    #['accessionno>=?', accessionno_start] if (accessionno_start.blank? == false && stock_summary == 2)||(accessionno_start.blank? == false && stock_summary == 3)
  end
  
  def accessionno_end_conditions
    #if (accessionno_end.blank? == false && stock_summary == 2)|(accessionno_end.blank? == false && stock_summary == 3)
    
    if accessionno_end.blank? ==false && accessionno_start.blank? ==true && (stock_summary==2 || stock_summary==3)
      book_ids=Accession.where('accession_no<=?', accessionno_end).pluck(:book_id).uniq
      if book_ids.count > 0
        a="books.id=?" 
        0.upto(book_ids.count-2) do |x|
          a+=" OR books.id=? "
        end
        ["("+a+")", book_ids] 
      end
    end
    
    #['accessionno<=?', accessionno_end] if (accessionno_end.blank? == false && stock_summary == 2)|(accessionno_end.blank? == false && stock_summary == 3)
  end
  
  def publisher_conditions
    ['publisher ILIKE(?)', "%#{publisher}%" ] unless publisher.blank?
  end
  
  def orders
     "accessionno ASC"
   end  

   def conditions
     [conditions_clauses.join(' AND '), *conditions_options] #works like OR?????
   end

   def conditions_clauses
     conditions_parts.map { |condition| condition.first }
   end

   def conditions_options
     conditions_parts.map { |condition| condition[1..-1] }.flatten
   end

   def conditions_parts
     private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
   end
   
end
