class Trainneed < ActiveRecord::Base
   belongs_to :staff_appraisal
end

# == Schema Information
#
# Table name: trainneeds
#
#  confirmedby_id :integer
#  created_at     :datetime
#  evaluation_id  :integer
#  id             :integer          not null, primary key
#  name           :string(255)
#  reason         :string(255)
#  updated_at     :datetime
#
