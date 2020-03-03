class Vehicle < ActiveRecord::Base
  
  before_destroy :travel_own_car_exist
  belongs_to :staffvehicle, :class_name => 'Staff', :foreign_key => 'staff_id'
  
  validates_presence_of :reg_no, :cylinder_capacity
  
  private
  
    def  travel_own_car_exist
      travellings_own_car = TravelRequest.find(:all, :conditions => ['staff_id=? and own_car=?', staff_id, true]).count
      if travellings_own_car > 0 
        return false
        #errors.add(:base, I18n.t('vehicles.is_not_removable'))
      else
        return true
      end
    end
    
end

# == Schema Information
#
# Table name: vehicles
#
#  cylinder_capacity :integer
#  id                :integer          not null, primary key
#  reg_no            :string(255)
#  staff_id          :integer
#  type_model        :string(255)
#
