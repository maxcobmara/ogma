class Staff < ActiveRecord::Base
  
  has_one           :position
  
  
  has_attached_file :photo,
                    :url => "/assets/staffs/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/staffs/:id/:style/:basename.:extension"#, :styles => {:thumb => "40x60"}
                    
  has_many          :qualifications, :dependent => :destroy
  accepts_nested_attributes_for :qualifications, :allow_destroy => true, :reject_if => lambda { |a| a[:level_id].blank? }
  
  has_many          :loans, :dependent => :destroy
  accepts_nested_attributes_for :loans, :reject_if => lambda { |a| a[:ltype].blank? }
  
  has_many          :bankaccounts, :dependent => :destroy
  accepts_nested_attributes_for :bankaccounts, :reject_if => lambda { |a| a[:account_no].blank? }
  
  has_many          :kins, :dependent => :destroy
  accepts_nested_attributes_for :kins, :reject_if => lambda { |a| a[:kintype_id].blank? }
  
  
  belongs_to        :title,     :class_name => 'Title',     :foreign_key => 'titlecd_id'
  
  

  
  def render_reports_to
    if position.blank? 
      ""
    elsif position.parent.blank?
      "-"
    elsif position.parent.staff.blank?
      "#{position.parent.name}"
    else 
      "#{position.parent.name} - #{position.parent.staff.name}"
    end
  end
  
  #--------------------Declerations----------------------------------------------------
    def age
      Date.today.year - cobirthdt.year unless cobirthdt == nil
    end
 
    def formatted_mykad
      "#{icno[0,6]}-#{icno[6,2]}-#{icno[-4,4]}"
    end  

end