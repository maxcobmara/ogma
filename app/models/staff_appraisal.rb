class StaffAppraisal < ActiveRecord::Base
  
  before_validation :set_year_to_start
   before_save :set_to_nil_where_false, :set_number_of_questions, :when_ppp_is_ppk
  
  
   belongs_to :appraised,      :class_name => 'Staff', :foreign_key => 'staff_id'
   belongs_to :eval1_officer,  :class_name => 'Staff', :foreign_key => 'eval1_by'
   belongs_to :eval2_officer,  :class_name => 'Staff', :foreign_key => 'eval2_by'
  
   has_many :staff_appraisal_skts, :dependent => :destroy
   accepts_nested_attributes_for :staff_appraisal_skts, :allow_destroy => true, :reject_if => lambda { |a| a[:description].blank? }
  
   has_many :evactivities, :foreign_key => 'appraisal_id', :dependent => :destroy
   accepts_nested_attributes_for :evactivities, :allow_destroy => true, :reject_if => lambda { |a| a[:evactivity].blank? }
  
   has_many :trainneeds, :foreign_key => 'evaluation_id', :dependent => :destroy
   accepts_nested_attributes_for :trainneeds, :allow_destroy => true, :reject_if => lambda { |a| a[:name].blank? }
  
  
   validates_uniqueness_of :evaluation_year, :scope => :staff_id, :message => "Your evaluation for this year already exists"
  
  
   def evaluation_status
     if is_skt_submit != true
       "SKT being formulated"
     elsif is_complete == true
    		"Staff Appraisal complete"
     elsif is_skt_submit == true && is_skt_endorsed != true
       "SKT awaiting PPP endorsement"
     elsif is_skt_submit == true && is_skt_endorsed == true && is_skt_pyd_report_done != true
       "SKT Review"
     elsif is_skt_pyd_report_done == true && is_skt_ppp_report_done != true
       "Ready for PPP SKT Report"
     elsif is_skt_pyd_report_done == true && is_skt_ppp_report_done == true && is_submit_for_evaluation != true
       "PPP Report complete"
     elsif is_skt_ppp_report_done == true && is_submit_for_evaluation == true && is_submit_e2 != true
       "Submitted for Evaluation by PPP"
    	elsif is_submit_for_evaluation == true && is_submit_e2 == true
    	   "Submitted by PPP for Evaluation  to PPK"
     end
   end
 
end