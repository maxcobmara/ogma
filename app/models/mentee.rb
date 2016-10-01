class Mentee < ActiveRecord::Base
  belongs_to :mentor, foreign_key: 'mentor_id'
  belongs_to :student, foreign_key: 'student_id'
end
