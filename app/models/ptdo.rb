class Ptdo < ActiveRecord::Base
  before_save  :whoami

  belongs_to  :ptschedule
  belongs_to  :staff
  belongs_to  :applicant, :class_name => 'Staff',   :foreign_key => 'staff_id'
  belongs_to  :replacement, :class_name => 'Staff', :foreign_key => 'replacement_id'


  has_many    :staff_appraisals, :through => :staff

  def self.keyword_search(query)
    staff_ids = Staff.where('icno ILIKE (?) OR name ILIKE(?)', "%#{query}%", "%#{query}%").pluck(:id).uniq
    where('staff_id IN(?)', staff_ids)
  end

  def self.ransackable_scopes(auth_object = nil)
    [:keyword_search,:status_search]
  end

  def self.status_search(query)
    if query == '1'
      status = where('unit_approve IS FALSE OR dept_approve IS FALSE OR final_approve IS FALSE')
    elsif query == '2'
      status = where('unit_approve IS NULL IS TRUE')
    elsif query == '3'
      status = where('unit_approve IS TRUE AND dept_approve IS NULL IS TRUE' )
    elsif query == '4'
      status =  where('dept_approve IS TRUE AND dept_approve IS TRUE AND final_approve IS NULL IS TRUE')
    elsif query == '5'
      status = where('dept_approve IS TRUE AND dept_approve IS TRUE AND final_approve IS TRUE AND trainee_report IS NULL IS TRUE')
    elsif query == '6'
      status = where('dept_approve IS TRUE AND dept_approve IS TRUE AND final_approve IS TRUE AND trainee_report IS NULL IS FALSE')
    elsif query == '7'
      status = where('NULL')
    else
      status = Ptdo.all
    end
    status
  end

  def self.sstaff2(u)
     where('staff_id=?', u)
  end

  def whoami
    #self.staff_id = Login.current_login.staff.id
    #self.ptcourse_id = ptschedule.course.id
  end

  def repl_staff
    sibpos = applicant.positions.first.sibling_ids
    dept   = applicant.positions.first.unit
    sibs   = Position.where(["id IN (?) AND unit=?" , sibpos,dept]).pluck(:staff_id)
    applicant = Array(staff_id)
    sibs - applicant
  end

  def apply_dept_status
    if (unit_approve == false || dept_approve == false || final_approve == false)
      "Application Rejected"
    elsif unit_approve.nil? == true
      "Awaiting Unit Approval"
    elsif unit_approve == true && dept_approve.nil? == true
      "Approved by Unit head, awaiting Dept approval"
    elsif dept_approve == true && dept_approve == true && final_approve.nil? == true
      "Approved by Dept head, awaiting Pengarah approval"
    elsif dept_approve == true && dept_approve == true && final_approve == true && trainee_report.nil? == true
      "All approvals complete"
    elsif dept_approve == true && dept_approve == true && final_approve == true && trainee_report.nil? == false
      "Report Submitted"
    else
      "Status Not Available"
    end
  end

  def applicant_details
       suid = applicant
       exists = Staff.select(:id).pluck(:id)
       checker = suid && exists

       if staff_id == nil
          ""
        elsif checker == []
          "Staff No Longer Exists"
       else
         staff.mykad_with_staff_name
       end
  end
  
  def self.staff_course_days(attended)
      #attended = Ptcourse.find(ptcourseid)
      if attended.duration_type == 0
        total_days = (attended.duration / 6.0)   #force to avoid integer division - 6.0 or 6.to_f
      elsif attended.duration_type == 1
        total_days = attended.duration*1
      elsif attended.duration_type == 2
        total_days = attended.duration*30
      elsif attended.duration_type == 3
        total_days = attended.duration*365
      end
      total_days  #hours in decimal
  end
  
  #used in Ptdosearches : Show & Ptdo : show_total_days
  def self.staff_total_days(ptdoids_staff)
    sum_total_days = 0
    ptcourse_ids = Ptdo.where('id IN(?) AND final_approve=? AND trainee_report is not null', ptdoids_staff, true).map(&:ptcourse_id)  #valid attended courses
    ptcourse_ids.each do |ptcourse_id|
      attended = Ptcourse.find(ptcourse_id)
      total_days=self.staff_course_days(attended)
      sum_total_days+=total_days.to_f
    end
    days_count = sum_total_days * 6 / 6
    bal_hours = sum_total_days * 6 % 6
    if bal_hours > 0
      if days_count.to_i > 0
        total_days_instring=days_count.to_i.to_s+" "+I18n.t('time.days')+" "+bal_hours.to_i.to_s+" "+I18n.t('time.hours')
      else
        total_days_instring=bal_hours.to_i.to_s+" "+I18n.t('time.hours')
      end
    else
      total_days_instring=days_count.to_i.to_s+" "+I18n.t('time.days') if days_count.to_i > 0
      total_days_instring=I18n.t('staff.training.application_status.nil') if days_count.to_i ==0
    end
    total_days_instring
  end
  
end

# == Schema Information
#
# Table name: ptdos
#
#  created_at     :datetime
#  dept_approve   :boolean
#  dept_review    :string(255)
#  final_approve  :boolean
#  id             :integer          not null, primary key
#  justification  :string(255)
#  ptcourse_id    :integer
#  ptschedule_id  :integer
#  replacement_id :integer
#  staff_id       :integer
#  trainee_report :text
#  unit_approve   :boolean
#  unit_review    :string(255)
#  updated_at     :datetime
#
