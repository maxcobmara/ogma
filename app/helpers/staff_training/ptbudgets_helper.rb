module  StaffTraining::PtbudgetsHelper
  
  def fiscal_end(budget)
    (budget.fiscalstart + 1.year - 1.day).try(:strftime, "%d %B %Y")
  end
  
end