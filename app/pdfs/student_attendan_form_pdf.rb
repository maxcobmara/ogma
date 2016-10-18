class Student_attendan_formPdf < Prawn::Document
  def initialize(student_attendances, view, college, classes_count)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @student_attendances = student_attendances
    @view = view
    @college=college
    @classes_count=classes_count
    font "Helvetica"
    if college.code=="kskbjb"
      image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.5
      move_down 10
      text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 12, :style => :bold
      text "BORANG KEHADIRAN PELATIH", :align => :center, :size => 12, :style => :bold
    elsif college.code=="amsas"
      bounding_box([10,770], :width => 400, :height => 60) do |y2|
        image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :scale => 0.65#  :width =>97.2, :height =>77.76
      end
      bounding_box([440,770], :width => 400, :height => 60) do |y2|
        image "#{Rails.root}/app/assets/images/amsas_logo_small.png", :scale => 0.75
      end
      bounding_box([90,760], :width => 350, :height => 60) do |y2|
        text "PPL APMM", :style => :bold, :align => :center
        text "BORANG KEHADIRAN PELATIH", :align => :center, :size => 12, :style => :bold
      end
    else
      text "#{college.name.upcase}", :align => :center, :style => :bold
      text "BORANG KEHADIRAN PELATIH", :align => :center, :size => 12, :style => :bold
    end
    
    table_attendance
    pengajar
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def table_attendance
    if @college.code=="kskbjb"
      table(line_item_rows,  :header => true, :column_widths => [40, 80, 150 , 90, 90, 90], :cell_style => { :size => 10}) do
      self.width = 540
      end
    elsif @college.code=="amsas"
      table(line_item_rows,  :header => 2, :column_widths => [40, 180, 50, 250], :cell_style => { :size => 10}) do
          self.width=520
          row(0..1).background_color = 'FFE34D'
          column(3).style :align => :center
      end
    end
      
#       if @classes_count < 4
# 	@arr=[40, 180, 50]#[40, 230]
#         x=270/@classes_count
# 	1.upto(@classes_count).each do |y|
#           @arr << x
#         end
# 	table(line_item_rows,  :header => 2, :column_widths => @arr, :cell_style => { :size => 10}) do
#           self.width=540
# 	  row(0..1).background_color = 'FFE34D'
# 	  column(3).style :align => :center
#         end
#       end
      
  end
  
  def line_item_rows
    counter = counter || 0
    data=[]
    cnt=0
    if @college.code=="kskbjb"
      header=[[{content: "Bil", rowspan:2}, {content: "Nama Pelatih", rowspan:2}, "Tarikh", "", "", ""], ["Masa", "", "", ""]]
      @student_attendances.each do |sa|
        data << ["#{counter += 1}", sa.student.student_with_rank, " ", " ", " ", " "]
      end
    elsif @college.code=="amsas"
      #header=[[{content: "Bil", rowspan:2}, {content: "Nama Pelatih", rowspan:2}, "Tarikh", ""], ["Masa", ""]]
      header1=[{content: "Bil", rowspan:2}, {content: "Nama Pelatih", rowspan:2}, "Tarikh"]
      header2=["Masa"]
      #1.upto(@classes_count).each do |y|
 	#header1 << ""
 	#header2 << ""
      #end

      header=[header1]+[header2]
      @student_attendances.group_by(&:student).each do |st, sas|
	if cnt==0
	  sas.each{|j| header1 << j.weeklytimetable_detail.get_date_day_of_schedule + " ("+ j.weeklytimetable_detail.subject_topic+")"}
	  sas.each{|j| header2 << j.weeklytimetable_detail.get_time_slot}
	  cnt+=1
	end
	atts=[]
        sas.each{|j|atts << 'Hadir' if j.attend==true; atts << 'Tidak Hadir' if j.attend==false; atts << "" if j.attend.blank?}
	data << ["#{counter += 1}", {content: st.student_with_rank, colspan: 2}]+atts
      end
    end
    header+data
  end
  
  def pengajar
    if @college.code=="kskbjb"
      data = [[" ", " ", "Nama dan Tandatangan Pengajar ", " ", " ", " "]]
      table(data, :column_widths => [40, 80, 150 , 90, 90, 90], :cell_style => { :size => 10}) do
	self.width = 540
      end
    elsif @college.code=="amsas"
      data = [" ", "", "Nama dan Tandatangan Pengajar ", @student_attendances.first.weeklytimetable_detail.weeklytimetable_lecturer.staff_with_rank.titleize]
      table([data], :column_widths => [40, 80, 150, 250], :cell_style => { :size => 10}) do #40, 180, 50, 250
	self.width = 520
      end
    end
    move_down 5
    text "Nota :", :align => :left, :size => 11, :style => :bold
    text "Setiap pelatih perlu menandatangani borang kehadiran", :align => :left, :size => 11, :style => :bold
  end
  
  def footer
    draw_text "#{page_number} #{I18n.t('instructor_appraisal.from')} 3",  :size => 8, :at => [240,-5]
  end
  
end