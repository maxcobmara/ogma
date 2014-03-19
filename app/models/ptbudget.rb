class Ptbudget < ActiveRecord::Base
  
  validates_presence_of :fiscalstart, :budget, :used_budget, :budget_balance
  #Addsupplier.sum(:quantity, :conditions => ["supplier_id = ?", id])

    belongs_to :staff,  :foreign_key => 'fiscalstart' 
  
  def fiscal_end
#    fiscalstart + 1.year - 1.day
  end
  
  def used_budget
    budstart = fiscalstart
    budend = fiscal_end
    Ptschedule.sum(:final_price, :conditions => ["start >=? AND start <=?", budstart, fiscal_end])
  end
  
  def budget_balance
 #   budget-used_budget
  end
  
  def next_budget_date
   Ptbudget.last.fiscalstart + 1.year
  end 
end

# == Schema Information
#
# Table name: ptbudgets
#
#  budget      :decimal(, )
#  created_at  :datetime
#  fiscalstart :date
#  id          :integer          not null, primary key
#  updated_at  :datetime
#
