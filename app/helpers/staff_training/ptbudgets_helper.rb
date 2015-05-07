module  StaffTraining::PtbudgetsHelper
  
  def fiscal_end(budget)
    (budget.fiscalstart + 1.year - 1.day).try(:strftime, "%d %B %Y")
  end
  
  def fiscal_range(budget)
    budget.fiscalstart.strftime("%d %B %Y") + ' ~ ' + fiscal_end(budget)
  end
  
  def course_type(course)
    (DropDown::STAFF_COURSE_TYPE.find_all{|disp, value| value == course.course_type}).map {|disp, value| disp}[0]
  end
  
  def duration_type(course)
    (DropDown::DURATION_TYPE.find_all{|disp, value| value == course.duration_type}).map {|disp, value| disp}[0]
  end
  
  def training_classification(course)
    (DropDown::PROGRAMME_CLASSIFICATION.find_all{|disp, value| value == course.training_classification}).map {|disp, value| disp}[0]
  end
  
end