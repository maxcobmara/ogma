class Title < ActiveRecord::Base
  has_many :staffs
  has_many :visitors
  belongs_to :college
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
