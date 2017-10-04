class CensusStudentTenantsPdf < Prawn::Document
  include StudentsHelper
  def initialize(all_beds_single, all, damaged, occupied, students_prog, all_tenants_wstudent, ab, all_tenants_wostudent, tenantbed_per_level, view, curr_usr)
    super({top_margin: 30, page_size: 'A4', page_layout: :portrait })
    @college=curr_usr.college
    @all_beds_single = all_beds_single
    @all=all 
    @damaged=damaged
    @occupied=occupied
    @students_prog=students_prog
    @all_tenants_wstudent=all_tenants_wstudent
    @ab=ab
    @all_tenants_wostudent=all_tenants_wostudent
    @tenantbed_per_level=tenantbed_per_level
    roles=curr_usr.roles.pluck(:authname)
    if roles.include?('developer') || (roles.include?('administration') && User.icms_acct.include?(curr_usr.id))
      @icms_team=true
    end
    font "Helvetica" #"Times-Roman"
    logo
    move_down 5
    text "Aras : #{@all_beds_single[0].parent.parent.name[-2,2]}", :align => :left, :size => 10, :style => :bold
    record
    move_down 40
    statistics
    move_down 50
    statistics2
  end
  
  def logo 
     table(line_logo, :column_widths => [60,400,40], :cell_style => { :size => 10,  :inline_format => :true}) do
      row(0).font_style = :bold
      self.width = 500
      row(0).column(0).borders = []
      row(0).column(1).borders = []
      row(0).column(2).borders = []
    end
  end
  
  def line_logo
    line_item=[[{:image => "#{Rails.root}/app/assets/images/logo_kerajaan.png", :scale => 0.5},
                     "PENEMPATAN PELATIH ASRAMA #{(@all_beds_single[0].root.name[4,20]).upcase} BLOK #{@all_beds_single[0].root.code+'<br>'} #{@college.name.upcase}",
                     {:image => "#{Rails.root}/app/assets/images/#{@college.logo}", :scale => 0.65}]]
    #:scale => 0.65
  end
  
  def record
    table(line_item_rows, :column_widths => [30,60,200,80,100,60], :cell_style => { :size => 9,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 530
      header = true
    end
  end
  
  def line_item_rows    
    line_items=[]
    counter = counter || 0
    validstu=Student.valid_students.pluck(:id)
    @all_beds_single.map do |bed|
      if bed.occupied==true
        line_items << ["#{counter+=1}","#{bed.parent.name[-5,5] if bed.parent.name[4,1]!='-'}#{bed.parent.name[-4,5] if bed.parent.name[4,1]=='-'}",{content: "#{bed.parent.damages.where(document_id: 1).last.description rescue (t 'student.tenant.damage')}", colspan: 4, :align => :center}]
      else
        one_line = ["#{counter+=1}","#{bed.parent.name[-5,5] if bed.parent.name[4,1]!='-' && bed.parent.name.size < 10}#{bed.parent.name[-4,5] if bed.parent.name[4,1]=='-' && bed.parent.name.size < 10} #{(bed.parent.name.split("-")[1]+"-"+bed.parent.name.split("-")[2][0,2]) if bed.parent.name.size > 9}"]
        if bed.tenants.count > 0 && bed.tenants.last.keyreturned==nil && bed.tenants.last.force_vacate !=true
          if bed.tenants.last.student.nil?
            one_line+=["#{I18n.t 'student.tenant.tenancy_details_nil'}","","",""]
          else
            a=true if validstu.include?(bed.tenants.last.student.id) || @icms_team
            if @college.code=='amsas'
              intake_detailing=bed.tenants.last.student.intakestudent.name
            else
              intake_detailing=bed.tenants.last.student.intake_num
            end
            one_line+=["#{bed.tenants.last.try(:student).try(:name) if a}", "#{bed.tenants.last.try(:student).try(:formatted_mykad) if a}", "#{bed.tenants.last.try(:student).try(:course).try(:name) if a}","#{intake_detailing if a}"]
          end
        else
          one_line+=["","","",""]
        end
        line_items << one_line
      end
    end
    
    header = [[ "BIL", "NO. BILIK", "NAMA", "NO. K / P", "PROGRAM", @college.code=='amsas' ? "SIRI" : "KUMP"]]   
    header + line_items
  end
  
  def statistics
    table(statistic_rows, :column_widths => [120,200,80], :cell_style => { :size => 10,  :inline_format => :true}) do
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
  
  def statistic_rows
    counter = counter || 0
    header = [[ "","Item", "#{I18n.t('student.tenant.total')}"]]   
    header +
     [["","#{I18n.t 'student.tenant.total_empty'}","#{@all - @damaged - @occupied}"],
      ["","#{I18n.t 'student.tenant.total_damaged'}","#{@damaged}"],
      ["","#{I18n.t 'student.tenant.total_occupied'}","#{@occupied}"],
      ["","#{I18n.t 'student.tenant.total_all'}","#{@all}"]]
  end 

  def statistics2
    table(statistic_rows2, :column_widths => [90,270,80], :cell_style => { :size => 10,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).column(1).background_color = 'FFE34D'
      row(0).column(2).background_color = 'FFE34D'
      row(-1).font_style =:bold
      column(0).borders = [:right]
      column(2).align = :center
      self.header = true
      self.width = 440
      header = true
    end
  end
  
  def statistic_rows2
    line_items=[]
    counter = counter || 0
    if @college.code=='amsas'
      @ab.group_by(&:intakestudent).each do |intakestu, students2|
        line_items << ["", intakestu.siri_programmelist, "#{students2.count}"]
      end
    else
      @students_prog.each do |course_id, students|
        students.group_by{|k|k.intake}.each do |intake, students2|
          line_items << ["","#{students.first.course.name+" - "+students2.first.intake_num}", "#{students2.count}"]
        end
      end
    end
    if @all_tenants_wostudent > 0
      line_items << ["","#{I18n.t 'student.tenant.tenancy_details_nil'}","#{@all_tenants_wostudent}"] 
    end
    line_items << ["", "#{I18n.t 'student.tenant.total_tenants'}","#{@tenantbed_per_level}"]
    header = [[ "", @college.code=='amsas' ? "Siri | #{(I18n.t 'course.name')}" : "#{(I18n.t 'course.name')} -  #{(I18n.t 'training.intake.description')}", "#{I18n.t('student.tenant.total')}"]]   
    header +line_items
  end   
  
end