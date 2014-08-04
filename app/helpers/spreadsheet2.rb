module Spreadsheet2
  
   def self.open_spreadsheet(file) 
    case File.extname(file.original_filename) 
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore) 
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore) 
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore) 
      else raise "Unknown file type: #{file.original_filename}" 
    end
  end 
  
  #import staff attendance from excel - sheet name: 'CHECKINOUT'
  def self.update_attendance(spreadsheet)  
    spreadsheet.default_sheet = 'CHECKINOUT'
    header = spreadsheet.row(1) 
    year_exceed=0
    saved_recs=0
    exist_recs=0
    sa_exist=[]
    sa_ye=[]
    sa_recs=[]
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose] 
      le_date = row["checktime"].split(" ")[0].split("/")
      le_year = le_date[2].to_i
      le_month = le_date[1].to_i
      le_day = le_date[0].to_i
      le_time = row["checktime"].split(" ")[1].split(":")
      le_hour = le_time[0].to_i
      le_minute = le_time[1].to_i
      le_second = le_time[2].to_i
      if le_year>=Date.today.year-2
	  logged_excel = DateTime.new(le_year,le_month,le_day,le_hour,le_minute,le_second).strftime('%Y-%m-%d %H:%M:%S')
	  staff_attendance = StaffAttendance.where(thumb_id: row["userid"].to_i, logged_at: logged_excel).first || StaffAttendance.new
	  if staff_attendance.id.nil? || staff_attendance.id.blank?
	    staff_attendance.logged_at = logged_excel
	    staff_attendance.thumb_id = row["userid"].to_i    
	    staff_attendance.log_type = row["checktype"]
	    staff_attendance.save!
	    sa_recs << staff_attendance
	    saved_recs+=1
	  else
	    staff_attendance.attributes = row.to_hash.slice("userid","checktime","checktype")
	    sa_exist << staff_attendance
	    exist_recs+=1
	  end
      else
	  sa_yex=StaffAttendance.new
	  sa_yex.attributes = row.to_hash.slice("userid","checktime","checktype")
	  sa_ye << sa_yex
	  year_exceed+=1
      end
    end
    #result={:sa=>saved_recs, :ye=>year_exceed, :er=>exist_recs, :ser=>sa_exist, :sye=>sa_ye}
    result={:sas=>sa_recs, :ser=>sa_exist, :sye=>sa_ye}
  end  
  
  #import (update) thumb_id from excel - sheet name: 'USERINFO' 
  #retrieve userid (thumb_id), name, birthday
  def self.update_thumb_id(spreadsheet)
    userinfo_sheet = spreadsheet.sheet('USERINFO')
    header2 = userinfo_sheet.row(1)
    (2..userinfo_sheet.last_row).each do |j|
      row2 = Hash[[header2, userinfo_sheet.row(j)].transpose] 
      thumbid_excel = row2["userid"].to_i
      name_excel = row2["name"].lstrip
      b_excel = row2["birthday"].split(" ")[0].split("/")
      birthday_excel = b_excel[2][2,2].to_s+b_excel[1].to_s+b_excel[0].to_s
      staff = Staff.where('thumb_id is null and name ILIKE ?', "%#{name_excel}%").first
      if staff.nil? == false 
	staff_birthday = staff.icno[0,6].to_s
	if birthday_excel == staff_birthday
	  staff.thumb_id = thumbid_excel
	  staff.save!
	end
      end
    end
  end
  
  #messages for import excel (success & failed)		{:sas=>sa_recs, :ser=>sa_exist, :sye=>sa_ye}
  def self.msg_import(a)
    msg=""    
    msg+=a[:sas].count.to_s+(I18n.t 'actions.records')+(I18n.t 'actions.imported') if a[:sas].count>0
    msg+=a[:ser].count.to_s+(I18n.t 'actions.records')+(I18n.t 'actions.import_failed')+(I18n.t 'staff_attendance.exist_records') if a[:ser].count>0
    if (a[:sas].count>0 && a[:sye].count>0) || (a[:ser].count>0 && a[:sye].count>0)
      msg+=(I18n.t 'staff_attendance.and')
    end
    msg+=a[:sye].count.to_s+(I18n.t 'actions.records')+(I18n.t 'actions.import_failed')+(I18n.t 'staff_attendance.year_exceed')+"#{Date.today.year-2}-#{Date.today.year})" if a[:sye].count>0
    msg  
  end
  
end
