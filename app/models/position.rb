class Position < ActiveRecord::Base
  
  before_save :set_combo_code, :titleize_name, :set_staff_if_staff_id2_exist
  has_ancestry :cache_depth => true
  
  validates_uniqueness_of :combo_code
  validates_presence_of   :name
  
  belongs_to :staff, :foreign_key => 'staff_id'
  belongs_to :staffgrade, :class_name => 'Employgrade', :foreign_key => 'staffgrade_id'
  belongs_to :postinfo
  
  attr_accessor :staff_id2
  
  def set_staff_if_staff_id2_exist
    unless staff_id2.blank?
      self.staff_id=staff_id2 if staff_id.blank? || staff_id!=staff_id2
    end
     unless staff_id.blank?
      self.staff_id=staff_id if staff_id2.blank? 
     end
  end
  
  def titleize_name
    self.name = name.titleize
  end
  
  def set_combo_code
    if ancestry_depth == 0
      self.combo_code = code
    else
      self.combo_code = parent.combo_code + "-" + code
    end
  end
  
  #PDF & Exel section  
  def totalpost
    unless postinfo_id.blank?
      a=Position.where('postinfo_id=?', postinfo_id).order(combo_code: :asc)[0].id
      if self.id==a
        aa="#{postinfo.post_count}"
      else
        aa=""
      end
      return aa
    else
      return "-"
    end
  end
  
  def totalpost2
    if totalpost==""
      return nil
    else
      return totalpost
    end
  end
  
  def butiran_details
    unless totalpost=="-" 
      b="#{postinfo.details}" if totalpost!=""
    else
      b="-"
    end
    b    
  end
  
  def occupied_post
    unless totalpost=="-" 
      b="#{Position.where('postinfo_id=? AND staff_id IS NOT NULL',postinfo_id).count}" if totalpost!=""
    else
      b="-"
    end
    b
  end
  
  def available_post          #@positions2.concat(positions_by_grade_wo_butiran.sort_by{|x|[x.staffgrade_id, x.staff.name]})
    unless totalpost=="-" 
      b="#{totalpost.to_i-occupied_post.to_i}" if totalpost!=""
    else
      b="-" 
    end
    b
  end
  
  def hakiki
    unless totalpost=="-" 
      b="#{Position.where('postinfo_id=? AND status=? AND staff_id IS NOT NULL',postinfo_id, 1).count }" if totalpost!=""
    else          #@positions2.concat(positions_by_grade_wo_butiran.sort_by{|x|[x.staffgrade_id, x.staff.name]})

      b="-"
    end
    b
  end
  
  def kontrak
    unless totalpost=="-" 
      b="#{Position.where('postinfo_id=? AND status=? AND staff_id IS NOT NULL',postinfo_id, 2).count}" if totalpost!=""
    else
      b="-" 
    end
    b
  end
  
  def kup
    unless totalpost=="-" 
      b="#{Position.where('postinfo_id=? AND status=? AND staff_id IS NOT NULL',postinfo_id, 3).count}" if totalpost!=""
    else
      b="-" 
    end
    b
  end
  
  #Export Excel (maklumat_perjawatan_excel) start
  def self.to_csv(options = {})
    
    CSV.generate(options) do |csv|
        @positions=[]
        all.group_by{|x|x.staffgrade.name.scan(/[a-zA-Z]+|[0-9]+/)[1].to_i}.sort.reverse!.each do |staffgrade2, positions_of_grade_no|
          positions_of_grade_no.group_by{|x|x.staffgrade.name.scan(/[a-zA-Z]+|[0-9]+/)[0]}.sort.reverse!.each do |staffgrade, positions_by_grade|
            positions_by_grade_w_butiran=[]
            positions_by_grade_wo_butiran=[]
            positions_by_grade.each do |position|
              unless position.postinfo_id.blank? 
                positions_by_grade_w_butiran<< position
              else 
                positions_by_grade_wo_butiran<< position 
              end
            end 
            @positions.concat(positions_by_grade_w_butiran.sort_by{|x|[x.staffgrade_id, -(x.postinfo.details[0,3].to_i), x.combo_code]})
            @positions.concat(positions_by_grade_wo_butiran.sort_by{|x|[x.staffgrade_id, x.combo_code]})
          end
        end
	csv << [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "LAMPIRAN A"]
        csv << ["MAKLUMAT PERJAWATAN DI KOLEJ-KOLEJ LATIHAN"]
        csv << ["KEMENTERIAN KESIHATAN MALAYSIA"]
        csv << ["SEHINGGA #{I18n.l((Position.all.order(updated_at: :desc).pluck(:updated_at).first), format: '%d-%m-%Y')}"]
        csv << [] #blank row added
        csv << ["KOLEJ : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU"]
        csv << [] #blank row added
        csv <<  [ "BIL", "BUT.","JAWATAN", "GRED", "JUM JWT","ISI",nil, "STATUS PENGISIAN", nil,"KSG", "NAMA PENYANDANG", "NO. K/P / PASSPORT", "JANTINA (L/P)", "BIDANG KEPAKARAN/SUB-KEPAKARAN","TARIKH WARTA PAKAR", "PENEMPATAN","PINJAM KE", nil, "PINJAM DARI", nil, "CATATAN"]
        csv << [nil,nil,nil,nil,nil,nil,"HAKIKI", "KONTRAK", "KUP",nil,nil,nil,nil,nil,nil,nil, "Akt.","Penempatan", "Akt.", "Penempatan", "*" ]
        csv << [] #blank row added
        
        counter =counter || 0
        @positions.each do |position|
            csv << ["#{counter += 1}", position.butiran_details, position.name, position.try(:staffgrade).try(:name), position.totalpost2, position.occupied_post,   position.hakiki, position.kontrak, position.kup, position.available_post ,position.try(:staff).try(:name), position.try(:staff).try(:icno),"#{'L' if position.try(:staff).try(:gender)==1} #{'P' if position.try(:staff).try(:gender)==2}","","","","","","","",""]
         end    
    end
    
  end
  #Export Excel - end
  
  #Use in STAFF ATTENDANCE report (unit / department drop down list - for all types of attendance report/listing) - START 
  #- rev26June2015 - to match with Index page (search part)
  def self.unit_department
    #academic part
    postbasics=['Pengkhususan', 'Pos Basik', 'Diploma Lanjutan']
    dip_prog=Programme.roots.where(course_type: 'Diploma').pluck(:name)
    post_prog=Programme.roots.where(course_type: postbasics).pluck(:name)
    post_prog2=Programme.roots.where(course_type: postbasics).pluck(:name) #.map(&:programme_list)
    commonsubject=Programme.where(course_type: 'Commonsubject').pluck(:name).uniq
    #temp-rescue - make sure this 2 included in Programmes table @ production svr as commonsubject type
    etc_subject=['Sains Tingkahlaku', 'Anatomi & Fisiologi']
            
    #management part
    mgmt_units= Position.where('staff_id is not null and unit is not null and unit!=? and unit not in (?) and unit not in (?) and unit not in (?) and unit not in (?)', '', dip_prog, commonsubject, postbasics, etc_subject).pluck(:unit).uniq
            
    #combine
    udept=[]
    mgmt_units.each do |u|
      udept << [u.strip, u.strip]
    end
    udept.sort!
    udept << ['---------------------Diploma--------------------------------------', 0]
    dip_prog.sort.each do |d|
      udept << [d.strip, d.strip]
    end
    udept << ['---Diploma Lanjutan/Posbasik/Pengkhususan---', 0]
    post_prog2.sort.each do |p2|
      udept << [p2.strip, p2.strip]
    end
    udept << ['---------------------Subjek Asas--------------------------------', 0]
    (commonsubject+etc_subject).sort.each do |s|
      udept << [s.strip, s.strip]
    end
    udept
  end
  
  def self.unit_department2
    unitname_fr_staff_attendances=StaffAttendance.get_thumb_ids_unit_names(4)
    udept=[]
    unitname_fr_staff_attendances.each do |ud|
      udept << [ud, ud]
    end
    udept.sort
  end
  #Use in STAFF ATTENDANCE report (unit / department drop down list - for all types of attendance report/listing) - END
  
  #use in Staff Attendance (self.peeps)
  def self.am_i_leader(userableid)   #(curr_user) - userable==staff   
    curr_user=User.where(userable_id: userableid).first
    staff_roles=curr_user.roles.map(&:authname)
    if staff_roles.include?("unit_leader") || staff_roles.include?("programme_manager")
      leader_status=true 
    else
      leader_status=false
    end
    leader_status
  end
  
  #Use in Weeklytimetable to retrieve Unit Leader
  #Use in STAFF ATTENDANCE report - #define Unit Leader /  Programme Mgr by highest staff grade / rank within unit
  def self.unit_department_leader(unit_dept)
    if ["Kejuruteraan", "Pentadbiran Am", "Perhotelan", "Aset & Stor", "Asrama"].include?(unit_dept) #asrama previously known as perhotelan
      sid = Position.where('unit=?', "Pentadbiran").try(:first).try(:staff_id)
      sid = Position.where(unit: unit_dept).first.parent.staff_id if sid.nil?
      leader=Staff.find(sid)
    else
      #works for all Diploma(Ketua Progam xxxx), Pos Basik/Pengkhususan/Dip Lanjutan(Ketua Program PENGKHUSUSAN), all Commonsubject(Ketua Subjek xxxx)
      #for members with same staffgrade - first occurance
      #check roles as "Programme Manager" if first occurance fails
      unit_members=Position.joins(:staff).where('unit=? and positions.name!=?', unit_dept, "ICMS Vendor Admin").order(ancestry_depth: :asc)
      highest_rank = unit_members.sort_by{|x|x.staffgrade.name[-2,2]}.last
      leader=Staff.find(highest_rank.staff_id)
      #if leader.nil?
      #  members_staffid=unit_members.pluck(:staff_id)
      #  mstaffid_w_kp_role=  User.joins(:roles).where('roles.authname=? and userable_id IN(?)', "programme_manager", members_staffid).first.pluck(:userable_id)
      #  leader=Staff.find(mstaffid_w_kp_role) if mstaffid_w_kp_role
      #end
    end
    leader
  end
  
  #Use in STAFF ATTENDANCE report (staff drop down list [upon selection of unit / department]- for monthly attendance listing) - START 
  #- rev26June2015 - to match with Index page (search part)
  def self.unit_department_staffs
    #academic part
    postbasics=['Pengkhususan', 'Pos Basik', 'Diploma Lanjutan']
    dip_prog=Programme.roots.where(course_type: 'Diploma').pluck(:name)
    post_prog=Programme.roots.where(course_type: postbasics).pluck(:name)
    commonsubject=Programme.where(course_type: 'Commonsubject').pluck(:name).uniq
    #temp-rescue - make sure this 2 included in Programmes table @ production svr
    etc_subject=['Sains Tingkahlaku', 'Anatomi & Fisiologi']
            
    #management part
    mgmt_units= Position.joins(:staff).where('positions.staff_id is not null and staffs.thumb_id is not null and unit is not null and unit!=? and unit not in (?) and unit not in (?) and unit not in (?) and unit not in (?) and positions.name!=?', '', dip_prog, commonsubject, postbasics, etc_subject, "ICMS Vendor Admin").group_by(&:unit)

    #academic part
    diploma_depts=Position.joins(:staff).where('positions.staff_id is not null and staffs.thumb_id is not null and unit in(?)', dip_prog).group_by(&:unit)
    
    @grouped_staff = []
    mgmt_units.sort.each do |unit_name, posts|
      @staffs_of_unit=[]
      posts.sort_by{|x|x.staff.name}.each do |pp|
        @staffs_of_unit << [pp.staff.name, pp.staff_id]
      end
      @grouped_staff << [unit_name.lstrip, @staffs_of_unit]
    end
    diploma_depts.sort.each do |unit_name, posts|
      @staffs_of_unit=[]
      posts.sort_by{|x|x.staff.name}.each do |pp|
        @staffs_of_unit << [pp.staff.name, pp.staff_id]
      end
      @grouped_staff << [unit_name.lstrip, @staffs_of_unit]
    end
    post_prog.sort.each do |posbasik|
      posts= Position.joins(:staff).where('positions.staff_id is not null and staffs.thumb_id is not null and unit in(?) and tasks_main ILIKE(?)', postbasics, "%#{posbasik}%")
      @staffs_of_unit=[]
      posts.sort_by{|x|x.staff.name}.each do |pp|
        @staffs_of_unit << [pp.staff.name, pp.staff_id]
      end
      @grouped_staff << [posbasik, @staffs_of_unit]
    end
    (commonsubject+etc_subject).each do |csubject|
      posts= Position.joins(:staff).where('positions.staff_id is not null and staffs.thumb_id is not null and unit=?', csubject)
      @staffs_of_unit=[]
      posts.sort_by{|x|x.staff.name}.each do |pp|
        @staffs_of_unit << [pp.staff.name, pp.staff_id]
      end
      @grouped_staff << [csubject, @staffs_of_unit]
    end
    @grouped_staff
  end
  
  def self.unit_department_staffs2
     StaffAttendance.get_thumb_ids_unit_names(5).sort
  end
  #Use in STAFF ATTENDANCE report (staff drop down list [upon selection of unit / department]- for monthly attendance listing) - END
    
  #use in Weeklytimetables_controller.rb (Index - retrieve Programme ID for Pos Basik/Pengkhususan/Diploma Lanjutan) - START
  def self.get_postbasic_id(main_task_first, unit_name)
    #postbasic_name_full = main_task_first[/Diploma Lanjutan \D{1,}/] 
    #a=@position_exist.first.main_tasks.scan(/"#{@lecturer_programme}"(.*),/)[0][0].strip   #Diploma Lanjutan Perioperating nbafmb anbfm ban
    #postbasic_name=a.gsub!(/[^a-zA-Z]/," ").split(" ")[0]     #in case a consist of comma, etc
    if ["Diploma Lanjutan"].include?(unit_name)
      a=main_task_first.scan(/Diploma Lanjutan (.*)/)[0][0].strip   #Diploma Lanjutan Perioperating nbafmb anbfm ban
    elsif ["Pos Basik"].include?(unit_name)
      a=main_task_first.scan(/Pos Basik (.*)/)[0][0].strip
    elsif ["Pengkhususan"].include?(unit_name)
      a=main_task_first.scan(/Pengkhususan (.*)/)[0][0].strip
    end
    if a.include?(" ")  #space exist, others may exist too
      a_rev=a.gsub!(/[^a-zA-Z]/," ")   #in case a consist of comma, etc 
      postbasic_name=a_rev.split(" ")[0]
    else
      postbasic_name=a 
    end
    postbasic=Programme.where('name ILIKE(?) and course_type=?', "%#{postbasic_name}%", unit_name).first
    postbasic.id if postbasic
  end
  #use in Weeklytimetables_controller.rb (Index - retrieve Programme ID for Pos Basik/Pengkhususan/Diploma Lanjutan) - END
  
end

# == Schema Information
#
# Table name: positions
#
#  ancestry       :string(255)
#  ancestry_depth :integer
#  code           :string(255)
#  combo_code     :string(255)
#  created_at     :datetime
#  id             :integer          not null, primary key
#  is_acting      :boolean
#  name           :string(255)
#  postinfo_id    :integer
#  staff_id       :integer
#  staffgrade_id  :integer
#  status         :integer
#  tasks_main     :text
#  tasks_other    :text
#  unit           :string(255)
#  updated_at     :datetime
#
