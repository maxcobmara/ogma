class Ptbudget < ActiveRecord::Base
  
  validates_presence_of :fiscalstart, :budget
  

  
  def used_budget
    #Ptschedule.sum(:final_price, :conditions => ["start >=? AND start <=?", budstart, fiscal_end])
    Ptschedule.where("start >=? AND start <?", fiscalstart, fiscalstart + 1.year).sum(:final_price)
  end
  
  def budget_balance
    budget-used_budget
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
