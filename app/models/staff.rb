class Staff < ActiveRecord::Base

  paginates_per 13
  
  validates :icno, presence: true#, numericality: true, length: { is: 12 }, uniqueness: true
  validates_presence_of     :name, :coemail, :code, :appointdt, :current_salary #appointment date must exist be4 can apply leave, salary - for transport class

  before_destroy :valid_for_removal
  
  belongs_to :title,        :class_name => 'Title',           :foreign_key => 'titlecd_id'
  belongs_to :staffgrade,   :class_name => 'Employgrade',     :foreign_key => 'staffgrade_id'
  belongs_to :staff_shift,  :foreign_key => 'staff_shift_id'
  belongs_to :rank, :foreign_key => 'rank_id'

  has_many :users, as: :userable, :dependent => :nullify

  has_many  :positions, :dependent => :nullify
  has_many  :tenants
  
  has_many :vehicles, :dependent => :destroy
  accepts_nested_attributes_for :vehicles, :allow_destroy => true, :reject_if => lambda {|a| a[:cylinder_capacity].blank? }#|| a[:reg_no].blank?}
  validates_associated :vehicles
  
  has_many :shift_histories, :dependent => :destroy
  accepts_nested_attributes_for :shift_histories, :reject_if => lambda {|a| a[:deactivate_date].blank?}

  has_many :assets, :foreign_key => "assignedto_id", :dependent => :nullify
  has_many :reporters, :class_name => 'AssetDefect', :foreign_key => 'reported_by'

  has_many :asset_disposal, :foreign_key => 'disposed_by'
  has_many :processors, :class_name => 'AssetDisposal', :foreign_key => 'checked_by'
  has_many :verifiers,  :class_name => 'AssetDisposal', :foreign_key => 'verified_by'
  has_many :revaluers,  :class_name => 'AssetDisposal', :foreign_key => 'revalued_by'
  
  has_many :asset_loans, :foreign_key => 'staff_id' #peminjam / loaner
  has_many :assignedto_assetloans, :foreign_key => 'loaned_by'  #bertanggungjawab
  has_many :released_assetloans, :foreign_key => 'loan_officer' #loan_officer
  has_many :approved_assetloans, :foreign_key => 'hod' #hod 
  has_many :returned_assetloans, :foreign_key => 'received_officer' #received_officer
  has_many :driven_vehicles, :foreign_key => 'driver_id'

  has_many :timetables
  has_many :prepared_weekly_schedules, :class_name => 'Weeklytimetable', :foreign_key => 'prepared_by', :dependent => :nullify
  has_many :endorsed_weekly_schedules, :class_name => 'Weeklytimetable', :foreign_key => 'endorsed_by', :dependent => :nullify
  has_many :weekly_schedule_details, :class_name => 'WeeklytimetableDetail', :foreign_key => 'lecturer_id', :dependent => :nullify
  has_many :intakes  #upon graduation, may become coordinator for other intakes

  has_many :attendingstaffs,    :class_name => 'StaffAttendance', :foreign_key => 'thumb_id', :primary_key => 'thumb_id'#, :dependent => :destroy #attendance staff name
  has_many :approvers,          :class_name => 'StaffAttendance', :foreign_key => 'approved_by' # approver name
  
  has_many :fingerprint_owners, :class_name => 'Fingerprint', :foreign_key => 'thumb_id', :dependent => :destroy
  has_many :fingerprint_approvers, :class_name => 'Fingerprint', :foreign_key => 'approved_by'
  
  has_many :trainingnotes,    :class_name => 'Trainingnote'

  has_many          :qualifications, :dependent => :destroy
  accepts_nested_attributes_for :qualifications, :allow_destroy => true, :reject_if => lambda { |a| a[:level_id].blank? }

  has_many          :loans, :dependent => :destroy
  accepts_nested_attributes_for :loans, :reject_if => lambda { |a| a[:ltype].blank? }

  has_many          :bankaccounts, :dependent => :destroy
  accepts_nested_attributes_for :bankaccounts, :reject_if => lambda { |a| a[:account_no].blank? }

  has_many          :kins, :dependent => :destroy
  accepts_nested_attributes_for :kins, :reject_if => lambda { |a| a[:kintype_id].blank? }
 
  has_many          :mycpds, :dependent => :destroy
  accepts_nested_attributes_for :mycpds
  validates_associated :mycpds
  
  has_attached_file :photo,
                    :url => "/assets/staffs/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/staffs/:id/:style/:basename.:extension", #, :styles => {:thumb => "40x60"}
                    :styles => { :original => "250x300>", :thumbnail => "50x60" } #default size of uploaded image
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
                    #may require validation

  #Link to model Staff Appraisal
  has_many :appraisals,     :class_name => 'StaffAppraisal', :foreign_key => 'staff_id', :dependent => :destroy
  has_many :eval1_officers, :class_name => 'StaffAppraisal', :foreign_key => 'eval1_by', :dependent => :nullify
  has_many :eval2_officers, :class_name => 'StaffAppraisal', :foreign_key => 'eval2_by', :dependent => :nullify

  #Link to Model travel_claim
  has_many :travel_claims, :dependent => :destroy
  has_many :approvers,           :class_name => 'TravelClaim',      :foreign_key => 'approved_by', :dependent => :nullify
  has_many :checkers,            :class_name => 'TravelClaim',      :foreign_key => 'checked_by', :dependent => :nullify

  #links to Model TravelRequest
  #has_many :staffs,             :class_name => 'TravelRequest', :foreign_key => 'staff_id', :dependent => :destroy #staff name
  #has_many :replacements, :class_name => 'TravelRequest', :foreign_key => 'replaced_by' #replacement name
  #has_many :headofdepts,  :class_name => 'TravelRequest', :foreign_key => 'hod_id' #hod
  has_many :travelrequests, :class_name => 'TravelRequest', :dependent => :destroy   # dependencies as vehicles
  has_many :replacor_travelstaff, :class_name => 'TravelRequest', :dependent => :nullify
  has_many :travelrequest_approver, :class_name => 'TravelRequest', :dependent => :nullify

  #25Jan2015
  has_many :circulations
  has_many :documents, :through => :circulations
  
  has_many :evaluate_courses
  has_many :average_scores_lecturer, class_name: 'AverageCourse', foreign_key: 'lecturer_id'
  has_many :average_scores_verifier, class_name: 'AverageCourse', foreign_key: 'principal_id'
  
  has_many :instructor_appraiseds, class_name: 'InstructorAppraisal', foreign_key: 'staff_id'
  has_many :instructor_qcs, class_name: 'InstructorAppraisal', foreign_key: 'check_qc'
  has_many :averaged_instructors, class_name: 'AverageInstructor', foreign_key: 'instructor_id'
  has_many :averaged_evaluators, class_name: 'AverageInstructor', foreign_key: 'evaluator_id'
  
  has_one :mentor, foreign_key: 'staff_id'
  
  has_many :discipline_case_processed, class_name: 'StudentDisciplineCase' #KS / Programme Mgr - FK : assigned_to
  has_many :discipline_case_referred, class_name: 'StudentDisciplineCase' # Mentor @ Kaunselor / TPHEP - FK : assigned2_to
  has_many :discipline_case_comanded, class_name: 'StudentDisciplineCase' #Comandant (amsas only) - FK : commandant_id

  #validates_attachment_size         :photo, :less_than => 500.kilobytes
  #validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
 #---------------Validations------------------------------------------------
# validates :icno, presence: true, numericality: true, length: { is: 12 }, uniqueness: true							#temp remark-staff attendance-5Aug2014  staff_nothumb.save! will fail
  #validates_numericality_of :icno#, :kwspcode
  #validates_length_of       :icno, :is =>12
  #
  #validates_uniqueness_of   :fileno, :coemail, :code														#temp remark-staff attendance-5Aug2014
  #validates_format_of       :name, :with => /^[a-zA-Z'`\/\.\@\ ]+$/, :message => I18n.t('activerecord.errors.messages.illegal_char') #add allowed chars between bracket
 # validates_presence_of     :cobirthdt, :addr, :poskod_id, :staffgrade_id, :statecd, :country_cd, :fileno					#temp remark-staff attendance-5Aug2014
  #validates_length_of      :cooftelno, :is =>10
  #validates_length_of      :cooftelext, :is =>5
  #validates_length_of       :addr, :within => 1..180,:too_long => "Address Too Long"								#temp remark-staff attendance-5Aug2014
  #validate :coemail, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => I18n.t('activerecord.errors.messages.invalid') }		#temp remark-staff attendance-5Aug2014

  #--------------------Declerations----------------------------------------------------
  
   def create_shift_history_nodate(saved_shift, current_shift, new_deactivate_date)
      new_shift = ShiftHistory.new
      new_shift.shift_id = saved_shift #should save history not new one
      new_shift.deactivate_date = Date.today
      new_shift.staff_id =self.id #for checking = (current_shift.to_s+"0"+saved_shift.to_s).to_i
      new_shift.save
      #By default, 'deactivate_date is hidden && 'if 'deactivate_date' is blank - no 'shift history' will be saved'
      #If 'staff_shift_id' CHANGED - 'deactivate_date' will be displayed - if date is entered record will be saved & vice versa.
      #create/save 'shift history' here by giving default value as Date.today for condition when 'staff_shift_id' is changed but 'deactivate_date' not entered.
    end 
  
    def age
      Date.today.year - cobirthdt.year unless cobirthdt == nil
    end
    
    def staff_with_rank
      "#{rank.try(:shortname)} #{name}"
    end
    
    def staff_with_rank_position
      if positions.count > 0
        a=" (#{position_for_staff})"
      else
	a=""
      end
      staff_with_rank+a 
    end
    
    def staff_with_rank_unit
      if positions.count > 0
        a=" (#{positions.try(:first).try(:unit)})"
      else
        a=""
      end
      staff_with_rank+a
    end
    
    def staff_rank_unit_id
      [staff_with_rank_unit, id]
    end
    
    def staff_with_rank_position_unit
      "#{staff_with_rank_position} - #{unit_for_staff}"
    end

    def staff_list
    "#{icno}"+" "+"#{name}"
    end
    
    def formatted_mykad
    "#{icno[0,6]}-#{icno[6,2]}-#{icno[-4,4]}"
    end

    def mykad_with_staff_name
      "#{formatted_mykad}  #{name}"
    end
    
    def mykad_with_staff_name_position_grade
      "#{formatted_mykad}  #{name} (#{position_for_staff}-#{grade_for_staff})"
    end

#     def shift_for_staff
#       ssft = StaffShift.find(:first, :conditions=> ['id=?',staff_shift_id])
#       if ssft == nil
#         "-"
#       else
#         ssft.start_end
#       end
#     end

    def thumb_id_with_name_unit
      if positions.blank?
	"#{thumb_id} | #{name}"
      else
      "#{thumb_id} |  #{name} (#{positions.first.unit})"
      end
    end

    def staff_name_with_position
      "#{name}  (#{position_for_staff})"
    end

    def staff_name_with_position_grade
      "#{name}  (#{position_for_staff}-#{grade_for_staff})"
    end

    def staff_name_with_position_grade_unit
      "#{name}  (#{position_for_staff}-#{grade_for_staff}-#{unit_for_staff})"
    end
    
    def staff_name_with_unit
      "#{name} (#{unit_for_staff})"
    end

    def unit_for_staff
      if positions.blank?
        "-"
      else
        "#{positions[0].try(:unit)}"
      end
    end
    
    def grade_for_staff
      if positions.blank?
        "-"
      else
        "#{positions[0].staffgrade.try(:name)}"
      end
    end
    
    def position_for_staff
      if positions.blank?
        "-"
      else
        positions[0].name
      end
    end

    def staff_thumb
      "#{name}  (thumb id : #{thumb_id})"
    end


  def render_unit
    if positions.blank?
      "Staff not exist in Task & Responsibilities"
    elsif positions.first.is_root?
        "Pengarah"
    elsif positions
      if positions.first.unit.blank?
        "#{positions.first.name}"                  #display position name instead - must be somebody!
      else
        "#{positions.first.unit}"                  #   "#{position.unit} - 3"
      end
    end
  end
  
  def name_id
    [staff_with_rank, id]
  end
  
  def transport_class
    abc = TravelClaimsTransportGroup.abcrate
    de = TravelClaimsTransportGroup.derate
    mid = 1820.75
    if vehicles && vehicles.count>0
      TravelClaimsTransportGroup.transport_class(vehicles.first.id, current_salary, abc, de, mid)
    else
      'Z' #no vehicles?
    end
  end
  
  #Multi positions - for use in Leaveforstaff
    def approver1_list_multipost
      parent_post_ids=positions.map(&:parent_id)
      parent_staff_ids=Position.where(id: parent_post_ids).pluck(:staff_id)
    end
    
    def approver2_list_multipost
      parent_post_ids=positions.map(&:parent_id)
      grandparent_post_ids=Position.where(id: parent_post_ids).map(&:parent_id)
      grandparent_staff_ids=Position.where(id: grandparent_post_ids).pluck(:staff_id)
    end
    
    def valid_for_removal
     evc=evaluate_courses.count
     avc=average_scores_lecturer.count
     ins=instructor_appraiseds.count
     avg=averaged_instructors.count
     ten=tenants.count
     if evc > 0
       errors.add(:base, "#{I18n.t('evaluate_course.title')} : #{evc} #{I18n.t('actions.records')}")
     end
     if avc > 0
       errors.add(:base, "#{I18n.t('average_course.title')} : #{avc} #{I18n.t('actions.records')}")
     end
     if ins > 0
       errors.add(:base, "#{I18n.t('instructor_appraisal.title')} : #{ins} #{I18n.t('actions.records')}")
     end
     if avg > 0
       errors.add(:base, "#{I18n.t('average_instructor.title')} : #{avg} #{I18n.t('actions.records')}")
     end
     if ten > 0
       errors.add(:base, "#{I18n.t('student.tenant.title2')} : #{ten} #{I18n.t('actions.records')}")
     end
     if evc > 0 || avc > 0 || ins > 0 || avg > 0 || ten > 0
       return false
     else
       return true
     end
   end
   
   #usage - users/index
   def positions_units(dev)
     if positions.blank?
       a="-"
     else
       a=""
       cnt=0
       if dev==true
         post_total=positions.count
       else
	 #positions.count(positions.pluck(:name).include?('Jangan Delete Dulu')==true) #temp
	 b=0
	 positions.pluck(:name).each{|x|b+=1 if x.include?('Jangan Delete Dulu')==true}
         post_total=positions.count-b
       end
       for post in positions
         a+=",<br>" if cnt > 0 && cnt < post_total
         if post.name.include?('Jangan Delete Dulu')  #temp
	   if dev==true
             a+=post.name+" / "+post.unit
	     cnt+=1
	   end
	 else
           a+=post.name+" / "+post.unit
	   cnt+=1
	 end
       end
     end
     a
   end
   
  
end

# == Schema Information
#
# Table name: staffs
#
#  addr                    :string(255)
#  appointby               :string(255)
#  appointdt               :date
#  appointstatus           :string(255)
#  att_colour              :integer
#  bank                    :string(255)
#  bankaccno               :string(255)
#  bankacctype             :string(255)
#  birthcertno             :string(255)
#  bloodtype               :string(255)
#  cobirthdt               :date
#  code                    :string(255)
#  coemail                 :string(255)
#  confirmdt               :date
#  cooftelext              :string(255)
#  cooftelno               :string(255)
#  country_cd              :integer
#  country_id              :integer
#  created_at              :datetime
#  employscheme            :string(255)
#  employstatus            :integer
#  fileno                  :string(255)
#  gender                  :integer
#  icno                    :string(255)
#  id                      :integer          not null, primary key
#  kwspcode                :string(255)
#  mrtlstatuscd            :integer
#  name                    :string(255)
#  pension_confirm_date    :date
#  pensiondt               :date
#  pensionstat             :string(255)
#  phonecell               :string(255)
#  phonehome               :string(255)
#  photo_content_type      :string(255)
#  photo_file_name         :string(255)
#  photo_file_size         :integer
#  photo_updated_at        :datetime
#  posconfirmdate          :date
#  position_old            :integer
#  poskod_id               :integer
#  promotion_date          :date
#  race                    :integer
#  reconfirmation_date     :date
#  religion                :integer
#  schemedt                :date
#  staff_shift_id          :integer
#  staffgrade_id           :integer
#  starting_salary         :decimal(, )
#  statecd                 :integer
#  svchead                 :string(255)
#  svctype                 :string(255)
#  taxcode                 :string(255)
#  thumb_id                :integer
#  time_group_id           :integer
#  titlecd_id              :integer
#  to_current_grade_date   :date
#  transportclass_id       :string(255)
#  uniformstat             :string(255)
#  updated_at              :datetime
#  wealth_decleration_date :date
#
