class Intake < ActiveRecord::Base
  
  before_save :apply_month_year_if_nil
  before_destroy :valid_for_removal
  
  belongs_to :programme, :foreign_key => 'programme_id'
  belongs_to :coordinator, :class_name => 'Staff', :foreign_key => 'staff_id'
  has_many   :students
  has_many   :weeklytimetables
  has_many   :lessonplans, :class_name => 'LessonPlan', :foreign_key=>'intake_id' 
  has_one :examresult
  
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
  
  def self.get_intake(student_intake, courseid)
    intakeid=0
    a=Intake.where(monthyear_intake: student_intake, programme_id: courseid)
    intakeid=a.first.id if a.count > 0
    intakeid
  end
  
  private
  
  def valid_for_removal
    if weeklytimetables.count > 0
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
