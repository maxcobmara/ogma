module  StaffTraining::PtbudgetsHelper
  
  def fiscal_end(budget)
    (budget.fiscalstart + 1.year - 1.day).try(:strftime, "%d %B %Y")
  end
  
  def fiscal_range(budget)
    budget.fiscalstart.strftime("%d %B %Y") + ' ~ ' + fiscal_end(budget)
  end
  
end