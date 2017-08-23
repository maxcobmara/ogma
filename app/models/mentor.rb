class Mentor < ActiveRecord::Base
  belongs_to :college
  belongs_to :staff, foreign_key: 'staff_id'
  has_many :mentees, :dependent => :destroy
  accepts_nested_attributes_for :mentees, :allow_destroy => true , :reject_if => lambda { |a| a[:student_id].blank? }
  validates :staff_id, :mentor_date, presence: true
  validates :staff_id, uniqueness: true
  #validates_associated :mentees #effective for checking existing record only
  validate :mentees_must_uniq #temp
  
  private
    
    def mentees_must_uniq
      current_mentees=mentees.map(&:student_id)
      if (current_mentees.count!=current_mentees.uniq.count)
        b=""
        mentees.group_by(&:student).each{|stu, ms| b+= "<li>#{stu.student_with_rank} (#{I18n.t('selected')} #{ms.count} #{I18n.t('times')})</li>" if ms.count > 1}
        errors.add(:base, ("#{I18n.t('staff.mentors.redundant_mentees')}<ol>#{b}</ol>").html_safe)
      end
      
      existing=Mentee.where.not(mentor_id: id).pluck(:student_id)
      duplicates=current_mentees & existing
      if duplicates.count > 0
        str=Mentee.where(student_id: duplicates).map(&:student_staff).join
        errors.add(:base, ("#{I18n.t('staff.mentors.existing_mentees')}<ol>#{str}</ol>").html_safe)
      end
    end
    
end
