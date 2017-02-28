class InsurancePolicy < ActiveRecord::Base
  belongs_to :staff
  belongs_to :insurance_company, foreign_key: 'company_id'
  
  attr_accessor :insurance_main_type
end
