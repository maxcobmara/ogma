class Booksearch < ActiveRecord::Base
  before_save :set_stock_summary, :set_title_accessionno
  
  belongs_to :college
    
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
      book_id=Accession.where("accession_no ILIKE ?", "%#{a}%").first.book_id
      if book_id
        ["books.id=?", book_id]
      end
    end
  end
  
  def classno_conditions
    unless classno.blank?
      if college.code=='amsas'
         ["classddc ILIKE ? ", "%#{classno}%"]
      elsif college.code=='kskbjb'
         ["classlcc ILIKE ?", "%#{classno}%"]
      end
    end
  end 
  
  def accessionno_start_conditions
    unless accessionno_start.blank?
      if accessionno_start.blank? == false && accessionno_end.blank? == true #&& (stock_summary == 2 || stock_summary == 3)
        book_ids=Accession.where('accession_no>=?', accessionno_start).pluck(:book_id).uniq
      elsif accessionno_start.blank? == false && accessionno_end.blank? == false #&& (stock_summary == 2 || stock_summary == 3)
        book_ids=Accession.where('accession_no>=? and accession_no<=?', accessionno_start, accessionno_end).pluck(:book_id).uniq
      end
      if book_ids.count > 0
        a="books.id=?" 
        0.upto(book_ids.count-2) do |x|
          a+=" OR books.id=? "
        end
        ["("+a+")", book_ids] 
      end
    
    end
  end
  
  def accessionno_end_conditions
    unless accessionno_end.blank?
      if accessionno_end.blank? ==false && accessionno_start.blank? ==true #&& (stock_summary==2 || stock_summary==3)
        book_ids=Accession.where('accession_no<=?', accessionno_end).pluck(:book_id).uniq
        if book_ids.count > 0
          a="books.id=?" 
          0.upto(book_ids.count-2) do |x|
            a+=" OR books.id=? "
          end
          ["("+a+")", book_ids] 
        end
      end
    
    end
  end
  
  def publisher_conditions
    ['publisher ILIKE(?)', "%#{publisher}%" ] unless publisher.blank?
  end
  
  def orders
     "title ASC"
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
