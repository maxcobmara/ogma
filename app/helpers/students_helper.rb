module StudentsHelper

  def year_and_sem(student)
      current_month = Date.today.strftime("%m")
  	  current_year = Date.today.strftime("%Y")
  	  intake_month = student.intake.monthyear_intake.strftime("%m")
  	  intake_year = student.intake.monthyear_intake.strftime("%Y")
  	  diff_year = current_year.to_i-intake_year.to_i
  	  start_year = 1
  	  start_sem = 1

  	  if intake_month.to_i < 7 
  		  if current_month.to_i < 7 
  			  @year = start_year + diff_year 
  			  @semester = start_sem 
  		  elsif current_month.to_i > 6 
  			  @year = start_year + diff_year 
  			  @semester = 2 
  		  end 
  	  elsif intake_month.to_i > 6 
  		  if current_month.to_i < 7 
  			  @year = diff_year 
  			  @semester = 2 							
  		  elsif current_month.to_i > 6 
  		    @year = start_year + diff_year 
  			  @semester = 1 
  		  end
  	  end 

  	  "Year #{@year}, Semester #{@semester}"

  end
end