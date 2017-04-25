class Documentsearch < ActiveRecord::Base
  attr_accessor :method
  
  belongs_to :college
  
  before_save :set_status_nil_when_checkbox_checked
  
  validate :closed_must_present_when_checkbox_unchecked
  
  def documents
    @documents ||= find_documents
  end
  
  def set_status_nil_when_checkbox_checked
    if from=='1' && (closed==true || closed==false) 
      self.closed=nil
    end
  end
  
  def closed_must_present_when_checkbox_unchecked
    if from=='0' && [true, false].include?(closed) == false && (refno.blank? && title.blank?)
      errors.add(:base, I18n.t('equery.document.checkbox_unchecked'))
    end
  end
  
  private

  def find_documents
    Document.where(conditions).order(orders)   
  end

  def refno_conditions
    ["refno ILIKE ?", "%#{refno}%"] unless refno.blank?      
  end

  def category_conditions
    ["category=?", category] unless category.blank?
  end
  
  def title_conditions
    ["title ILIKE ?","%#{title}%" ] unless title.blank?
  end
  
  def letterdt_conditions
    ["letterdt>=?" , letterdt] unless letterdt.blank?
  end
  
  def letterdtend_conditions
    ["letterdt<?", letterdtend+1.day] unless letterdtend.blank?
  end
  
  def letterxdt_conditions
    ["letterxdt>=?" , letterxdt] unless letterxdt.blank?
  end
  
  def letterxdtend_conditions
    ["letterxdt<?", letterxdtend+1.day] unless letterxdtend.blank?
  end
  
  def sender_conditions
     ["documents.from ILIKE ?","%#{sender}%" ] unless sender.blank? 
  end
  
  def file_id_details
      a='id=? ' if Document.where('file_id=?',file_id).map(&:id).uniq.count!=0
      0.upto(Document.where('file_id=?',file_id).map(&:id).uniq.count-2) do |l|  
        a=a+'OR id=? '
      end 
      return a unless file_id.blank?
  end  
  
  def file_id_conditions
    [" ("+file_id_details+")", Document.where('file_id=?',file_id).map(&:id)] unless file_id.blank?
  end
  
  def closed_conditions
      ["closed=?", closed] unless from=='1' 
  end  
 
  def orders
    "letterxdt ASC"
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
