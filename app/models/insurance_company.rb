class InsuranceCompany < ActiveRecord::Base
  belongs_to :college
  has_many :insurance_policies
end
