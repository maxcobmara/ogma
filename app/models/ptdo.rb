class Ptdo < ActiveRecord::Base
  before_save  :whoami, :auto_unit_approval_for_academician, :auto_unit_dept_approval_amsas

  belongs_to  :college, :foreign_key => 'college_id'
  belongs_to  :ptschedule
  belongs_to  :staff
  belongs_to  :applicant, :class_name => 'Staff',   :foreign_key => 'staff_id'
  belongs_to  :replacement, :class_name => 'Staff', :foreign_key => 'replacement_id'
  has_many    :staff_appraisals, :through => :staff
  
  validates_uniqueness_of :staff_id, :scope => :ptschedule_id, :message => I18n.t("staff.training.application_status.staff_must_unique")
  validate :staff_id, presence: true

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

  def auto_unit_approval_for_academician
    if unit_approve.blank? && college.code!='amsas'
      applicant_roles=User.where(userable_id: staff_id).first.roles.map(&:name)
      if applicant_roles.include?("Lecturer") || Programme.roots.map(&:name).include?(applicant.positions.first.unit) #14 - Lecturer
        self.unit_approve=true
        self.unit_review="Auto-approved"
        self.justification="Not applicable for academician"
      end
    end
  end
  
  def auto_unit_dept_approval_amsas
    if college.code=='amsas'
      self.unit_approve=true
      self.unit_review="Not applicable"
      self.dept_approve=true
      self.dept_review="Not applicable"
    end
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
  
  def repl_staff2(current_unit, current_staff, current_roles)
    
    exist_unit_of_staff_in_position = Position.where('unit is not null and staff_id is not null').map(&:staff_id).uniq
    if exist_unit_of_staff_in_position.include?(current_staff)    
      
      #current_unit=userable.positions.first.unit
      #replace current_unit value if academician also a Unit Leader (23)
      #current_roles=User.where(userable_id: userable_id).first.roles.map(&:name) #"Unit Leader" #userable.roles.map(&:role_id) 
      current_unit=unit_lead_by_academician if current_roles.include?("Unit Leader") && Programme.roots.map(&:name).include?(current_unit)
      
      if current_unit=="Pentadbiran"
        unit_members = Position.where('unit=? OR unit=? OR unit=? OR unit=?', "Kejuruteraan", "Pentadbiran Am", "Perhotelan", "Aset & Stor").map(&:staff_id).uniq-[nil]+Position.where('unit=?', current_unit).map(&:staff_id).uniq-[nil]
      elsif ["Teknologi Maklumat", "Pusat Sumber", "Kewangan & Akaun", "Sumber Manusia"].include?(current_unit) || Programme.roots.map(&:name).include?(current_unit)
        unit_members = Position.where('unit=?', current_unit).map(&:staff_id).uniq-[nil]
      else #logistik & perkhidmatan inc."Unit Perkhidmatan diswastakan / Logistik" or other UNIT just in case - change of unit name, eg. Perpustakaan renamed as Pusat Sumber
        unit_members = Position.where('unit ILIKE(?)', "%#{current_unit}%").map(&:staff_id).uniq-[nil] 
      end
    else
      unit_members = []#Position.find(:all, :conditions=>['unit=?', 'Teknologi Maklumat']).map(&:staff_id).uniq-[nil]
    end
    unit_members    #collection of staff_id (member of a unit/dept) - use in model/user.rb (for auth_rules)
  end

  def apply_dept_status
    if (unit_approve == false || dept_approve == false || final_approve == false)
      I18n.t("staff.training.application_status.app_reject") #"Application Rejected"
    elsif unit_approve.nil? == true
      I18n.t("staff.training.application_status.await_unit_app") #"Awaiting Unit Approval" 
    elsif unit_approve == true && dept_approve.nil? == true
      if User.where(userable_id: staff_id).first.roles.map(&:name).include?("Lecturer") || Programme.roots.map(&:name).include?(applicant.positions.first.unit)
        I18n.t("staff.training.application_status.await_dept_app")#unit approval - not applicable for academician
      else
        I18n.t("staff.training.application_status.app_by_unit_head")#"Approved by Unit head, awaiting Dept approval"
      end  
    elsif dept_approve == true && dept_approve == true && final_approve.nil? == true
      if college.code=='amsas'
        I18n.t("staff.training.application_status.auto_app_require_director_app") #Amsas only - auto Unit & Dept Approval, just require Director/Komandan/Chief Asst Director
      else
        I18n.t("staff.training.application_status.app_by_dept_head") #"Approved by Dept head, awaiting Pengarah approval"
      end
    elsif dept_approve == true && dept_approve == true && final_approve == true && trainee_report.nil? == true
      if college.code=='amsas'
        I18n.t("staff.training.application_status.approval_completed")  #Approved
      else
        I18n.t("staff.training.application_status.all_app_comp") #"All approvals complete"
      end
    elsif dept_approve == true && dept_approve == true && final_approve == true && trainee_report.nil? == false
      I18n.t("staff.training.application_status.report_submit") #"Report Submitted"
    else
      I18n.t("staff.training.application_status.status_not_available") #"Status Not Available"
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
         if college.code=='amsas'
           staff.staff_with_rank
         else
           staff.mykad_with_staff_name
         end
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
    #ptcourse_ids = Ptdo.where('id IN(?) AND final_approve=? AND trainee_report is not null', ptdoids_staff, true).map(&:ptcourse_id)  #valid attended courses
    ptcourse_ids= Ptschedule.joins(:ptdos).where('ptdos.id IN(?) AND ptdos.final_approve=? AND ptdos.trainee_report is not null', ptdoids_staff, true).pluck(:ptcourse_id).uniq
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
  
  def self.unit_members(current_unit, current_staff, current_roles)
    #Academicians & Mgmt staff : "Teknologi Maklumat", "Perpustakaan", "Kewangan & Akaun", "Sumber Manusia","logistik", "perkhidmatan" ETC.. - by default staff with the same unit in Position will become unit members, whereby Ketua Unit='unit_leader' role & Ketua Program='programme_manager' role.
    #Exceptional for - "Kejuruteraan", "Pentadbiran Am", "Perhotelan", "Aset & Stor" (subunit of Pentadbiran), Ketua Unit='unit_leader' with unit in Position="Pentadbiran" Note: whoever within these unit if wrongly assigned as 'unit_leader' will also hv access for all ptdos on these unit staff
 
    exist_unit_of_staff_in_position = Position.where('unit is not null and staff_id is not null').map(&:staff_id).uniq
    if exist_unit_of_staff_in_position.include?(current_staff)    
      
      #replace current_unit value if academician also a Unit Leader
      current_unit=unit_lead_by_academician if current_roles.include?("unit_leader") && Programme.roots.map(&:name).include?(current_unit)
      
      if current_unit=="Pentadbiran"
        unit_members = Position.where('unit=? OR unit=? OR unit=? OR unit=?', "Kejuruteraan", "Pentadbiran Am", "Perhotelan", "Aset & Stor").map(&:staff_id).uniq-[nil]+Position.where('unit=?', current_unit).map(&:staff_id).uniq-[nil]
      elsif ["Teknologi Maklumat", "Pusat Sumber", "Kewangan & Akaun", "Sumber Manusia"].include?(current_unit) || Programme.roots.map(&:name).include?(current_unit)
        unit_members = Position.where('unit=?', current_unit).map(&:staff_id).uniq-[nil]
      else #logistik & perkhidmatan inc."Unit Perkhidmatan diswastakan / Logistik" or other UNIT just in case - change of unit name, eg. Perpustakaan renamed as Pusat Sumber
        unit_members = Position.where('unit ILIKE(?)', "%#{current_unit}%").map(&:staff_id).uniq-[nil] 
      end
    else
      unit_members = []#Position.find(:all, :conditions=>['unit=?', 'Teknologi Maklumat']).map(&:staff_id).uniq-[nil]
    end
    #unit_members    #collection of staff_id (member of a unit/dept) - use in model/user.rb (for auth_rules)
    where('staff_id IN(?)', unit_members) ##use in ptdo.rb (controller - index)
  end
  
  #used in Ptdosearches : Show
  def self.staff_unit(curr_staff)
    unit_staff=curr_staff.try(:position).try(:unit)
    unit_staff=unit_staff.lstrip unless unit_staff.blank?
    if unit_staff =='Pos Basik' || unit_staff == 'Pengkhususan' || unit_staff== 'Diploma Lanjutan'
      @a_unit_staff=""
      pos_basic_name = Programme.where('ancestry_depth=? AND (course_type=? OR course_type=? OR course_type=?)', 0, 'Diploma Lanjutan', 'Pos Basik', 'Pengkhususan').map(&:name) 
      staff_tasks_main=curr_staff.try(:position).try(:tasks_main)
      unless staff_tasks_main.blank?
        pos_basic_name.each do |pb_name| 
          @a_unit_staff=pb_name if staff_tasks_main.include?(pb_name)
        end
      end
      dept=@a_unit_staff
    else
      dept=unit_staff if unit_staff!='' 
    end
    dept
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
