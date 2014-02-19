class Staff < ActiveRecord::Base
  
  paginates_per 13
  
  has_one           :position
  has_many          :tenants
  
  
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
  
  
  belongs_to        :title,       :class_name => 'Title',       :foreign_key => 'titlecd_id'
  belongs_to        :staffgrade, :class_name => 'Employgrade',  :foreign_key => 'staffgrade_id'
  
  

  

  
  #--------------------Declerations----------------------------------------------------
    def age
      Date.today.year - cobirthdt.year unless cobirthdt == nil
    end
 
    def formatted_mykad
      "#{icno[0,6]}-#{icno[6,2]}-#{icno[-4,4]}"
    end
    
    def mykad_with_staff_name
      "#{formatted_mykad}  #{name}"
    end  
    

end