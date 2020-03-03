class Role < ActiveRecord::Base
  has_and_belongs_to_many :logins #:users
  
  before_save  :underscore_name
  
  has_and_belongs_to_many :users
  
  def underscore_name
    self.authname = name.parameterize.underscore
  end
end

# == Schema Information
#
# Table name: roles
#
#  authname    :string(255)
#  created_at  :datetime
#  description :string(255)
#  id          :integer          not null, primary key
#  name        :string(255)
#  updated_at  :datetime
#
