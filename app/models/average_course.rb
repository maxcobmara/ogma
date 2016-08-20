class AverageCourse < ActiveRecord::Base
  belongs_to :lecturer, class_name: 'Staff', foreign_key: 'lecturer_id'
  belongs_to :verifier, class_name: 'Staff', foreign_key: 'principal_id'
  belongs_to :subject, class_name: 'Programme', foreign_key: 'subject_id'
       
  def self.avg_int(evs)
    evs_int=[]
    eval_count=evs.count
    evs_int << evs.sum(:ev_obj)/eval_count << evs.sum(:ev_knowledge)/eval_count << evs.sum(:ev_deliver)/eval_count << evs.sum(:ev_content)/eval_count << evs.sum(:ev_tool)/eval_count << evs.sum(:ev_topic)/eval_count << evs.sum(:ev_work)/eval_count << evs.sum(:ev_note)/eval_count << evs.sum(:ev_assessment)/eval_count
    evs_int
  end
  
  def self.avg_actual(evs)
    evs_act=[]
    eval_count_d=evs.count*1.0
    evs_act << evs.sum(:ev_obj)/eval_count_d << evs.sum(:ev_knowledge)/eval_count_d << evs.sum(:ev_deliver)/eval_count_d << evs.sum(:ev_content)/eval_count_d << evs.sum(:ev_tool)/eval_count_d << evs.sum(:ev_topic)/eval_count_d << evs.sum(:ev_work)/eval_count_d << evs.sum(:ev_note)/eval_count_d << evs.sum(:ev_assessment)/eval_count_d
    evs_act
  end
  
end