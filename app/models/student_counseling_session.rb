class StudentCounselingSession < ActiveRecord::Base
  # befores, relationships, validations, before logic, validation logic, 
  #controller searches, variables, lists, relationship checking
  before_save :set_to_nil_where_false, :set_default_referred_case
  before_destroy :check_referred_case
  
  belongs_to :student
  belongs_to :student_discipline_case, :foreign_key => 'case_id'
  
  validates_presence_of :student_id
  validates_presence_of :confirmed_at, :if => :is_confirmed?
  
  attr_accessor :feedback,:feedback_this, :feedback_final
  
  #before logic
  def set_to_nil_where_false
    if is_confirmed == false
      self.confirmed_at= nil
    end
  end

# ref : config/application (set only this & data saved in DB in UTC) - config.time_zone = "Kuala Lumpur"
  
  def set_default_referred_case
    unless case_id.nil? || case_id.blank?
      self.c_scope="case"
      self.c_type="involuntary"
    end
  end
  
  # define scope
  def self.confirmed_at_search(query) 
    #where('confirmed_at >=? AND confirmed_at<?',query.to_date-8.hours, "2014-11-30 10:11")
    where('confirmed_at >=? AND confirmed_at<?',query.to_date-8.hours, query.to_date+1.days-8.hours)
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:confirmed_at_search]
  end
  
  def self.find_appointment#(search)
    if search
      #find(:all, :include => :student, :conditions => ['requested_at > ? AND (students.name ILIKE ? OR students.matrixno ILIKE ?)', Time.now.in_time_zone('UTC'), "%#{search}%", "%#{search}%"], :order => 'requested_at DESC')
      #includes(:student).
      where('requested_at > ?', Time.now.in_time_zone('UTC')).order(requested_at: :desc)

    else
      #find(:all, :include => :student, :conditions => ['requested_at > ?', Time.now.in_time_zone('UTC') ], :order => 'requested_at DESC')
      #includes(:student).
      where('requested_at > ?', Time.now.in_time_zone('UTC')).order(requested_at: :desc)
    end
  end
  
  def self.find_session_done#(search)
    if search
      #includes(:student).
      where('confirmed_at < ?', Time.now.in_time_zone('UTC')).order(confirmed_at: :desc)
      #find(:all, :include => :student, :conditions => ['confirmed_at < ? AND (students.name ILIKE ? OR students.matrixno ILIKE ?)', Time.now.in_time_zone('UTC'), "%#{search}%", "%#{search}%" ], :order => 'confirmed_at DESC')
    else
       #includes(:student).
      where('confirmed_at < ?', Time.now.in_time_zone('UTC')).order(confirmed_at: :desc)
      #find(:all, :include => :student, :conditions => ['confirmed_at < ?', Time.now.in_time_zone('UTC') ], :order => 'confirmed_at DESC')
    end
  end
  
  def self.get_start_date(y,m,d)
    startdate=DateTime.new(y.to_i,m.to_i,d.to_i,0,0,0)  if y!="" && m!="" && d!=""
  end
  
  def self.get_end_date(y2,m2,d2)
    enddate=(DateTime.new(y2.to_i,m2.to_i,d2.to_i,0,0,0)+1.days)  if y2!="" && m2!="" && d2!=""
  end
  
  def self.search_appointment(startdt,enddt)
    startdte=startdt.strftime('%Y-%m-%d %H:%M:%S')
    enddte =enddt.strftime('%Y-%m-%d %H:%M:%S') 
    find(:all, :conditions =>['requested_at>? and requested_at<? and requested_at >?', startdte, enddte, Time.now.in_time_zone('UTC') ],:order => 'requested_at DESC')
  end 
  
  #def self.display_msg(err)
    #full_msg=[]
    #err.each do |k,v|
      #full_msg << v
    #end
    #full_msg
  #end
  
  def self.search_session_done(startdt,enddt)
      startdte=startdt.strftime('%Y-%m-%d %H:%M:%S')
      enddte =enddt.strftime('%Y-%m-%d %H:%M:%S') 
      find(:all, :conditions =>['requested_at>? and requested_at<? and confirmed_at <?', startdte, enddte, Time.now.in_time_zone('UTC') ], :order => 'confirmed_at DESC')
  end 
  
  private
  
  def check_referred_case
    unless case_id.nil? || case_id.blank?
      aaa=StudentDisciplineCase.find(case_id)
      if aaa
         #errors.add(:base, I18n.t('student.counseling.removal_prohibited_case_still_exist'))
         return false
      else
        return true
      end
    end
  end
  
end

# == Schema Information
#
# Table name: student_counseling_sessions
#
#  alt_dates         :text
#  c_scope           :string(255)
#  c_type            :string(255)
#  case_id           :integer
#  confirmed_at      :datetime
#  confirmed_by      :integer
#  confirmed_by_type :string(255)
#  created_at        :datetime
#  created_by        :integer
#  created_by_type   :string(255)
#  duration          :integer
#  file_id           :integer
#  id                :integer          not null, primary key
#  is_confirmed      :boolean
#  issue_desc        :text
#  notes             :text
#  remark            :text
#  requested_at      :datetime
#  staff_id          :integer
#  student_id        :integer
#  suggestions       :text
#  updated_at        :datetime
#
