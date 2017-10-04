class Laporan_penginapan2Pdf < Prawn::Document 
  def initialize(residentials, current_tenants, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @residentials = residentials
    @current_tenants = current_tenants
    @view = view
    @college = college
    font "Helvetica" #"Times-Roman"
    text "#{college.name}", :align => :center, :size => 11, :style => :bold
    move_down 20
    text "#{@residentials[0].root.name}", :size => 11, :style => :bold
    move_down 10
    text "#{I18n.t 'student.tenant.statistics_block'}", :size => 11, :style => :bold
    move_down 20
    room_status
    move_down 30
    text "#{(I18n.t 'student.tenant.tenants_students')}", :size => 11, :style => :bold
    move_down 20
    tenant_programme
  end
  
  def room_status
    table(room_status_rows, :column_widths => [120,200,80], :cell_style => { :size => 11,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).column(1).background_color = 'FFE34D'
      row(0).column(2).background_color = 'FFE34D'
      row(-1).font_style =:bold
      column(0).borders = [:right]
      column(2).align = :center
      self.header = true
      self.width = 400
      header = true
    end
  end
  
  def room_status_rows
    #For statistic by block (room status breakdown)
    all_beds = @residentials
    all_rooms = all_beds.group_by{|x|x.combo_code[0,x.combo_code.size-2]}
    damaged_rooms = all_beds.where(occupied: true).group_by{|x|x.combo_code[0,x.combo_code.size-2]}
    occupied_rooms = all_beds.where('id IN(?)', @current_tenants.pluck(:location_id)).group_by{|x|x.combo_code[0,x.combo_code.size-2]}
    
    header = [[ "",{content: "#{I18n.t('student.tenant.room_status_title')}", colspan: 2}]]   
    header +
     [["","#{I18n.t 'student.tenant.total_empty'}","#{all_rooms.count-damaged_rooms.count-occupied_rooms.count}"],
      ["","#{I18n.t 'student.tenant.total_occupied'}","#{occupied_rooms.count}"],
      ["","#{I18n.t 'student.tenant.total_damaged'}","#{damaged_rooms.count}"],
      ["","#{I18n.t 'student.tenant.total_rooms'}","#{all_rooms.count}"]]
  end 
  
  def tenant_programme
    table(tenant_programme_rows, :column_widths => [80,280,80], :cell_style => { :size => 10,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).column(1).background_color = 'FFE34D'
      row(0).column(2).background_color = 'FFE34D'
      row(-1).font_style =:bold
      column(0).borders = [:right]
      column(2).align = :center
      self.header = true
      self.width = 460
      header = true
    end
  end
  
  def tenant_programme_rows
    #For statistic by block (tenant's programme)    
    tenantbed_per_block = @residentials.joins(:tenants).where("tenants.id" => @current_tenants)
    all_tenants_wstudent = @current_tenants.joins(:location).where('location_id IN(?) and student_id IN(?)', tenantbed_per_block.pluck(:id), Student.all.pluck(:id))
    students_prog = Student.where('id IN (?)', all_tenants_wstudent.pluck(:student_id)).group_by{|j|j.course_id}
    all_tenants_wostudent = @current_tenants.joins(:location).where('location_id IN(?) and (student_id is null OR student_id NOT IN(?))', tenantbed_per_block.pluck(:id), Student.all.pluck(:id))
    
    header = [["",{content: "#{I18n.t('student.tenant.tenant_programme_title')}", colspan: 2}],
                     ["", @college.code=='amsas' ? "Siri | #{(I18n.t 'course.name')}" : "#{(I18n.t 'course.name')} - #{(I18n.t 'training.intake.description')}", "#{I18n.t('student.tenant.total')}"]]  
    
    tenant_rows=[]
    
    if @college.code=='amsas'
      Student.where('id IN (?)', all_tenants_wstudent.pluck(:student_id)).group_by(&:intakestudent).each do |intakestu, students2|
        tenant_rows << ["", intakestu.siri_programmelist, students2.count]
      end
    else
      students_prog.each do |course_id, students|
        students.group_by{|k|k.intake}.each do |intake, students2|
          tenant_rows << ["", "#{students.first.course.name+" - "+students2.first.intake_num}", "#{students2.count}"]
        end
      end
    end
    if all_tenants_wostudent.count > 0
       tenant_rows << ["", "#{I18n.t 'student.tenant.tenancy_details_nil'}", "#{all_tenants_wostudent.count}"]
    end
    tenant_rows << ["", "#{I18n.t 'student.tenant.total_tenants'}","#{tenantbed_per_block.count}"]
    header + tenant_rows
  end 
  
end