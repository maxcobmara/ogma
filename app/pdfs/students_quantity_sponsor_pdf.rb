class Students_quantity_sponsorPdf < Prawn::Document 
  def initialize(kkm,kkm_m,kkm_f,spa,spa_m,spa_f,swasta,swasta_m, swasta_f,sendiri,sendiri_m,sendiri_f, programmes, students, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @kkm=kkm
    @kkm_m=kkm_m
    @kkm_f=kkm_f
    @spa=spa
    @spa_m=spa_m
    @spa_f=spa_f
    @swasta=swasta
    @swasta_m=swasta_m
    @swasta_f=swasta_f
    @sendiri=sendiri
    @sendiri_m=sendiri_m
    @sendiri_f=sendiri_f
    @students_course_id=students.pluck(:course_id).uniq
    @programmes1=programmes.where(course_type: "Diploma").where('id IN (?)', @students_course_id)
    @programmes2=programmes.where(course_type: ["Pos Basik"]).where('id IN (?)', @students_course_id)
    @programmes3=programmes.where(course_type: ["Diploma Lanjutan"]).where('id IN (?)', @students_course_id)
    @view = view
    
    heading
    move_down 10
    record
    move_down 10
    cop
    
    if @programmes1.count>5
      start_new_page
      heading
      move_down 10
      record1b
      move_down 10
      cop
    end
    
    start_new_page
    heading
    move_down 10
    record2
    move_down 10
    cop
    
    if @programmes2.count>5
      start_new_page
      heading
      move_down 10
      record2b
      move_down 10
      cop
    end
    
    start_new_page
    heading
    move_down 10
    record3
    move_down 10
    cop
    
     if @programmes3.count>5
      start_new_page
      heading
      move_down 10
      record3b
      move_down 10
      cop
    end
    
    
  end
  
  def heading
    font "Times-Roman"
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :position => :center, :scale => 0.45
    move_down 5
    text "BAHAGIAN PENGURUSAN LATIHAN", :align => :center, :size => 10, :style => :bold
    text "KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 10, :style => :bold
    move_down 5
    text "BILANGAN PELATIH DI INSTITUSI LATIHAN KEMENTERIAN KESIHATAN MALAYSIA", :align => :center, :size => 10, :style => :italic
    move_down 5
    if Date.today.month < 7
    text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                                                             **SESI:JAN-JUN #{Date.today.year}  JUL-DIS.......", :align => :left, :size => 10, :style => :bold
    else
    text "INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU                                                                             **SESI:JAN-JUN......  JUL-DIS #{Date.today.year}", :align => :left, :size => 10, :style => :bold
    end
  end
  
  def record
    table(line_item_rows, :column_widths => [25,200,50,60,50,70,50,70,50,70,50], :cell_style => { :size => 9,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..1).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..10).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 775#755
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header =[ [{content: "BIL", rowspan: 2}, {content: "JENIS PROGRAM/KURSUS", rowspan: 2}, {content: "JANTINA", rowspan:2}, {content: "TAJAAN", colspan: 8}],["KKM", "BIL PELATIH","SPA", "BIL PELATIH", "SWASTA", "BIL PELATIH", "SENDIRI", "BIL PELATIH"] ]
    
    lines=[]
    @programmes1.each_with_index do |programme, counter|
       if counter < 5
         lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2}, "P",{content: "#{@kkm.where(course_id: programme.id).count}", rowspan:2},"#{@kkm_f.where(course_id: programme.id).count}", {content:"#{@spa.where(course_id: programme.id).count}", rowspan:2}, "#{@spa_f.where(course_id: programme.id).count}", {content:"#{@swasta.where(course_id: programme.id).count}", rowspan:2}, "#{@swasta_f.where(course_id: programme.id).count}", {content:"#{@sendiri.where(course_id: programme.id).count}", rowspan:2}, "#{@sendiri_f.where(course_id: programme.id).count}"]
         lines << [ "L","#{@kkm_m.where(course_id: programme.id).count}","#{@spa_m.where(course_id: programme.id).count}","#{@swasta_m.where(course_id: programme.id).count}","#{@sendiri_m.where(course_id: programme.id).count}"]
       end
     end 
     header+lines
  end 
  
    def record1b
    table(line_item_rows1b, :column_widths => [25,200,50,60,50,70,50,70,50,70,50], :cell_style => { :size => 9,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..1).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..10).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 775#755
      header = true
    end
  end
  
  def line_item_rows1b
    counter = counter || 0
    header =[ [{content: "BIL", rowspan: 2}, {content: "JENIS PROGRAM/KURSUS", rowspan: 2}, {content: "JANTINA", rowspan:2}, {content: "TAJAAN", colspan: 8}],["KKM", "BIL PELATIH","SPA", "BIL PELATIH", "SWASTA", "BIL PELATIH", "SENDIRI", "BIL PELATIH"] ]
    
    lines=[]
    @programmes1.each_with_index do |programme, counter|
      if counter > 4
         lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2}, "P",{content: "#{@kkm.where(course_id: programme.id).count}", rowspan:2},"#{@kkm_f.where(course_id: programme.id).count}", {content:"#{@spa.where(course_id: programme.id).count}", rowspan:2}, "#{@spa_f.where(course_id: programme.id).count}", {content:"#{@swasta.where(course_id: programme.id).count}", rowspan:2}, "#{@swasta_f.where(course_id: programme.id).count}", {content:"#{@sendiri.where(course_id: programme.id).count}", rowspan:2}, "#{@sendiri_f.where(course_id: programme.id).count}"]
         lines << [ "L","#{@kkm_m.where(course_id: programme.id).count}","#{@spa_m.where(course_id: programme.id).count}","#{@swasta_m.where(course_id: programme.id).count}","#{@sendiri_m.where(course_id: programme.id).count}"]
       end
     end 
     header+lines
  end 
  
  def record2
    table(line_item_rows2, :column_widths => [25,200,50,60,50,70,50,70,50,70,50], :cell_style => { :size => 9,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..1).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..10).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 755
      header = true
    end
  end
  
  def line_item_rows2
    counter = counter || 0
    header =[ [{content: "BIL", rowspan: 2}, {content: "JENIS PROGRAM/KURSUS", rowspan: 2}, {content: "JANTINA", rowspan:2}, {content: "TAJAAN", colspan: 8}],["KKM", "BIL PELATIH","SPA", "BIL PELATIH", "SWASTA", "BIL PELATIH", "SENDIRI", "BIL PELATIH"] ]
    lines=[]
    @programmes2.each_with_index do |programme, counter|
       if counter < 5
         lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2}, "P",{content: "#{@kkm.where(course_id: programme.id).count}", rowspan:2},"#{@kkm_f.where(course_id: programme.id).count}", {content:"#{@spa.where(course_id: programme.id).count}", rowspan:2}, "#{@spa_f.where(course_id: programme.id).count}", {content:"#{@swasta.where(course_id: programme.id).count}", rowspan:2}, "#{@swasta_f.where(course_id: programme.id).count}", {content:"#{@sendiri.where(course_id: programme.id).count}", rowspan:2}, "#{@sendiri_f.where(course_id: programme.id).count}"]
         lines << [ "L","#{@kkm_m.where(course_id: programme.id).count}","#{@spa_m.where(course_id: programme.id).count}","#{@swasta_m.where(course_id:  programme.id).count}","#{@sendiri_m.where(course_id: programme.id).count}"]
       end
     end 
     header+lines
  end 
  
  def record2b
    table(line_item_rows2b, :column_widths => [25,200,50,60,50,70,50,70,50,70,50], :cell_style => { :size => 9,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..1).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..10).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 755
      header = true
    end
  end
  
  def line_item_rows2b
    counter = counter || 0
    header =[ [{content: "BIL", rowspan: 2}, {content: "JENIS PROGRAM/KURSUS", rowspan: 2}, {content: "JANTINA", rowspan:2}, {content: "TAJAAN", colspan: 8}],["KKM", "BIL PELATIH","SPA", "BIL PELATIH", "SWASTA", "BIL PELATIH", "SENDIRI", "BIL PELATIH"] ]
    lines=[]
    @programmes2.each_with_index do |programme, counter|
       if counter > 4
         lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2}, "P",{content: "#{@kkm.where(course_id: programme.id).count}", rowspan:2},"#{@kkm_f.where(course_id: programme.id).count}", {content:"#{@spa.where(course_id: programme.id).count}", rowspan:2}, "#{@spa_f.where(course_id: programme.id).count}", {content:"#{@swasta.where(course_id: programme.id).count}", rowspan:2}, "#{@swasta_f.where(course_id: programme.id).count}", {content:"#{@sendiri.where(course_id: programme.id).count}", rowspan:2}, "#{@sendiri_f.where(course_id: programme.id).count}"]
         lines << [ "L","#{@kkm_m.where(course_id: programme.id).count}","#{@spa_m.where(course_id: programme.id).count}","#{@swasta_m.where(course_id: programme.id).count}","#{@sendiri_m.where(course_id: programme.id).count}"]
       end
     end 
     header+lines
  end 
  
  def record3
    table(line_item_rows3, :column_widths => [25,200,50,60,50,70,50,70,50,70,50], :cell_style => { :size => 9,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..1).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..10).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 755
      header = true
    end
  end
  
  def line_item_rows3
    counter = counter || 0
    header =[ [{content: "BIL", rowspan: 2}, {content: "JENIS PROGRAM/KURSUS", rowspan: 2}, {content: "JANTINA", rowspan:2}, {content: "TAJAAN", colspan: 8}],["KKM", "BIL PELATIH","SPA", "BIL PELATIH", "SWASTA", "BIL PELATIH", "SENDIRI", "BIL PELATIH"] ]
    lines=[]
    @programmes3.each_with_index do |programme, counter|
       if counter < 5
         lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2}, "P",{content: "#{@kkm.where(course_id: programme.id).count}", rowspan:2},"#{@kkm_f.where(course_id: programme.id).count}", {content:"#{@spa.where(course_id: programme.id).count}", rowspan:2}, "#{@spa_f.where(course_id: programme.id).count}", {content:"#{@swasta.where(course_id: programme.id).count}", rowspan:2}, "#{@swasta_f.where(course_id: programme.id).count}", {content:"#{@sendiri.where(course_id: programme.id).count}", rowspan:2}, "#{@sendiri_f.where(course_id: programme.id).count}"]
         lines << [ "L","#{@kkm_m.where(course_id: programme.id).count}","#{@spa_m.where(course_id: programme.id).count}","#{@swasta_m.where(course_id: programme.id).count}","#{@sendiri_m.where(course_id: programme.id).count}"]
       end
     end 
     header+lines
  end 
  
  def record3b
    table(line_item_rows3b, :column_widths => [25,200,50,60,50,70,50,70,50,70,50], :cell_style => { :size => 9,  :inline_format => :true}) do
      row(0..1).font_style = :bold
      row(0..1).background_color = 'FFE34D'
      row(0..1).align = :center
      column(2..10).align =:center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 755
      header = true
    end
  end
  
  def line_item_rows3b
    counter = counter || 0
    header =[ [{content: "BIL", rowspan: 2}, {content: "JENIS PROGRAM/KURSUS", rowspan: 2}, {content: "JANTINA", rowspan:2}, {content: "TAJAAN", colspan: 8}],["KKM", "BIL PELATIH","SPA", "BIL PELATIH", "SWASTA", "BIL PELATIH", "SENDIRI", "BIL PELATIH"] ]
    lines=[]
    @programmes3.each_with_index do |programme, counter|
       if counter > 4
         lines<< [{content: "#{counter+=1}", rowspan:2}, {content: "#{programme.programme_list}", rowspan: 2}, "P",{content: "#{@kkm.where(course_id: programme.id).count}", rowspan:2},"#{@kkm_f.where(course_id: programme.id).count}", {content:"#{@spa.where(course_id: programme.id).count}", rowspan:2}, "#{@spa_f.where(course_id: programme.id).count}", {content:"#{@swasta.where(course_id: programme.id).count}", rowspan:2}, "#{@swasta_f.where(course_id: programme.id).count}", {content:"#{@sendiri.where(course_id: programme.id).count}", rowspan:2}, "#{@sendiri_f.where(course_id: programme.id).count}"]
         lines << [ "L","#{@kkm_m.where(course_id: programme.id).count}","#{@spa_m.where(course_id: programme.id).count}","#{@swasta_m.where(course_id: programme.id).count}","#{@sendiri_m.where(course_id: programme.id).count}"]
       end
     end 
     header+lines
  end 
  
  def cop
  move_down 10
  text "* P - Perempuan", :align => :left, :size => 11, :indent_paragraphs => 30
  text "* L - Lelaki", :align => :left, :size => 11, :indent_paragraphs => 30
  
  text "Disediakan oleh :                                                                            Disahkan oleh : ", :align => :left, :size => 11, :indent_paragraphs => 40
  move_down 25
  text "---------------------------                                                                  -----------------------------", :align => :left, :size => 11, :indent_paragraphs => 30
  text "Nama :                                                                                                 Pengarah", :align => :left, :size => 11, :indent_paragraphs => 30
  text "Jawatan", :align => :left, :size => 11, :indent_paragraphs => 30
  
  text "Catatan : ", :align => :left, :size => 11, :indent_paragraphs => 30
  text "* Laporan setiap 6 bulan pada 15 Februari & 15 Ogos", :align => :left, :size => 11, :indent_paragraphs => 30
  end
  
end