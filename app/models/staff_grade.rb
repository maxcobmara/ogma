class StaffGrade < ActiveRecord::Base
    has_many  :positions
end

# == Schema Information
#
# Table name: staff_grades
#
#  classification_id :string(255)
#  created_at        :datetime
#  grade             :string(255)
#  group_id          :string(255)
#  id                :integer          not null, primary key
#  level             :integer
#  name              :string(255)
#  schemename        :string(255)
#  updated_at        :datetime
#
