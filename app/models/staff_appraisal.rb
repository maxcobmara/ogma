class StaffAppraisal < ActiveRecord::Base
 before_validation :set_year_to_start  
 
 belongs_to :appraised,      :class_name => 'Staff', :foreign_key => 'staff_id'
 
 def set_year_to_start
   self.evaluation_year = evaluation_year.at_beginning_of_year
 end
 
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