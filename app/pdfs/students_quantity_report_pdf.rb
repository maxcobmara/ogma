class Students_quantity_reportPdf < Prawn::Document 
  def initialize(programmes, students, view)
    super({top_margin: 40, page_size: 'A4', page_layout: :landscape })
    @programmes = programmes
    @students = students
    @view = view
    @students_course_id=students.pluck(:course_id).uniq
#     @programmes_rev=@programmes.where('id IN(?) and name!=?', @students_course_id, 'Kebidanan').order(course_type: :asc)
#     @programmes_rev_bidan=@programmes.where(id: @students_course_id, name: 'Kebidanan')
    valid_programmes=Student.all.pluck(:course_id).uniq
    @programmes_rev=@programmes.where('course_type=? and id IN(?)', 'Diploma', valid_programmes)
    @intake1=(Student.get_intake(1, 1,@programmes.where(course_type: "Diploma")[0].id)).try(:strftime, "%b '%y")
    @intake2=(Student.get_intake(2, 1,@programmes.where(course_type: "Diploma")[0].id)).try(:strftime, "%b '%y")
    @intake3=(Student.get_intake(1, 2,@programmes.where(course_type: "Diploma")[0].id)).try(:strftime, "%b '%y")
    @intake4=(Student.get_intake(2, 2,@programmes.where(course_type: "Diploma")[0].id)).try(:strftime, "%b '%y")
    @intake5=(Student.get_intake(1, 3,@programmes.where(course_type: "Diploma")[0].id)).try(:strftime, "%b '%y")
    @intake6=(Student.get_intake(2, 3,@programmes.where(course_type: "Diploma")[0].id)).try(:strftime, "%b '%y")
#     @intake_1=(Student.get_intake(1, 1,@programmes.where(course_type: ["Diploma Lanjutan", "Pos Basik"])[0].id)).try(:strftime, "%b '%y")
#     @intake_2=(Student.get_intake(2, 1,@programmes.where(course_type: ["Diploma Lanjutan", "Pos Basik"])[0].id)).try(:strftime, "%b '%y")
#     @intake_bidan_1=(Student.get_intake(1,1,@programmes.where(name: 'Kebidanan').first.id)).try(:strftime, "%b '%y")
#     @intake_bidan_2=(Student.get_intake(2,1,@programmes.where(name: 'Kebidanan').first.id)).try(:strftime, "%b '%y")
    
    @table_heading=[ [{content: "BIL", rowspan: 4}, {content: "JENIS PROGRAM/ KURSUS", rowspan: 4}, {content: "KAPASITI", colspan: 2, rowspan: 2}, {content: "JANTINA", rowspan:4}, {content: "SESI PENGAMBILAN", colspan: 17}],[{content: "#{@intake1}", colspan:2}, {content: "#{@intake2}", colspan:2}, {content: "#{@intake3}", colspan:2}, {content: "#{@intake4}", colspan:2}, {content: "#{@intake5}", colspan:2}, {content: "#{@intake6}", colspan:2}, {content: "#{@intake_1}", colspan:2}, {content: "#{@intake_2}", colspan:2}, {content: "JUM PELATIH MENGIKUT SEM", rowspan: 3}],[{content: "KAPASITI KOLEJ", rowspan: 2},{content: "KAPASITI MENGIKUT PROGRAM",rowspan:2},{content: "Tahun 1", colspan:4},{content: "Tahun 2", colspan:4},{content: "Tahun 3", colspan:4},{content: "KPSL", colspan:4}],["Lapor Diri","Sem 1","Lapor Diri","Sem 2","Lapor Diri","Sem 1","Lapor Diri","Sem 2","Lapor Diri","Sem 1","Lapor Diri","Sem 2","Lapor Diri","Sem 1","Lapor Diri","Sem 2"] ]
    
    heading
    move_down 10
    record
    move_down 5
    cop
    
    if @programmes_rev.count>5
      start_new_page
      heading
      move_down 10
      record1b
      move_down 5
      cop
    end
    
    if @programmes_rev.count>10
      start_new_page
      heading
      move_down 10
      record1c
      move_down 5
      cop
    end
    
    if @programmes_rev.count>15
      start_new_page
      heading
      move_down 10
      record1d
      move_down 5
      cop
    end
    
     #Diploma Kebidanan section
#     heading_kebidanan
#     move_down 10
#     record2
#     move_down 5
#     cop
    
  end
  
  def heading
    report_logo_heading
    institute_name_plus_date_line
  end
  
#   def heading_kebidanan
#     report_logo_heading
#     institute_name_plus_date_line2
#   end
  
  def report_logo_heading
    font "Times-Roman"
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.45
    text "BAHAGIAN PENGURUSAN LATIHAN", :align => :center, :size => 10, :style => :bold
    text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 10, :style => :bold
    move_down 5
    text "BILANGAN PELATIH DI INSTITUSI LATIHAN KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 10, :style => :italic
    move_down 5
  end
  
  def institute_name_plus_date_line
    if Date.today.month < 7
      text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                                                             **SESI:JAN-JUN #{Date.today.year}  JUL-DIS.......", :align => :left, :size => 10, :style => :bold
    else
      text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                                                             **SESI:JAN-JUN......  JUL-DIS #{Date.today.year}", :align => :left, :size => 10, :style => :bold
    end
  end
  
#   def institute_name_plus_date_line2
#     if Date.today.month < 3 
#       text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                                                             **SESI:MAC-OGOS......   SEP #{(Date.today-1.year).year}-FEB #{Date.today.year}", :align => :left, :size => 10, :style => :bold
#     elsif Date.today.month >= 3 && Date.today.month < 9
#       text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                                                             **SESI:MAC-OGOS #{Date.today.year}  SEP-FEB...... ", :align => :left, :size => 10, :style => :bold
#     elsif Date.today.month >=9
#       text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                                                             **SESI:MAC-OGOS......  SEP #{Date.today.year}-FEB #{(Date.today.year+1.year).year}", :align => :left, :size => 10, :style => :bold
#     end
#   end
  
  def record
    table(line_item_rows, :column_widths => [23,60,45,50,45,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,55], :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..3).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..21).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 758
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header =@table_heading
    
    lines=[]
    @programmes_rev.each_with_index do |programme, counter|
       
       students_all_6intakes = Student.get_student_by_6intake(programme.id)
       @students_6intakes_ids = students_all_6intakes.map(&:id)
       @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_6intakes_ids)

       lapordiri112=@students.get_lapor_diri(1,1,2,programme.id).count
       lapordiri212=@students.get_lapor_diri(2,1,2,programme.id).count
       lapordiri122=@students.get_lapor_diri(1,2,2, programme.id).count
       lapordiri222=@students.get_lapor_diri(2,2,2, programme.id).count
       lapordiri132=@students.get_lapor_diri(1,3,2, programme.id).count
       lapordiri232=@students.get_lapor_diri(2,3,2, programme.id).count
       lapordiri111=@students.get_lapor_diri(1,1,1, programme.id).count
       lapordiri211=@students.get_lapor_diri(2,1,1, programme.id).count
       lapordiri121=@students.get_lapor_diri(1,2,1, programme.id).count
       lapordiri221=@students.get_lapor_diri(2,2,1, programme.id).count
       lapordiri131=@students.get_lapor_diri(1,3,1, programme.id).count
       lapordiri231=@students.get_lapor_diri(2,3,1, programme.id).count
       
       sem112=@students.get_student_by_intake_gender(1,1,2,programme.id).count
       sem212=@students.get_student_by_intake_gender(2, 1, 2,programme.id).count
       sem122=@students.get_student_by_intake_gender(1,2,2,programme.id).count
       sem222=@students.get_student_by_intake_gender(2, 2, 2,programme.id).count
       sem132=@students.get_student_by_intake_gender(1,3,2,programme.id).count
       sem232=@students.get_student_by_intake_gender(2, 3, 2,programme.id).count
       sem111=@students.get_student_by_intake_gender(1,1,1,programme.id).count
       sem211=@students.get_student_by_intake_gender(2, 1, 1,programme.id).count
       sem121=@students.get_student_by_intake_gender(1, 2, 1,programme.id).count
       sem221=@students.get_student_by_intake_gender(2, 2, 1,programme.id).count
       sem131=@students.get_student_by_intake_gender(1, 3, 1,programme.id).count
       sem231=@students.get_student_by_intake_gender(2, 3, 1,programme.id).count

       
       if counter < 5
          lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2},"","" ,"P", "#{lapordiri112 if lapordiri112>0}", "#{sem112 if sem112>0}", "#{lapordiri212 if lapordiri212>0}","#{sem212 if sem212>0}", "#{lapordiri122 if lapordiri122>0}", "#{sem122 if sem122>0}", "#{lapordiri222 if lapordiri222>0}","#{sem222 if sem222>0}", "#{lapordiri132 if lapordiri132>0}", "#{sem132 if sem132>0}", "#{lapordiri232 if lapordiri232>0}","#{sem232 if sem232>0}", "", "", "","",{content: "#{@valid.count}", rowspan:2}]
          lines << [ "","","L", "#{lapordiri111 if lapordiri111>0}", "#{sem111 if sem111>0}", "#{lapordiri211 if lapordiri211>0}","#{sem211 if sem211>0}", "#{lapordiri121 if lapordiri121>0}", "#{sem121 if sem121>0}", "#{lapordiri221 if lapordiri221>0}","#{sem221 if sem221>0}", "#{lapordiri131 if lapordiri131>0}", "#{sem131 if sem131>0}", "#{lapordiri231 if lapordiri231>0}","#{sem231 if sem231>0}","","","",""]
       end
     end 
     header+lines
  end 
  
  def record1b
    table(line_item_rows1b, :column_widths =>  [23,60,45,50,45,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,55], :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..3).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..21).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 758
      header = true
    
    lines=[]
    end
  end
  
  def line_item_rows1b
    counter = counter || 0
    header=@table_heading
    
    lines=[]
    @programmes_rev.each_with_index do |programme, counter|
      
       students_all_6intakes = Student.get_student_by_6intake(programme.id)
       @students_6intakes_ids = students_all_6intakes.map(&:id)
       @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_6intakes_ids)

       lapordiri112=@students.get_lapor_diri(1,1,2,programme.id).count
       lapordiri212=@students.get_lapor_diri(2,1,2,programme.id).count
       lapordiri122=@students.get_lapor_diri(1,2,2, programme.id).count
       lapordiri222=@students.get_lapor_diri(2,2,2, programme.id).count
       lapordiri132=@students.get_lapor_diri(1,3,2, programme.id).count
       lapordiri232=@students.get_lapor_diri(2,3,2, programme.id).count
       lapordiri111=@students.get_lapor_diri(1,1,1, programme.id).count
       lapordiri211=@students.get_lapor_diri(2,1,1, programme.id).count
       lapordiri121=@students.get_lapor_diri(1,2,1, programme.id).count
       lapordiri221=@students.get_lapor_diri(2,2,1, programme.id).count
       lapordiri131=@students.get_lapor_diri(1,3,1, programme.id).count
       lapordiri231=@students.get_lapor_diri(2,3,1, programme.id).count
       
       sem112=@students.get_student_by_intake_gender(1,1,2,programme.id).count
       sem212=@students.get_student_by_intake_gender(2, 1, 2,programme.id).count
       sem122=@students.get_student_by_intake_gender(1,2,2,programme.id).count
       sem222=@students.get_student_by_intake_gender(2, 2, 2,programme.id).count
       sem132=@students.get_student_by_intake_gender(1,3,2,programme.id).count
       sem232=@students.get_student_by_intake_gender(2, 3, 2,programme.id).count
       sem111=@students.get_student_by_intake_gender(1,1,1,programme.id).count
       sem211=@students.get_student_by_intake_gender(2, 1, 1,programme.id).count
       sem121=@students.get_student_by_intake_gender(1, 2, 1,programme.id).count
       sem221=@students.get_student_by_intake_gender(2, 2, 1,programme.id).count
       sem131=@students.get_student_by_intake_gender(1, 3, 1,programme.id).count
       sem231=@students.get_student_by_intake_gender(2, 3, 1,programme.id).count
       
       if counter > 4 && counter < 10
           lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2},"","" ,"P", "#{lapordiri112 if lapordiri112>0}", "#{sem112 if sem112>0}", "#{lapordiri212 if lapordiri212>0}","#{sem212 if sem212>0}", "#{lapordiri122 if lapordiri122>0}", "#{sem122 if sem122>0}", "#{lapordiri222 if lapordiri222>0}","#{sem222 if sem222>0}", "#{lapordiri132 if lapordiri132>0}", "#{sem132 if sem132>0}", "#{lapordiri232 if lapordiri232>0}","#{sem232 if sem232>0}", "", "", "","",{content: "#{@valid.count}", rowspan:2}]
           lines << [ "","","L", "#{lapordiri111 if lapordiri111>0}", "#{sem111 if sem111>0}", "#{lapordiri211 if lapordiri211>0}","#{sem211 if sem211>0}", "#{lapordiri121 if lapordiri121>0}", "#{sem121 if sem121>0}", "#{lapordiri221 if lapordiri221>0}","#{sem221 if sem221>0}", "#{lapordiri131 if lapordiri131>0}", "#{sem131 if sem131>0}", "#{lapordiri231 if lapordiri231>0}","#{sem231 if sem231>0}","","","",""]
       end
     end 
     header+lines
  end 
  
  def record1c
    table(line_item_rows1c, :column_widths =>  [23,60,45,50,45,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,55], :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..3).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..21).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 758
      header = true
    end
  end
  
  def line_item_rows1c
    counter = counter || 0
    header = @table_heading
    
    lines=[]
    @programmes_rev.each_with_index do |programme, counter|
      
       students_all_6intakes = Student.get_student_by_6intake(programme.id)
       @students_6intakes_ids = students_all_6intakes.map(&:id)
       @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_6intakes_ids)

       lapordiri112=@students.get_lapor_diri(1,1,2,programme.id).count
       lapordiri212=@students.get_lapor_diri(2,1,2,programme.id).count
       lapordiri122=@students.get_lapor_diri(1,2,2, programme.id).count
       lapordiri222=@students.get_lapor_diri(2,2,2, programme.id).count
       lapordiri132=@students.get_lapor_diri(1,3,2, programme.id).count
       lapordiri232=@students.get_lapor_diri(2,3,2, programme.id).count
       lapordiri111=@students.get_lapor_diri(1,1,1, programme.id).count
       lapordiri211=@students.get_lapor_diri(2,1,1, programme.id).count
       lapordiri121=@students.get_lapor_diri(1,2,1, programme.id).count
       lapordiri221=@students.get_lapor_diri(2,2,1, programme.id).count
       lapordiri131=@students.get_lapor_diri(1,3,1, programme.id).count
       lapordiri231=@students.get_lapor_diri(2,3,1, programme.id).count
       
       sem112=@students.get_student_by_intake_gender(1,1,2,programme.id).count
       sem212=@students.get_student_by_intake_gender(2, 1, 2,programme.id).count
       sem122=@students.get_student_by_intake_gender(1,2,2,programme.id).count
       sem222=@students.get_student_by_intake_gender(2, 2, 2,programme.id).count
       sem132=@students.get_student_by_intake_gender(1,3,2,programme.id).count
       sem232=@students.get_student_by_intake_gender(2, 3, 2,programme.id).count
       sem111=@students.get_student_by_intake_gender(1,1,1,programme.id).count
       sem211=@students.get_student_by_intake_gender(2, 1, 1,programme.id).count
       sem121=@students.get_student_by_intake_gender(1, 2, 1,programme.id).count
       sem221=@students.get_student_by_intake_gender(2, 2, 1,programme.id).count
       sem131=@students.get_student_by_intake_gender(1, 3, 1,programme.id).count
       sem231=@students.get_student_by_intake_gender(2, 3, 1,programme.id).count
       
       if counter > 9 && counter < 15
           lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2},"","" ,"P", "#{lapordiri112 if lapordiri112>0}", "#{sem112 if sem112>0}", "#{lapordiri212 if lapordiri212>0}","#{sem212 if sem212>0}", "#{lapordiri122 if lapordiri122>0}", "#{sem122 if sem122>0}", "#{lapordiri222 if lapordiri222>0}","#{sem222 if sem222>0}", "#{lapordiri132 if lapordiri132>0}", "#{sem132 if sem132>0}", "#{lapordiri232 if lapordiri232>0}","#{sem232 if sem232>0}", "", "", "","",{content: "#{@valid.count}", rowspan:2}]
           lines << [ "","","L", "#{lapordiri111 if lapordiri111>0}", "#{sem111 if sem111>0}", "#{lapordiri211 if lapordiri211>0}","#{sem211 if sem211>0}", "#{lapordiri121 if lapordiri121>0}", "#{sem121 if sem121>0}", "#{lapordiri221 if lapordiri221>0}","#{sem221 if sem221>0}", "#{lapordiri131 if lapordiri131>0}", "#{sem131 if sem131>0}", "#{lapordiri231 if lapordiri231>0}","#{sem231 if sem231>0}","","","",""]
       end
     end 
     header+lines
  end 
  
  
  def record1d
    table(line_item_rows1d, :column_widths =>  [23,60,45,50,45,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,55], :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..3).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..21).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 758
      header = true
    end
  end
  
  def line_item_rows1d
    counter = counter || 0
    header = @table_heading
    
    lines=[]
    @programmes_rev.each_with_index do |programme, counter|
      
       students_all_6intakes = Student.get_student_by_6intake(programme.id)
       @students_6intakes_ids = students_all_6intakes.map(&:id)
       @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_6intakes_ids)

       lapordiri112=@students.get_lapor_diri(1,1,2,programme.id).count
       lapordiri212=@students.get_lapor_diri(2,1,2,programme.id).count
       lapordiri122=@students.get_lapor_diri(1,2,2, programme.id).count
       lapordiri222=@students.get_lapor_diri(2,2,2, programme.id).count
       lapordiri132=@students.get_lapor_diri(1,3,2, programme.id).count
       lapordiri232=@students.get_lapor_diri(2,3,2, programme.id).count
       lapordiri111=@students.get_lapor_diri(1,1,1, programme.id).count
       lapordiri211=@students.get_lapor_diri(2,1,1, programme.id).count
       lapordiri121=@students.get_lapor_diri(1,2,1, programme.id).count
       lapordiri221=@students.get_lapor_diri(2,2,1, programme.id).count
       lapordiri131=@students.get_lapor_diri(1,3,1, programme.id).count
       lapordiri231=@students.get_lapor_diri(2,3,1, programme.id).count
       
       sem112=@students.get_student_by_intake_gender(1,1,2,programme.id).count
       sem212=@students.get_student_by_intake_gender(2, 1, 2,programme.id).count
       sem122=@students.get_student_by_intake_gender(1,2,2,programme.id).count
       sem222=@students.get_student_by_intake_gender(2, 2, 2,programme.id).count
       sem132=@students.get_student_by_intake_gender(1,3,2,programme.id).count
       sem232=@students.get_student_by_intake_gender(2, 3, 2,programme.id).count
       sem111=@students.get_student_by_intake_gender(1,1,1,programme.id).count
       sem211=@students.get_student_by_intake_gender(2, 1, 1,programme.id).count
       sem121=@students.get_student_by_intake_gender(1, 2, 1,programme.id).count
       sem221=@students.get_student_by_intake_gender(2, 2, 1,programme.id).count
       sem131=@students.get_student_by_intake_gender(1, 3, 1,programme.id).count
       sem231=@students.get_student_by_intake_gender(2, 3, 1,programme.id).count
       
       if counter > 14 && counter < 20
          lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2},"","" ,"P", "#{lapordiri112 if lapordiri112>0}", "#{sem112 if sem112>0}", "#{lapordiri212 if lapordiri212>0}","#{sem212 if sem212>0}", "#{lapordiri122 if lapordiri122>0}", "#{sem122 if sem122>0}", "#{lapordiri222 if lapordiri222>0}","#{sem222 if sem222>0}", "#{lapordiri132 if lapordiri132>0}", "#{sem132 if sem132>0}", "#{lapordiri232 if lapordiri232>0}","#{sem232 if sem232>0}", "", "", "","",{content: "#{@valid.count}", rowspan:2}]
          lines << [ "","","L", "#{lapordiri111 if lapordiri111>0}", "#{sem111 if sem111>0}", "#{lapordiri211 if lapordiri211>0}","#{sem211 if sem211>0}", "#{lapordiri121 if lapordiri121>0}", "#{sem121 if sem121>0}", "#{lapordiri221 if lapordiri221>0}","#{sem221 if sem221>0}", "#{lapordiri131 if lapordiri131>0}", "#{sem131 if sem131>0}", "#{lapordiri231 if lapordiri231>0}","#{sem231 if sem231>0}","","","",""]
       end
     end 
     header+lines
  end 
  
  def cop
    move_down 5
    text "* P - Perempuan", :align => :left, :size => 9, :indent_paragraphs => 30
    text "* L - Lelaki", :align => :left, :size => 9, :indent_paragraphs => 30
  
    text "Disediakan oleh :                                                                                                                                                                                                         Disahkan oleh : ", :align => :left, :size => 9, :indent_paragraphs => 40
    move_down 15
    text "---------------------------                                                                                                                                                                                                     -----------------------------", :align => :left, :size => 9, :indent_paragraphs => 30
    text "Nama :                                                                                                                                                                                                                             Pengarah", :align => :left, :size => 9, :indent_paragraphs => 30
    text "Jawatan", :align => :left, :size => 9, :indent_paragraphs => 30
  
    text "Catatan : ", :align => :left, :size => 9, :indent_paragraphs => 30
    text "* Laporan setiap 6 bulan pada 15 Februari & 15 Ogos", :align => :left, :size => 9, :indent_paragraphs => 30
  end
  
  ###for KEBIDANAN only
#   def record2
#     table(line_item_rows2, :column_widths => [23,60,45,50,45,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,55], :cell_style => { :size => 8,  :inline_format => :true}) do
#       row(0..1).font_style = :bold
#       row(0..3).background_color = 'FFE34D'
#       row(0..1).align = :center
#       column(2..21).align =:center
#       self.row_colors = ["FEFEFE", "FFFFFF"]
#       self.header = true
#       self.width = 758
#       header = true
#     end
#   end
#   
#   def line_item_rows2
#     counter = counter || 0
#     header =[ [{content: "BIL", rowspan: 4}, {content: "JENIS PROGRAM/ KURSUS", rowspan: 4}, {content: "KAPASITI", colspan: 2, rowspan: 2}, {content: "JANTINA", rowspan:4}, {content: "SESI PENGAMBILAN", colspan: 17}],[{content: "#{@intake1}", colspan:2}, {content: "#{@intake2}", colspan:2}, {content: "#{@intake3}", colspan:2}, {content: "#{@intake4}", colspan:2}, {content: "#{@intake5}", colspan:2}, {content: "#{@intake6}", colspan:2}, {content: "#{@intake_bidan_1}", colspan:2}, {content: "#{@intake_bidan_2}", colspan:2}, {content: "JUM PELATIH MENGIKUT SEM", rowspan: 3}],[{content: "KAPASITI KOLEJ", rowspan: 2},{content: "KAPASITI MENGIKUT PROGRAM",rowspan:2},{content: "Tahun 1", colspan:4},{content: "Tahun 2", colspan:4},{content: "Tahun 3", colspan:4},{content: "KPSL", colspan:4}],["Lapor Diri","Sem 1","Lapor Diri","Sem 2","Lapor Diri","Sem 1","Lapor Diri","Sem 2","Lapor Diri","Sem 1","Lapor Diri","Sem 2","Lapor Diri","Sem 1","Lapor Diri","Sem 2"] ]
#     
#     lines=[]
#     @programmes_rev_bidan.each_with_index do |programme, counter|
#        
#        student_all_2intakes = Student.get_student_by_2intake(programme.id)
#        @students_2intakes_ids = student_all_2intakes.map(&:id)
#        @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',programme.id, @students_2intakes_ids) 
# 
#        lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2},"","" ,"P","", "
#                 ", "","", "","", "","", "","", "","", "","#{@students.get_student_by_intake_gender(1, 1, 2,programme.id).count }", "", "#{@students.get_student_by_intake_gender(2,1, 2,programme.id).count }",{content: "#{@valid.count}", rowspan:2}]
#        lines << [ "","","L","","","","","","","","","","","","","","#{@students.get_student_by_intake_gender(1, 1, 1,programme.id).count }","","#{@students.get_student_by_intake_gender(2, 1, 1,programme.id).count }"]
#       
#      end 
#      header+lines
#   end 

end