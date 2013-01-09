class Tenant < ActiveRecord::Base
  belongs_to :location
  belongs_to :staff
  belongs_to :student
  
  
  def student_tenant
    a = Array.new
    pid = self.student_id
    a << pid
    available_student = Tenant.find(:all, :select => "student_id", :conditions => ["student_id IS NOT ?", nil]).map(&:student_id)
    if student_id == nil
      available_student
    else
      available_student - a
    end
  end
  
  
  
  def student_name #16/11/2011 - Shaliza added code for student if no longer exist.
    check_kin {student.student_name_with_programme}
  end

  def staff_name #16/11/2011 - Shaliza added code for staff if no longer exist.
    check_kin {staff.staff_name_with_position}
  end

  def location_name #16/11/2011 - Shaliza added code for location if no longer exist.
    check_kin {location.location_list}
  end

  def location_typename #16/11/2011 - Shaliza added code for typename if no longer exist.
    check_kin {location.typename}
  end

  def course_details
    check_kin {student.programme_for_student}
  end
  
  

end
