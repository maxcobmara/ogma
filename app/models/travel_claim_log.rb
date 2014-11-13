class TravelClaimLog < ActiveRecord::Base
  belongs_to :travel_request
  
  validates_numericality_of :mileage,  :unless => proc{|obj| obj.mileage.blank?}
  validates_numericality_of :km_money, :unless => proc{|obj| obj.km_money.blank?}
  validates_presence_of :travel_on, :start_at, :finish_at
  validate :mileage_xor_km_money

    private

      def mileage_xor_km_money
        if !(mileage.blank? ^ km_money.blank?)
          #errors.add_to_base("Specify a mileage or a payment, not both")
	  errors.add(": Mileage or Payment,", "specify one")
        end
      end
 
end
