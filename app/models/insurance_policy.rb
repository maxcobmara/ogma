class InsurancePolicy < ActiveRecord::Base
  belongs_to :staff
  belongs_to :insurance_company, foreign_key: 'company_id'
  
  def render_insurance_type
    ((DropDown::HAYAT_TYPE+DropDown::AM_TYPE).find_all{|disp, value| value == insurance_type }).map {|disp, value| disp}[0]
  end
end
