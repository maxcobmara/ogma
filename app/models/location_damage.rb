class LocationDamage < ActiveRecord::Base
  belongs_to :location, :foreign_key => 'location_id'
end

# == Schema Information
#
# Table name: location_damages
#
#  college_id    :integer
#  created_at    :datetime
#  description   :string(255)
#  document_id   :integer
#  id            :integer          not null, primary key
#  inspection_on :date
#  location_id   :integer
#  repaired_on   :date
#  reported_on   :date
#  updated_at    :datetime
#  user_id       :integer
#
