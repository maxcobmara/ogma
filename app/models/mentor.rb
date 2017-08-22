class Mentor < ActiveRecord::Base
  belongs_to :staff, foreign_key: 'staff_id'
  has_many :mentees, :dependent => :destroy
  accepts_nested_attributes_for :mentees, :allow_destroy => true , :reject_if => lambda { |a| a[:student_id].blank? }
  validates :staff_id, :mentor_date, presence: true
  validates :staff_id, uniqueness: true
  #validates_associated :mentees #effective for checking existing record only
  validate :mentees_must_uniq #temp
  
  private
    
    def mentees_must_uniq
      #exist 
      a=[]
      exist_mentees=Mentee.where.not(mentor_id: id).pluck(:student_id)
      mentees.map(&:student_id).each{|m| a << "<b>Mentor</b>: #{Mentee.where(student_id: m).first.mentor.staff.staff_with_rank}, <b>Mentee</b>: <u>#{Student.find(m).student_with_rank}</u>" if exist_mentees.include?(m)}
      if a.count > 0
        a_list=a.join("<br>- ")
        errors.add(:base, ("#{I18n.t('staff.mentors.existing_mentees') }<br>- #{a_list}").html_safe)
      end
      #current
      if (mentees.map(&:student_id).count!=mentees.map(&:student_id).uniq.count)
	b=[]
	mentees.group_by(&:student_id).each do |stuid, ms|
	  b << stuid if ms.count > 1
	end
	b_list=b.join("<br>- ")
        errors.add(:base, ("#{I18n.t('staff.mentors.redundant_mentees')} <br>- #{b_list}").html_safe)
      end
    end
    
end
