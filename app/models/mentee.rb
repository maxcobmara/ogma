class Mentee < ActiveRecord::Base
  belongs_to :mentor, foreign_key: 'mentor_id'
  belongs_to :student, foreign_key: 'student_id'
  #validates :student_id, uniqueness: true
  
  def student_staff
    "<li>Mentee: <b>#{student.student_with_rank}</b><span style= 'font-size: 0.9em; color: grey;'> (Mentor: #{mentor.staff.staff_with_rank})</span></li>"
  end
end
