class Ptcourse < ActiveRecord::Base
  
  has_many :scheduled, :class_name => 'Ptschedule'
  belongs_to :provider, :class_name => 'AddressBook', :foreign_key => 'provider_id'
  
  validates_presence_of :name
  validates_presence_of :level, :if => :trainingclass?
  
  scope :domestic, -> { where(training_classification:1, level:1)}
  scope :overseas, -> { where(training_classification:1, level:2)}
  
  def trainingclass?
    training_classification == 1
  end
  
  ##-individual duration IN STRING of a ptcourse-start : usage (ptschedules/index.html.erb)
  def course_total_days
    if duration_type == 0
      total_days = (duration / 6).to_f
    elsif duration_type == 1
      total_days = duration*1
    elsif duration_type == 2
      total_days = duration*30
    elsif duration_type == 3
      total_days = duration*365
    end
    days_count = total_days * 6 / 6
    bal_hours = total_days * 6 % 6
    if bal_hours > 0
      if days_count.to_i > 0
        total_days_instring=days_count.to_i.to_s+" "+I18n.t('time.days')+" "+bal_hours.to_i.to_s+" "+I18n.t('time.hours')
      else
        total_days_instring=bal_hours.to_i.to_s+" "+I18n.t('time.hours')
      end
    else
      total_days_instring=days_count.to_i.to_s+" "+I18n.t('time.days') if days_count.to_i > 0
      total_days_instring=I18n.t('ptdos.nil') if days_count.to_i ==0
    end
    total_days_instring
  end
  ##-individual duration IN STRING of a ptcourse-end
  
#   def rendered_programme_classification
#     (DropDown::PROGRAMME_CLASSIFICATION.find_all{|disp, value| value == training_classification}).map {|disp, value| disp}.first
#   end
#   
#   def rendered_level
#     (DropDown::TRAINING_LEVEL.find_all{|disp, value| value == level}).map {|disp, value| disp} 
#   end
#   
#   def rendered_course_type
#     (DropDown::COURSE_TYPE.find_all{|disp, value| value == course_type }).map {|disp, value| disp}.first
#   end
#   
#   def rendered_course_duration
#     (DropDown::DURATION_TYPE.find_all{|disp, value| value == duration_type }).map {|disp, value| disp}[0]
#   end
end

# == Schema Information
#
# Table name: ptcourses
#
#  approved                :boolean
#  cost                    :decimal(, )
#  course_type             :integer
#  created_at              :datetime
#  description             :text
#  duration                :decimal(, )
#  duration_type           :integer
#  id                      :integer          not null, primary key
#  level                   :integer
#  name                    :string(255)
#  proponent               :string(255)
#  provider_id             :integer
#  training_classification :integer
#  updated_at              :datetime
#
