class Librarytransactionsearch < ActiveRecord::Base
  attr_accessor :method
  
  validates :yearstat, presence: true
  validate :criteria_must_exist
  
  def librarytransactions
    @librarytransactions ||= find_librarytransactions
  end
  
  private

  def find_librarytransactions
    Librarytransaction.where(conditions).order(orders)   
  end
  
  def yearstat_conditions
    ["checkoutdate>=? AND checkoutdate<=?",yearstat.beginning_of_year, yearstat.end_of_year ] unless yearstat.blank? 
  end
  
  def orders
     "id ASC"
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
   
   def criteria_must_exist
     if accumbookloan==0 && programme==0 && fines==0 && bookloans==0 && details==0
       errors.add(:base, I18n.t('equery.library_transaction.select_criteria'))
     end
   end
end
