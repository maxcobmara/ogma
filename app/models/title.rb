class Title < ActiveRecord::Base
  has_many :staffs
  validates :titlecode, :name, presence: true
end

# == Schema Information
#
# Table name: titles
#
#  berhormat  :boolean
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  titlecode  :string(255)
#  updated_at :datetime
#
