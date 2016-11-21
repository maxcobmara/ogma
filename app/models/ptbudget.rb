class Ptbudget < ActiveRecord::Base
  
  validates_presence_of :fiscalstart, :budget
  validates_uniqueness_of :fiscalstart
  
  def budget_start
   Ptbudget.first.fiscalstart  rescue Date.today
  end
  
  def fiscal_end
    main_fiscaldate=Date.new(fiscalstart.year, budget_start.month, budget_start.day)
    fiscalend=main_fiscaldate+1.year-1.day
  end
  
  def siblings_budget
    sibs=[]
    Ptbudget.all.group_by{|x|x.fiscal_end}.each do |fiscal_ending, ptbudgets|
      sibs = ptbudgets.map(&:id) if fiscal_ending==fiscal_end
    end
    sibs
  end
  
  def used_budget  #final amount
    if siblings_budget.count==1
      usedbudget=Ptschedule.where("start >=? AND start <?", fiscalstart, fiscalstart + 1.year).sum(:final_price)         
    else
      previous_fiscaldate=Date.new(fiscalstart.year, budget_start.month, budget_start.day)-1.year
      usedbudget=Ptschedule.where("start >=? AND start <?", previous_fiscaldate, fiscal_end).sum(:final_price)
    end 
    usedbudget
  end
  
  def budget_balance   #current amount
    acc_budget-used_budget
  end
  
  def acc_budget   #accumulated as of current fiscalstart
    if fiscalstart.month==budget_start.month && fiscalstart.day==budget_start.day 
      accumulated_budget=budget
    else
      accumulated_budget=Ptbudget.where('id IN(?) and fiscalstart<=?', siblings_budget, fiscalstart).sum(:budget)
    end
    accumulated_budget
  end
  
  def next_budget_date
    #Ptbudget.last.fiscalstart + 1.year
    budget_all=Ptbudget.all.order(fiscalstart: :desc)     #for all MAIN records, fiscal_end always same month & day
    count=0
    budget_all.each do |yy|
      if yy.fiscalstart.month==budget_start.month && yy.fiscalstart.day==budget_start.day && count==0
        @last_main=yy.fiscalstart
        count+=1
      end
    end
    budget_date = @last_main+1.year rescue Date.today #@last_main+1.year
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
