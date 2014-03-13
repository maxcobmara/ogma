class Kin < ActiveRecord::Base
  belongs_to :staff
  belongs_to :student
  
  KTYPE = [
          #  Displayed       stored in db
          [ "Isteri",1 ],
          [ "Suami",2 ],
          [ "Ibu", 3 ],
          [ "Bapa", 4 ],
          [ "Anak", 5 ],
          [ "Nenek", 9 ],
          [ "Saudara Kandung", 11 ],
          [ "Penjaga", 12 ],
          [ "Bekas Isteri", 13 ],
          [ "Bekas Suami", 14 ],
          [ "Penjamin I", 98 ],
          [ "Penjamin II", 99 ]
   ]
end

# == Schema Information
#
# Table name: kins
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  kinaddr    :string(255)
#  kinbirthdt :date
#  kintype_id :integer
#  mykadno    :string(255)
#  name       :string(255)
#  phone      :string(255)
#  profession :string(255)
#  staff_id   :integer
#  student_id :integer
#  updated_at :datetime
#
