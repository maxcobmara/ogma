class Mentor < ActiveRecord::Base
  belongs_to :staff, foreign_key: 'staff_id'
  has_many :mentees, :dependent => :destroy
  accepts_nested_attributes_for :mentees, :allow_destroy => true , :reject_if => lambda { |a| a[:student_id].blank? }
  validates :staff_id, :mentor_date, presence: true
end
