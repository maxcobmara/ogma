class Intake < ActiveRecord::Base
  
  serialize :data, Hash
   
  before_save :apply_month_year_if_nil
  before_destroy :valid_for_removal
  
  belongs_to :programme, :foreign_key => 'programme_id'
  belongs_to :coordinator, :class_name => 'Staff', :foreign_key => 'staff_id'
  belongs_to :college, :foreign_key => 'college_id'
  has_many   :students
  has_many   :weeklytimetables
  has_many   :lessonplans, :class_name => 'LessonPlan', :foreign_key=>'intake_id' 
  has_one :examresult
  
  validates :programme_id, :name,:register_on, :description, presence: true # :description, => total division (amsas)
  validates :staff_id, presence: true, :if => :college_isnot_amsas?
  validates :name, uniqueness: true

  def division=(value)
    data[:division] = value
  end
  def division
    data[:division]
  end
  
  def self.division_search(query)
    ids=[]
    for intk in Intake.all
      0.upto(intk.description.to_i-1) do |x|
        ids << intk.id if (intk.division[x.to_s]["name"]).downcase.include?(query.downcase)
      end
    end
    where(id: ids)
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:division_search]
  end  
  
  def college_isnot_amsas?
    #college_id!=2
    college.code!='amsas'
  end
  
  def apply_month_year_if_nil
    if monthyear_intake==nil && register_on!=nil
      self.monthyear_intake = register_on.to_date.beginning_of_month
    end
  end
  
  def group_with_intake_name
    "#{description}"+' ('+I18n.t('training.intake.title')+" #{name}"+')'
  end  
  
  def programme_group_intake
    "#{description} (#{name}) | #{programme.name}"
  end
  
  def programmelist_group_intake
    "#{description} (#{name}) | #{programme.programme_list}"
  end
  
  #amsas
  def siri_name
    "Siri #{name}"
  end
  
  def siri_programmelist
    "#{intake_details} | #{programme.programme_list}"
  end
  
  def self.get_intake(student_intake, courseid)
    intakeid=0
    a=Intake.where(monthyear_intake: student_intake, programme_id: courseid)
    intakeid=a.first.id if a.count > 0
    intakeid
  end
  
  #usage - studentsearch
  def intake_details
    if college.code=='amsas'
      "#{siri_name}"
    else
      "#{monthyear_intake.strftime('%b %Y')}"
    end
  end
  
  #usage - new multiple (exammarks & grades)
  def intake_list
    if college.code=='amsas'
      ["#{siri_programmelist}", monthyear_intake]
    else
      ["#{monthyear_intake.strftime('%b %Y')}", monthyear_intake]
    end
  end
  
  def intake_list_name
    ["#{siri_programmelist}", name]
  end
  
  def self.division_list
    arr=[]
    for intk in Intake.where.not(description: '0')
      if intk.description.to_i > 0
        
        intk.division.each do |k,v|
	  arr << ["#{intk.siri_programmelist}: #{v[:name]}", "#{intk.id}~#{k}"]
        end
      end
    end
    arr
  end
  
  #usage - studentsearch
  def self.programme_intake_list
    a=[]
    Programme.roots.where(id: Intake.pluck(:programme_id).uniq).order(course_type: :asc).each do |programme|
      b=[[I18n.t('select'),""]]
      programme.intakes.uniq.each{|int| b << [int.intake_details, int.id] unless int.intake_details.blank?}
      a << [programme.programme_list, b]
    end
    a
  end
  
  #usage - studentattendancesearch
  def self.programme_intake_list_with_attendance_rec
    intake_ids= WeeklytimetableDetail.attended_classes.joins(:weeklytimetable).pluck(:intake_id)
    a=[]
    Programme.roots.where(id: Intake.pluck(:programme_id).uniq).order(course_type: :asc).each do |programme|
      b=[[I18n.t('select'),""]]
      programme.intakes.uniq.each{|int| b << [int.intake_details, int.id] if int.intake_details.blank? == false && intake_ids.include?(int.id)==true }
      a << [programme.programme_list, b]
    end
    a
  end
  
  private
  
  def valid_for_removal
    if (weeklytimetables && weeklytimetables.count > 0) || (students && students.count > 0) || (lessonplans && lessonplans.count > 0) || (examresult && examresult.count > 0)
      return false
    else
      return true
    end
  end
  
end

# == Schema Information
#
# Table name: intakes
#
#  created_at       :datetime
#  description      :string(255)
#  id               :integer          not null, primary key
#  is_active        :boolean
#  monthyear_intake :date
#  name             :string(255)
#  programme_id     :integer
#  register_on      :date
#  updated_at       :datetime
#
