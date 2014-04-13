class LocationDamage < ActiveRecord::Base
  belongs_to :Location
end

# == Schema Information
#
# Table name: locations
#
#  allocatable    :boolean
#  ancestry       :string(255)
#  ancestry_depth :integer          default(0)
#  code           :string(255)
#  combo_code     :string(255)
#  created_at     :datetime
#  id             :integer          not null, primary key
#  lclass         :integer
#  name           :string(255)
#  occupied       :boolean
#  staffadmin_id  :integer
#  typename       :integer
#  updated_at     :datetime
#
