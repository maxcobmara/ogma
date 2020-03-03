class TravelClaimLog < ActiveRecord::Base
  belongs_to :travel_request
  after_save :update_mileage_travel_request
  
  validates_numericality_of :mileage,  :unless => proc{|obj| obj.mileage.blank?}
  validates_numericality_of :km_money, :unless => proc{|obj| obj.km_money.blank?}
  validates_presence_of :travel_on, :start_at, :finish_at
  validate :mileage_xor_km_money
  
  def update_mileage_travel_request
    travelq=TravelRequest.where(id: travel_request_id).first
    sum_mileage= TravelClaimLog.where(travel_request_id: travel_request_id).sum(:mileage)
    sum_km_money= TravelClaimLog.where(travel_request_id: travel_request_id).sum(:km_money)
    travelq.update(log_mileage: sum_mileage, log_fare: sum_km_money)
  end

    private

      def mileage_xor_km_money
        if !(mileage.blank? ^ km_money.blank?)
          #errors.add_to_base("Specify a mileage or a payment, not both")
	  errors.add(:travel_log, I18n.t('staff.travel_claim.mileage_xor_km_money'))
        end
      end
 
end

# == Schema Information
#
# Table name: travel_claim_logs
#
#  checker           :boolean
#  checker_notes     :string(255)
#  created_at        :datetime
#  destination       :string(255)
#  finish_at         :time
#  id                :integer          not null, primary key
#  km_money          :decimal(, )
#  mileage           :decimal(, )
#  start_at          :time
#  travel_on         :date
#  travel_request_id :integer
#  updated_at        :datetime
#
