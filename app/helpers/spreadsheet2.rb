module Spreadsheet2
  
   def self.open_spreadsheet(file) 
    case File.extname(file.original_filename) 
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore) 
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore) 
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore) 
      else raise "Unknown file type: #{file.original_filename}" 
    end
  end 
  
  #import staff attendance from excel - sheet name: 'CHECKINOUT' (userid, checktime, checktype)
  def self.update_attendance(spreadsheet)  
    spreadsheet.default_sheet = 'CHECKINOUT'
    header = spreadsheet.row(1) 
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
	  else
	    staff_attendance.attributes = row.to_hash.slice("userid","checktime","checktype")
	    sa_exist << staff_attendance
	  end
      else
	  sa_yex=StaffAttendance.new
	  sa_yex.attributes = row.to_hash.slice("userid","checktime","checktype")
	  sa_ye << sa_yex
      end
    end
    result={:sas=>sa_recs, :ser=>sa_exist, :sye=>sa_ye}
  end  
  
  #import (update) thumb_id from excel & collect staff_id & dept_id - sheet name: 'USERINFO' (userid, name, birthday, defaultdeptid)
  def self.update_thumb_id(spreadsheet)
    userinfo_sheet = spreadsheet.sheet('USERINFO')
    header2 = userinfo_sheet.row(1)
    stf_dept=Hash.new
    (2..userinfo_sheet.last_row).each do |j|
      row2 = Hash[[header2, userinfo_sheet.row(j)].transpose] 
      thumbid_excel = row2["userid"].to_i
      name_excel = row2["name"].lstrip
      unless (row2["birthday"].nil? || row2["birthday"].blank? || row2["birthday"]=="")
	b_excel = row2["birthday"].split(" ")[0].split("/")
	birthday_excel = b_excel[2][2,2].to_s+b_excel[1].to_s+b_excel[0].to_s
      end
      dept_excel = row2["defaultdeptid"].to_i
      
      #insert thumb_id for staff with no thumb_id 
      staff_nothumb = Staff.where('thumb_id is null and name ILIKE ?', "%#{name_excel}%").first		
      if staff_nothumb.nil? == false && birthday_excel
	staff_birthday = staff_nothumb.icno[0,6].to_s
	if birthday_excel == staff_birthday
	  staff_nothumb.thumb_id = thumbid_excel
	  staff_nothumb.save!
	end
      end
      
      #collect ids for all staff (as excel but must also exist in positions table)
      staff = Staff.where('name ILIKE ?',"%#{name_excel}%").first
      staffs = Staff.where('name ILIKE ?',"%#{name_excel.split(" ")[0]}%")
      if staff.nil? == false 
	if birthday_excel
	  staff_birthday = staff.icno[0,6].to_s
	  if birthday_excel == staff_birthday
	    stf_dept[staff.id]=dept_excel
	  end
	else
	  if thumbid_excel && staff.thumb_id
	    stf_dept[staff.id]=dept_excel if thumbid_excel == staff.thumb_id
	  end
	end
      else
		
	if staffs && staffs.count>0
	    staffs.each do |st|
		if birthday_excel
		    st_birthday =st.icno[0,6].to_s
		    if birthday_excel == st_birthday
		      stf_dept[st.id]=dept_excel
		    end
		end
	    end
	end
	      
      end
    end	#end for (2..userinfo_s...
    stf_dept
  end
  
  #load dept from excel - sheet name: 'DEPARTMENTS' (deptid,deptname)
  def self.load_dept(spreadsheet)
    department_sheet = spreadsheet.sheet('DEPARTMENTS')
    header3 = department_sheet.row(1)
    dept = Hash.new
    (2..department_sheet.last_row).each do |k|
      row3 = Hash[[header3, department_sheet.row(k)].transpose] 
      deptid = row3["deptid"].to_i
      deptname = row3["deptname"].lstrip
      dept[deptid]=deptname
    end
    dept
  end
  
  #messages for import excel (success & failed)
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
  
  
  # Compare, MATCH dept fr excel & update unit in positions
  def self.match_dept_unit(staffdept,deptlist)							#deptlist = {1: "KSKB", 2: "Pengurusan Pentadbiran"}
    unit_names = StaffAttendance.get_thumb_ids_unit_names(2) 						#["Perhotelan", "Pentadbiran ", "Teknologi Maklumat", "Perpustakaan".....]    
    staffdept.each do |k,v|											#k is staff_id, v is dept_id
      spost=Position.where(staff_id: k).order('combo_code ASC').first		#retrieve higher position for those with multiple positions
      if spost && deptlist[v]=="Pengurusan Tertinggi"					#==Pengurusan Tertinggi
	 spost.unit=deptlist[v]										#should override all other unit terms for all "Timbalan... & Pengarah"
	 spost.save!
      end
	
      if spost && (spost.unit==nil || spost.unit=="" )
	if unit_names.include?(deptlist[v])								#ok for same unit (name) & dept (name)
	  #if spost.id==407 (same record as below)						#except - position for Kaunter : Pegawai Khidmat Pelanggan (Butiran : 579)
	  if spost.postinfo_id==43 									#exclusion for Kaunter (in excel dept='Pentadbiran Am' for Peg Khidmat Pelanggan)
	    spost.unit = "Kaunter"
	  else
	    unless deptlist[v]=="Pengurusan Tertinggi"					#avoid redundant assignment for Pengurusan Tertinggi
	      spost.unit = deptlist[v]
	      #In contrast with 'Pengurusan Tertinggi', at least 1 position for each unit(below) must exist first, for above data assignment to be applied :
	      #(Same UNIT terms exist on both POSITIONs table & EXCEL file)
	      #Kejuruteraan 
	      #Anatomi & Fisiologi 										#Common Subject
	      #Sains Tingkahlaku										#Common Subject
	    end
	  end
	else
	  
	  #unit_names = ["Perhotelan", "Pengurusan Tertinggi", "Teknologi Maklumat", "Perpustakaan", "Perkhidmatan", "Kaunter", "Kewangan & Stor", "Jurupulih Perubatan Cara Kerja", "Perawatan Koronari", "Pos Basik", "Radiografi", "Kebidanan", "Penolong Pegawai Perubatan", "Perioperating", "Jurupulih Perubatan Anggota (Fisioterapi)", "Pentadbiran Am", "Sains Perubatan Asas", "Komunikasi & Sains Pengurusan", "Kejururawatan"] 
	  
	  ####dept name in EXCEL did not really match unit in POSITIONS table####
	  
	  #deptlist = {1: "KSKB", 2: "Pengurusan Pentadbiran", 3: "Sumber Manusia", 4: "Akademik", 5: "Kejururawatan", 6: "Radiografi", 7: "Jurupulih Carakerja", 8: "Jurupulih Anggota", 9: "Klinikal Jururawat", 10: "Pentadbiran Am", 11: "Aset & Stor", 13: "Teknologi Maklumat", 14: "Asrama", 15: "Kenderaan", 17: "Pusat Sumber", 18: "Kewangan", 19: "Kontraktor", 20: "Bertukar/Pencen", 21: "Sains Perubatan Asa", 22: "Anatomi & Fisiologi", 23: "Sains Tingkahlaku", 24: "Sains Komunikasi & Pengurusan",25: "Pengkhususan", 27: "Pegawai Perubatan", 28: "Kejuruteraan", 31: "Hal Ehwal Pelatih", 32: "Diswastakan / Logistik", 33: "Pengurusan Tertinggi"}
	  
	  #Note : unit in POSITIONs must MATCH with Programme (NAME)
	  #Pos Basik --> Ketua Program Pos Basik
	  
	  #hafiza, syazwani - sumber manusia? - wrong data found in Excel (thumbprint)
	  
	  if deptlist[v]=="Asrama"
	    spost.unit=="Perhotelan"
	  elsif deptlist[v]=="Pusat Sumber"
	    spost.unit=="Perpustakaan"
	  elsif deptlist[v]=="Aset & Stor" || deptlist[v]=="Kewangan"
	    spost.unit=="Kewangan & Stor"
	  elsif deptlist[v]=="Pengkhususan"
	    spost.unit=="Pos Basik" #or Pengkhususan 
	    #but Pos Basik individual names required (as below) - in POSITIONs table (add-in Pos Basik name into tasks_main column via Task & Reponsibilities)
	    #.....Kebidanan/Perawatan Rapi/Perawatan Onkologi/Perawatan Renal/Perioperating/Perawatan Psikiatri/Perawatan Koronari/Pengimejan Perubatan(Pengimejan Payudara)/Perawatan Pediatrik/Perawatan Komuniti
	  elsif deptlist[v]=="Sains Perubatan Asa"
	    spost.unit=="Sains Perubatan Asas" 							#Commonsubject
	  elsif deptlist[v]=="Sains Komunikasi & Pengurusan"
	    spost.unit=="Komunikasi & Sains Pengurusan"					#Commonsubject
	  elsif deptlist[v]=="Pegawai Perubatan"
	    spost.unit=="Penolong Pegawai Perubatan"
	  elsif deptlist[v]=="Jurupulih Carakerja"
	    spost.unit=="Jurupulih Perubatan Cara Kerja"
	  elsif deptlist[v]=="Jurupulih Anggota"
	    spost.unit=="Jurupulih Perubatan Anggota (Fisioterapi)"
	  elsif deptlist[v]=="Kenderaan"
	    spost.unit=="Unit Pengangkutan"
	  end
	  
	  #Perkhidmatan==	(no matching in excel, staff groupped in Pentadbiran Am)
	  #==Klinikal Jururawat	(no matching in positions table/org chart)
	  #==Hal Ehwal Pelatih
	  #==Kontraktor
	  #==Bertukar/Pencen
	  #==DIswastakan / Logistik
	  
	end #end for if include
	spost.save!	
      elsif spost && (spost.unit!=nil || spost.unit!="" ) && deptlist[v]=="Pengkhususan"
	exist_unit = spost.unit										#retrieve existing unit
	exist_main_tasks = spost.tasks_main							#retrieve existing main tasks
	spost.unit = "Pos Basik"
	spost.tasks_main = exist_unit + exist_main_tasks
	spost.save!
      end	#end for if spost exist      
    end	#end for staffdept
  end 
 
  
end
