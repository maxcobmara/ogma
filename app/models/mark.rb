class Mark < ActiveRecord::Base
  belongs_to :exammark
end

# == Schema Information
#
# Table name: marks
#
#  created_at   :datetime
#  exammark_id  :integer
#  id           :integer          not null, primary key
#  student_mark :decimal(, )
#  updated_at   :datetime
#
