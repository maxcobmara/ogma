class TravelClaimMileageRate < ActiveRecord::Base
  
  def self.km_by_group(km, group)
    if group == 'A'
      where(km_high: km).first.a_group
    elsif group == 'B'
      where(km_high: km).first.b_group
    elsif group == 'C'
      where(km_high: km).first.c_group
    elsif group == 'D'
      where(km_high: km).first.d_group
    elsif group == 'E'
      where(km_high: km).first.e_group  
    end
  end
  
end

# == Schema Information
#
# Table name: travel_claim_mileage_rates
#
#  a_group    :decimal(4, 2)
#  b_group    :decimal(4, 2)
#  c_group    :decimal(4, 2)
#  created_at :datetime
#  d_group    :decimal(4, 2)
#  e_group    :decimal(4, 2)
#  id         :integer          not null, primary key
#  km_high    :integer
#  km_low     :integer
#  updated_at :datetime
#
