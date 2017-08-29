class Fingerprint < ActiveRecord::Base
  belongs_to :owner, :class_name => 'Staff', :foreign_key => 'thumb_id', :primary_key => 'thumb_id'
  belongs_to :approver, :class_name => 'Staff', :foreign_key => 'approved_by'
  belongs_to :college
  
  validates_presence_of :thumb_id, :fdate, :ftype
  validates_presence_of :reason, :status, :if => :ftype_exist?
  validates_uniqueness_of :fdate, :scope => :thumb_id, :message => I18n.t('fingerprint.statement_exist')
  validate :valid_fdate?
  
  def valid_fdate?
    daystart=fdate.to_time.beginning_of_day
    dayend=fdate.to_time.end_of_day
    exist_log_ins=StaffAttendance.where('logged_at >=? and logged_at <? and thumb_id=?', daystart, dayend, thumb_id).where('log_type=? or log_type=?', 'I', 'i').count
    exist_log_outs=StaffAttendance.where('logged_at >=? and logged_at <? and thumb_id=?', daystart, dayend, thumb_id).where('log_type=? or log_type=?', 'O', 'o').count
    if exist_log_ins > 0 && exist_log_outs > 0
      errors.add(:fdate, I18n.t('fingerprint.logrecord_exist'))
    end
  end
  
  def ftype_exist?
    ftype.nil? == false
  end
  
  def type_val(current_user)
    if ftype.nil?
      fdate_start=fdate.to_time.beginning_of_day
      fdate_end=fdate.to_time.end_of_day
      sa_rec_in = StaffAttendance.where('logged_at>=? and logged_at<=?', fdate_start, fdate_end).where('log_type=? or log_type=?', 'I','i').where(thumb_id: current_user.userable.thumb_id)
      sa_rec_out = StaffAttendance.where('logged_at>=? and logged_at<=?', fdate_start, fdate_end).where('log_type=? or log_type=?', 'O','o').where(thumb_id:     current_user.userable.thumb_id)
      if sa_rec_in.count==0 && sa_rec_out.count==0
        type=3
      else
        if sa_rec_in.count > 0 && sa_rec_out.count==0
          type=2
        elsif sa_rec_out.count > 0 && sa_rec_in.count==0
          type=1
        end
      end
      type_value=(DropDown::FINGERPRINT_TYPE.find_all{|disp, value| value == type}).map {|disp, value| disp}[0]
    else
      type_value=(DropDown::FINGERPRINT_TYPE.find_all{|disp, value| value == ftype}).map {|disp, value| disp}[0] 
    end
    type #type_value
  end
  
  def self.find_mystatement(thumbid)
    where(thumb_id: thumbid)
  end
   def self.find_approvestatement(current_user)
    all.where("thumb_id IN (?)", StaffAttendance.peeps(current_user)).order(fdate: :desc)
  end
  
  def exception_details
    f_type="IN : " if ftype==1
    f_type="OUT : " if ftype==2
    f_type="IN & OUT : " if ftype==3
    if is_approved==true
      a=f_type+(DropDown::TRIGGER_STATUS.find_all{|disp, value| value == status}).map {|disp, value| disp}[0]+"-"+reason
    else
      a=f_type+""
    end
    a
  end
  
end
