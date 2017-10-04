module LocationHelper

  def location_categories
    dropper = (DropDown::LOCATION_CATEGORIES).map {|disp, value| disp }
    I18n.t(dropper).map { |key, value| [ value, key.to_s ] }
  end

  def location_category(location)
    (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == @location.lclass}).map {|disp, value| disp }[0] rescue 0
  end
  
  def set_view_class(location)
    #if (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == location.lclass}).map {|disp, value| disp }[0] == "building"
    if [1,4].include?(location.lclass)
      "col-md-5 building"
    elsif (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == location.lclass}).map {|disp, value| disp }[0] == "floor"
      "col-md-7 floor"
    elsif (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == location.lclass}).map {|disp, value| disp }[0] == "room"
      "room"
    end
  end
  
  def set_sub_class(location)
    if (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == location.lclass}).map {|disp, value| disp }[0] == "building"
      "col-md-5 building"
    elsif (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == location.lclass}).map {|disp, value| disp }[0] == "floor"
      "row floor"
    elsif (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == location.lclass}).map {|disp, value| disp }[0] == "room"
      "room img-rounded"
    end
  end
  
  def get_status_link(bed)
    if bed.status.include? "damaged"
      campus_location_path(:id => bed)
    elsif bed.status.include? "empty"
      new_student_tenant_path(:location_id => bed)
    elsif bed.status.include? "occupied"
      student_tenant_path(bed.tenants.last)
    else
      '#'
    end
  end
  
  ###
  #Export excel - statistic by level - tenants/reports.html.haml 
  #4thOct2017- refer location_helper.rb for dev/icms_acct
  def self.to_csv_all(options = {})
    #@current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    occupied_beds = @current_tenants.pluck(:location_id)
    building_name = all[0].root.name
    CSV.generate(options) do |csv|
        csv << [I18n.t('student.tenant.report_main')] #title added
        csv << [] #blank row added
        csv << [building_name]
        csv << [I18n.t('student.tenant.level'), I18n.t('student.tenant.occupied'), I18n.t('student.tenant.empty'), I18n.t('student.tenant.damaged'), I18n.t('student.tenant.notes')]   
        
        ##############
        lev=[]
        occ_level=[]
        occupiedroomss=[]
        ocbb=[]
        all.each do |bed|      
            ocbb << bed if occupied_beds.include?(bed.id)
        end
        #occupiedroom = ocbb.group_by{|x|x.combo_code[0,6]}.count   #3 aras je yg ade data
        occupiedlevel = ocbb.group_by{|x|x.combo_code[0,6]}
        occupiedlevel.each do |level, beds| #beds
          occ_level << level  #HB-02-
          occupiedbeds_level = beds.group_by{|y|y.combo_code[0,9]}
          occupiedbeds_level.each do |leve, bedss|
            lev << leve[0,6]
          end
          occupiedroomss << occupiedbeds_level.count
        end
        ##################

        num=0
        all.group_by{|x|x.combo_code[0,6]}.sort.reverse.each do |floor, beds|     #by floor
           damangedbed=[]
          #per each level----start
           beds.each do|bed|
              if bed.occupied == true
                damangedbed << bed
             end
           end
           damangedroom = damangedbed.group_by{|x|x.combo_code[0,6]}.count
           hash_occlevel = Hash[occ_level.zip(occupiedroomss)]
           hash_occlevel.default = 0 
           occupiedroom = hash_occlevel[floor]
           allroom = beds.group_by{|x|x.combo_code[0,9]}.count
           if floor[5,1]=="-"
             rev_floor = floor[0,5]   #HB-02-
           elsif floor[5,1]!="-"
             rev_floor = floor          #HB-00B
           end
           csv << [rev_floor, occupiedroom, allroom-occupiedroom-damangedroom, damangedroom]
           num+=1
          #per each level----end
        end

      end
  end
  
  #Export Excel - Census by level - tenants/..../census_level.html.haml (location_id/level)
  #4thOct2017- refer location_helper.rb for dev/icms_acct
  def self.to_csv2_all(options = {})
    
    #For TOTAL no of rooms, damaged rooms, occupied rooms, empty rooms
    #@current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    @tenantbed_per_level=all.joins(:tenants).where("tenants.id" => @current_tenants)
    tenant_beds_ids = @tenantbed_per_level.pluck(:location_id)
    occupied_rooms = all.where('id IN(?)', tenant_beds_ids).group_by{|x|x.combo_code[0,9]}.count
    all_rooms = all.map(&:combo_code).group_by{|x|x[0, x.size-2]}.count #fixed-3rdOct2017 - all.group_by{|x|x.combo_code[0,9]}.count
    damaged_rooms = all.where(occupied: true).group_by{|x|x.combo_code[0,9]}.count
    
    if all.first.college.code=='amsas'
      floor_label=all[0].parent.parent.name
    else 
      if all[0].combo_code[5,1]=="-"
        floor_label = all[0].combo_code[0,5]
      else
        floor_label = all[0].combo_code[0,6]
      end
    end
    
    
    #For tenants COUNT group by programme
    @all_tenants_wstudent = @current_tenants.joins(:location).where('location_id IN(?) and student_id IN(?)', tenant_beds_ids, Student.all.pluck(:id))
    @students_prog = Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id)).group_by{|j|j.course_id}
    @all_tenants_wostudent = @current_tenants.joins(:location).where('location_id IN(?) and (student_id is null OR student_id NOT IN(?))', tenant_beds_ids, Student.all.pluck(:id))
   
    CSV.generate(options) do |csv|
        csv << [I18n.t('student.tenant.census')] #title added
        csv << [] #blank row added
        csv << [floor_label]
        csv << [I18n.t('location.code'), I18n.t('location.name'), I18n.t('student.name'), I18n.t('student.icno'), I18n.t('student.students.matrixno'), I18n.t('course.name'), I18n.t('training.intake.description'), I18n.t('student.students.stelno') , I18n.t('student.tenant.notes')]  

        all.sort_by{|t|t.combo_code}.each do |bed|
          if bed.occupied==true
             csv << [bed.combo_code, bed.name, "#{bed.parent.damages.where(document_id: 1).last.description rescue (I18n.t 'student.tenant.damage')}"]
          else
            if bed.tenants.count > 0 && bed.tenants.last.keyreturned==nil && bed.tenants.last.force_vacate !=true
               if bed.tenants.last.student.nil?
                  csv << [bed.combo_code, bed.name, I18n.t('student.tenant.tenancy_details_nil')]
               else
                  validstu=Student.valid_students.pluck(:id)
                  a=true if validstu.include?(bed.tenants.last.student.id)
                  csv << [bed.combo_code, bed.name, "\'#{bed.tenants.last.try(:student).try(:name) if a}\'", "\'#{bed.tenants.last.try(:student).try(:icno) if a}\'", "\'#{bed.tenants.last.try(:student).try(:matrixno) if a}\'", "\'#{bed.tenants.last.try(:student).try(:course).try(:name) if a}\'", "\'#{bed.tenants.last.try(:student).try(:intake_num) if a}\'", "\'#{bed.tenants.last.try(:student).try(:stelno) if a}\'"]  #"=\"" + myVariable + "\""
               end
             else
               csv << [bed.combo_code, bed.name] #leaves empty, coz has no values
             end     
          end
        end

        if all.first.college.code=='amsas'
	  course_heading="\'Siri | #{(I18n.t 'course.name')}\'"
	else
	  course_heading="\'#{(I18n.t 'course.name')} - #{(I18n.t 'training.intake.description')}\'"
	end
        
        csv << [] #blank row added
        csv << [] #blank row added
        csv << [ I18n.t('student.tenant.total_empty'), all_rooms-damaged_rooms-occupied_rooms]
        csv << [I18n.t('student.tenant.total_damaged'), damaged_rooms]
        csv << [I18n.t('student.tenant.total_occupied'), occupied_rooms]
        csv << [ I18n.t('student.tenant.total_all'), all_rooms]

        csv << [] #blank row added
        csv << [] #blank row added
        csv << [course_heading, I18n.t('student.tenant.total')]
	if all.first.college.code=='amsas'
           Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id)).group_by(&:intakestudent).each do |intakestu, students2|
	     csv << [intakestu.siri_programmelist, students2.count]
	   end
	else
           @students_prog.each do |course_id, students|
              students.group_by{|k|k.intake}.each do |intake, students2|
                csv << [students.first.course.name+" - "+students2.first.intake_num, students2.count]
              end
           end
	end
        if @all_tenants_wostudent.count > 0
           csv << [(I18n.t 'student.tenant.tenancy_details_nil'), @all_tenants_wostudent.count]
        end
        csv << [(I18n.t 'student.tenant.total_tenants'),@tenantbed_per_level.count]
     end
  end
  ###
  
end