class Bank < ActiveRecord::Base
  has_many :bankaccounts
  belongs_to :college
  validates_uniqueness_of :long_name
end

# == Schema Information
#
# Table name: banks
#
#  active     :boolean
#  created_at :datetime
#  id         :integer          not null, primary key
#  long_name  :string(255)
#  short_name :string(255)
#  updated_at :datetime
#
