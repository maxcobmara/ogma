class Login < ActiveRecord::Base         
  belongs_to :staff   
  has_and_belongs_to_many :roles   
end

# == Schema Information
#
# Table name: logins
#
#  created_at                :datetime
#  crypted_password          :string(40)
#  email                     :string(100)
#  icno                      :string(255)
#  id                        :integer          not null, primary key
#  isstaff                   :boolean
#  login                     :string(40)
#  name                      :string(100)      default("")
#  remember_token            :string(40)
#  remember_token_expires_at :datetime
#  salt                      :string(40)
#  staff_id                  :integer
#  student_id                :integer
#  updated_at                :datetime
#
