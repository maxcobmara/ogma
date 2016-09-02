class Borang_maklumat_pelajarPdf < Prawn::Document
  def initialize(student, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @student = student
    @view = view
    
    if college.code=="kskbjb"
      font "Times-Roman"
      text "#{college.name.upcase}", :align => :center, :size => 14, :style => :bold
      move_down 5
      text "KUMPULAN: #{@student.intake.try(:strftime,"%B %Y")}",  :align => :center, :size => 14, :style => :bold
      move_down 5
      text "BORANG MAKLUMAT PELATIH", :align => :center, :size => 14, :style => :bold
      move_down 20
      table1
      table2
      table3
      @q = @student.qualifications
      if @q.count > 0
	table4
      end
      puid = @student.id
      @garantor = Kin.where("student_id = ? AND kintype_id = ? ", puid,  98 )
      if @garantor.count > 0
	table5
      end
      puid = @student.id
      @thekins = Kin.where("student_id = ? AND kintype_id != ? AND kintype_id != ? ", puid,  98, 99)
      if @thekins.count > 0
	table6
      end
    elsif college.code=="amsas"
      ###
      font="Helvetica"
      move_down 10
      header
      move_down 10
      header_pg1
      move_down 5
      table_personal_details_pg1
      move_down 10
      table_ending
      start_new_page #pg 2
      header
      move_down 20
      table_personal_details_pg2
      move_down 20
      table_personal_details_pg2_cont
      move_down 80
      table_ending
      start_new_page #pg 3
      header
      table_attachments_verifications
      move_down 10
      table_notes
      move_down 30
      table_ending
      
      page_count.times do |i|
        go_to_page(i+1)
        footer
      end
      ###
    end
  end
  
  def header
      text "PPL APMM", :align => :center, :size => 14, :style => :bold
      move_down 10
      text "#{I18n.t('instructor_appraisal.document_no').upcase} : BK-LAT-KS-02-03", :align => :center, :size => 14, :style => :bold
      text "BORANG MAKLUMAT PERIBADI", :align => :center, :style => :bold, :size => 14
      move_down 15
      bounding_box([10,770], :width => 400, :height => 100) do |y2|
        image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
      end
      bounding_box([430,770], :width => 400, :height => 90) do |y2|
        image "#{Rails.root}/app/assets/images/amsas_logo_small.png"
      end
  end
  
  def header_pg1
      text "PUSAT PENDIDIKAN DAN LATIHAN APMM",  :align => :center, :style => :bold, :size => 10
      text "AGENSI PENGUATKUASAAN MARITIM MALAYSIA",  :align => :center, :style => :bold, :size => 10
      text "JABATAN PERDANA MENTERI",  :align => :center, :style => :bold, :size => 10
      move_down 10
      text "BORANG MAKLUMAT PERIBADI", :align => :center, :style => :bold, :size => 14, :align => :center, :style => :bold, :size => 14
      text "(Diisi dalam 2 salinan)", :align => :center, :size => 9
      
       bounding_box([410, 680], :width =>90, :height => 100) do |y|
	 stroke_bounds
	 #text "#{@student.photo.url(:form)}" --> #/assets/students/1/form/carnation.jpg?1472783146
         #image "#{Rails.root}/public/assets/students/1/form/carnation.jpg", :at => [5,95], :width => 80, :height => 90
	 if @student.photo?
	   image "#{Rails.root}/public#{@student.photo.url(:form).split('?')[0]}", :at => [5,95], :width => 80, :height => 90
	 else
	  draw_text "Photo", :at => [30, 50], :size => 11
	 end
       end
  end
  
  def table_personal_details_pg1
    data=[["A.", {content: "MAKLUMAT PERIBADI PELATIH", colspan: 3}],[{content: "Nama Pelatih : #{@student.try(:name)}", colspan: 4}],
              [{content: "No. K/P (Baru) : #{@student.try(:formatted_mykad)}", colspan: 2}, {content: "Umur : #{@student.try(:age)}", colspan: 2}],
              [{content: "Tarikh Lahir : #{@student.try(:sbirthdt).try(:strftime, '%d-%m- %Y')}", colspan: 2},{content: "Tempat Lahir :" , colspan: 2}], 
              [{content: "Jantina : #{@student.gender==1? '<b>LELAKI</b> / PEREMPUAN' : 'Lelaki / <b>PEREMPUAN</b>'}", colspan: 2},
               {content: "Status Perkahwinan : #{@student.mrtlstatuscd}", colspan: 2}],
              [{content: "No. APMM : ", colspan: 2},{content: "No. Kad Kuasa :", colspan: 2}],
	      [{content: "No. Insuran :", colspan: 2},{content: "Jenis Insuran : ", colspan: 2}],
              [{content: "Jenis Darah : #{@student.bloodtype}", colspan: 4}],
	      [{content: "Bangsa / Keturunan : #{@student.try(:race)}", colspan: 2},{content: "Agama :", colspan: 2}],
	      [{content: "Kelulusan Akademik : SPM / STPM / DIPLOMA / IJAZAH / MASTER / PHD : #{@student.qualifications.sort.map(&:level_name)[0] if @student.qualifications.count > 0}", colspan: 2},{content: "No. Tel Bimbit : #{@student.stelno}", colspan: 2}],
              [{content: "Pangkat : #{@student.rank.try(:name)} ", colspan: 2},{content: "Unit  / Bahagian / Cawangan : #{@student.try(:department)}", colspan: 2}], [{content: "Alamat Pejabat #{@student.try(:address_posbasik)}", colspan: 4}],
          [{content: "Poskod : ", colspan: 2},{content: "No. Tel Pejabat : ", colspan: 2}],
          [{content: "Emel (sekiranya ada) :", colspan: 4}],
          [{content: "Nama Bapa : #{@student.kins.where(kintype_id: 4).first.name if @student.kins.where(kintype_id: 4).count > 0}", colspan: 3}, 
           "No. Tel : #{@student.kins.where(kintype_id: 4).first.phone if @student.kins.where(kintype_id: 4).count > 0}"],
          [{content: "Nama Ibu : #{@student.kins.where(kintype_id: 3).first.name if @student.kins.where(kintype_id: 3).count > 0}", colspan: 3}, 
           "No. Tel : #{@student.kins.where(kintype_id: 3).first.phone if @student.kins.where(kintype_id: 3).count > 0}"],
          [{content: "Nama Isteri / Waris (sekiranya perlu) : #{@student.kins.where(kintype_id: 1).first.name if @student.kins.where(kintype_id: 3).count > 0}", colspan: 3}, "No. Tel : #{@student.kins.where(kintype_id: 1).first.phone if @student.kins.where(kintype_id: 1).count > 0}"],
          [{content: "Alamat Rumah : #{@student.address}<br> Poskod :", colspan: 4}],
          ["", "", "", ""] ]
          table(data, :column_widths => [50, 200, 120, 140], :cell_style => { :size => 11,  :borders => [:top, :bottom, :left, :right], :inline_format => :true, :padding => [2,5,2,5]})  do
	    row(0).column(0).borders=[:left, :top]
	    row(0).column(1).borders=[:right, :top]
	    row(0).background_color="F0F0F0"
	    row(0).font_style=:bold
	    row(9).height=50
	    row(10).height=40
	    row(11).height=100
	    row(12).borders=[:left, :right]
	    row(17).height=100
	    row(18).borders=[]
	  end
  end
  
  def table_personal_details_pg2
    data=[[{content: "No. Tel Rumah (sekiranya ada) :  ", colspan: 4}], [content: "Nama Anak :", colspan: 4], ["1. ","","5. ",""],  ["2. ","","6. ",""],  ["3. ","","7. ",""],  ["4. ","","8.",""],
          [{content: "Jenis Kenderaan : #{@student.vehicle_type}", colspan: 2}, {content: "No Kenderaan : #{@student.vehicle_no}", colspan: 2}]
          ]
    table(data, :column_widths => [50, 200, 50, 210], :cell_style => {:size => 11, :borders=>[]}) do 
      row(0..1).font_style = :bold
      row(0).borders=[:top, :bottom, :left, :right]
      row(1).borders=[:left, :right]
      row(2..5).column(0).borders=[:left]
      row(2..5).column(3).borders=[:right]
      row(6).column(0).borders=[:left, :top, :bottom]
      row(6).column(2).borders=[:top, :bottom, :right]
    end
    move_down 5
    text "Nota :", :size => 10
    text "1. Kenderaan hanya dibenarkan untuk kursus lanjutan / undang - undang sahaja.", :size => 10
  end 
  
  def table_personal_details_pg2_cont
    data=[["A.", {content: "MAKLUMAT PERIBADI PELATIH (sambungan....)", colspan: 5}],
         [{content: "Pengalaman kerja (sekiranya ada, selain dari APMM)", colspan:6}],
         ["", "Nama Organisasi", "", "Jawatan", "", "Tempat"],
         ["1.", "", "", "", "", ""],
         ["2.", "", "", "", "", ""],
         ["3.", "", "", "", "", ""],
         ["4.", "", "", "", "", ""],
         ["B.", {content: "MAKLUMAT KURSUS / PENGINAPAN / SAJIAN", colspan: 5}],
         [{content: "Nama Kursus : #{@student.course.programme_list}", colspan: 6}],
          [{content: "Tarikh Mula : #{@student.regdate.try(:strftime, '%d-%m-%Y')}", colspan: 6}],
          [{content: "Tarikh Tamat : #{@student.end_training.try(:strftime, '%d-%m-%Y')}", colspan: 6}],
          [{content: "Keperluan Penginapan :", colspan: 6}],
          [{content: "Keperluan Sajian :", colspan: 6}],
          [{content: "Maklumat lanjut Rujuk BK-LAT-KS-02-02 (Borang Kediaman Asrama)", colspan: 6}]
         ]
    table(data, :column_widths => [50, 200, 30, 100, 30, 100], :cell_style => {:size => 11, :borders => []}) do
      row(0).column(0).borders =[:top, :bottom, :left]
      row(0).column(1).borders=[:top, :bottom, :right]
      row(0).background_color = "F0F0F0"
      row(0).font_style=:bold
      row(1).borders=[:left, :right]
      row(2).font_style=:bold
      row(2..5).column(0).borders=[:left]
      row(2..5).column(5).borders=[:right]
      row(6).column(0).borders=[:left, :bottom]
      row(6).column(5).borders=[:right, :bottom]
      row(6).column(1..4).borders=[:bottom]
      row(6).height=30
      
      #row(8..10).borders =[:top, :bottom, :left, :right]
      row(7).column(0).borders=[:left, :bottom]
      row(7).column(1).borders=[:right, :bottom]
      row(7).background_color = "F0F0F0"
      row(7).font_style=:bold
      row(8..10).borders=[:left, :right, :bottom]
      row(10).borders=[:left, :right, :bottom]
      row(11).height=30
      row(11).style :valign => :bottom
      row(11..13).borders=[:left, :right]
      row(13).borders=[:left, :right, :bottom]
    end
    #box for Work experiences
    bounding_box([40, 380], :width =>460, :height => 90) do |y|
      #stroke_bounds
      horizontal_line 0,210, :at => 70
      horizontal_line 220,350, :at => 70 
      horizontal_line 360,460, :at => 70 
      horizontal_line 0,210, :at => 50
      horizontal_line 220,350, :at => 50 
      horizontal_line 360,460, :at => 50
      horizontal_line 0,210, :at => 25
      horizontal_line 220,350, :at => 25 
      horizontal_line 360,460, :at => 25 
      #bwh sekali
      horizontal_line 0,210, :at => 5 
      horizontal_line 220,350, :at => 5 
      horizontal_line 360,460, :at => 5 
    end
    #box for Residency & Meal Requirement --
    bounding_box([200, 195], :width =>200, :height => 40) do |y|
      #stroke_bounds #for checking
      draw_text "Ya", :at => [0,0], :size => 10
      draw_text "Ya", :at => [0, 18], :size => 10
      draw_text "Tidak", :at => [90,0], :size => 10
      draw_text "Tidak", :at => [90, 18], :size => 10
      if @student.tenants.count > 0 
        draw_text "/#{}", :at => [43, 19], :size => 12 #ya Penginapan
	if @student.try(:tenants).last.meal_requirement==true 
          draw_text "/", :at => [43, -2], :size => 12 #ya sajian
	else
	  draw_text "/", :at => [143, -2], :size => 12 #tidak sajian
	end
      else  
        draw_text "/", :at => [143, 19], :size => 12 #tidak penginapan
      end
      horizontal_line 30, 60, :at => -5
      horizontal_line 30, 60, :at => 10
      horizontal_line 30, 60, :at => 15
      horizontal_line 30, 60, :at => 30
      horizontal_line 130, 160, :at => -5
      horizontal_line 130, 160, :at => 10
      horizontal_line 130, 160, :at => 15
      horizontal_line 130, 160, :at => 30
      vertical_line -5, 10, :at => 30
      vertical_line -5, 10, :at => 60
      vertical_line 15, 30, :at => 30
      vertical_line 15, 30, :at => 60
      vertical_line -5, 10, :at =>130
      vertical_line -5, 10, :at =>160
      vertical_line 15, 30, :at => 130
      vertical_line 15, 30, :at => 160
    end
    #
  end
  
  def table_attachments_verifications
    data1=[["C.",{content: "SALINAN REKOD / DOKUMEN / BARANGAN YANG DISERAHKAN (mana-mana yang perlu)", colspan: 8}], [{content: "Senarai Rekod / Dokumen Yang Diserahkan :", colspan: 9}], [{content: "1. Salinan Kad Pengenalan", colspan: 2}, "Ya", "", "Tidak", "", "", "", ""], ["", "", "", "", "", "", "", "", ""], 
   [{content: "2. Salinan Surat Beranak", colspan: 2}, "Ya", "", "Tidak", "", "", "", ""], ["", "", "", "", "", "", "", "", ""], 
   [{content: "3. Salinan Sijil Kelulusan Akademik", colspan: 2}, "Ya", "", "Tidak", "", "", "", ""], ["", "", "", "", "", "", "", "", ""],
   [{content: "4. ____________________________", colspan: 2}, "Ya", "", "Tidak", "", "", "",""], ["", "", "", "", "", "", "", "",""],
   [{content: "5. ____________________________", colspan: 2}, "Ya", "", "Tidak", "", "", "", ""], ["", "", "", "", "", "", "", "",""],
   [{content: "6.____________________________ ", colspan: 2}, "Ya", "", "Tidak", "", "", "", ""], ["", "", "", "", "", "", "", "",""],
   [{content: "Mempunyai Barangan Yang Diserahkan Untuk Simpanan", colspan: 4}, "Ya", "", "Tidak", "", ""], [{content: "", colspan: 9}], [{content: "Maklumat lanjut Rujuk BK-LAT-KS-02-01 (Borang Simpanan Barangan Peribadi Pelatih)", colspan: 9}]
          ]
    data2=[["D.", {content: "PENGESAHAN DAN TANDATANGAN", colspan: 8} ], 
   [{content: "Saya mengesahkan bahawa maklumat yang dinyatakan di atas adalah benar.", colspan: 9}], [{content: "Oleh : Pelatih", colspan: 3},  {content: "Diterima / Disahkan Oleh : KULA/BLA/JL", colspan: 6}], 
   [{content: "Nama Pelatih : <u>#{@student.student_with_rank}</u>", colspan: 3}, {content: "Nama : _______________________________", colspan: 6}],      
   [{content: "Tandatangan : ______________________", colspan: 3}, {content: "Tandatangan : _________________________", colspan: 6}],      
   [{content: "Tarikh : <u>#{Date.today.strftime('%d-%m-%Y')}</u>", colspan: 3},{content: "Tarikh : <u>#{Date.today.strftime('%d-%m-%Y')}</u>", colspan: 6}]
   ]
    
    table(data1+data2, :column_widths => [50, 160, 50, 50, 50,50, 40, 50, 10 ], :cell_style => {:size=>11, :borders => [:left, :right, :top, :bottom], :inline_format => :true}) do
      
      #attachment part
      row(0).background_color="F0F0F0"
      row(0).font_style=:bold
      row(0).column(0).borders=[:left, :top, :bottom]
      row(0).column(1).borders=[:top, :right, :bottom]
      row(1).borders=[:left, :right]
      
      row(2).column(0).borders=[:left]
      row(2).column(2).borders=[]
      row(2).column(4).borders=[]
      row(2).column(6..7).borders=[]
      row(2).column(8).borders=[:right]
      row(3).column(0).borders=[:left]
      row(3).column(8).borders=[:right]
      row(3).column(1..7).borders=[]
      
      row(4).column(0).borders=[:left]
      row(4).column(2).borders=[]
      row(4).column(4).borders=[]
      row(4).column(6..7).borders=[]
      row(4).column(8).borders=[:right]
      row(5).column(0).borders=[:left]
      row(5).column(8).borders=[:right]
      row(5).column(1..7).borders=[]
      
      row(6).column(0).borders=[:left]
      row(6).column(2).borders=[]
      row(6).column(4).borders=[]
      row(6).column(6..7).borders=[]
      row(6).column(8).borders=[:right]
      row(7).column(0).borders=[:left]
      row(7).column(8).borders=[:right]
      row(7).column(1..7).borders=[]
      
      row(8).column(0).borders=[:left]
      row(8).column(2).borders=[]
      row(8).column(4).borders=[]
      row(8).column(6..7).borders=[]
      row(8).column(8).borders=[:right]
      row(9).column(0).borders=[:left]
      row(9).column(8).borders=[:right]
      row(9).column(1..7).borders=[]
      
      row(10).column(0).borders=[:left]
      row(10).column(2).borders=[]
      row(10).column(4).borders=[]
      row(10).column(6..7).borders=[]
      row(10).column(8).borders=[:right]
      row(11).column(0).borders=[:left]
      row(11).column(8).borders=[:right]
      row(11).column(1..7).borders=[]
      
      row(12).column(0).borders=[:left]
      row(12).column(2).borders=[]
      row(12).column(4).borders=[]
      row(12).column(6..7).borders=[]
      row(12).column(8).borders=[:right]
      row(13).column(0).borders=[:left]
      row(13).column(8).borders=[:right]
      row(13).column(1..7).borders=[]
      
      row(14).column(0).borders=[:left]
      row(14).column(8).borders=[:right]
      row(14).column(4).borders=[]
      row(14).column(6).borders=[]
      
      row(15).borders=[:left, :right]
      row(16).borders=[:left, :right, :bottom]
      
      column(2).style :align => :center
      row(2..14).column(4).style :align => :center
      
      #verification part
      row(17).column(0).borders=[:left, :bottom]
      row(17).column(1).borders=[:bottom, :right]
      row(17).background_color="F0F0F0"#row verification title
      row(17).font_style=:bold
      row(18).borders=[:left, :right] 
      row(19).column(0).borders=[:left]
      row(19).column(3).borders=[:right]
      row(19).font_style=:bold
      row(20..21).column(0).borders=[:left]
      row(20..21).column(3).borders=[:right]
      row(22).column(0).borders=[:left, :bottom]
      row(22).column(3).borders=[:right, :bottom]
      row(22).height=40
    end
  end
  
  def table_notes
    data=[[{content: "Nota :", colspan: 2}], ["1.", "Borang perlu diisi dalam 2 salinan untuk :"],
          ["", "Simpanan Fail Peribadi : 1 salinan"],
          ["", "Simpanan Pelatih : 1 salinan"]
          ]
    table(data, :column_widths => [20, 490], :cell_style => {:size => 10, :padding => [0,5,0,5], :borders => []}) do
      row(0).font_style=:bold
      row(0..1).height=30
      row(0).borders=[:left, :right, :top]
      row(1..2).column(0).borders=[:left]
      row(1..2).column(1).borders=[:right]
      row(3).column(0).borders=[:left, :bottom]
      row(3).column(1).borders=[:right, :bottom]
      row(3).height=30
    end
  end
  
  def table_ending
    data=[["#{I18n.t('instructor_appraisal.prepared').upcase}: IMPLEMENTASI LATIHAN","#{I18n.t('exam.evaluate_course.date_updated')} : #{@student.updated_at.try(:strftime, '%d-%m-%Y')} "]]
    table(data, :column_widths => [310,200], :cell_style => {:size=>11, :borders => [:left, :right, :top, :bottom]}) do
      a = 0
      b = 1
      column(0).font_style = :bold
      column(1).font_style = :bold
      while a < b do
        a=+1
      end
    end
  end
  
  def footer
    draw_text "BK-LAT-KS-02-03", :size => 8, :at => [0, -5]
    draw_text "#{page_number} #{I18n.t('instructor_appraisal.from')} 3",  :size => 10, :at => [450,-5]
  end
  
  def table1
    data =[["Butiran Peribadi", " "],
          ["1. MyKad No", ": #{@student.try(:formatted_mykad)}"],
          ["2. Nama", ": #{@student.try(:name)}"],
          ["3. No Matrik", ": #{@student.try(:matrixno)}"],
          ["4. Status", ": #{@student.try(:sstatus)}"],
          ["5. No. Telefon",": #{@student.try(:stelno)}"],
          ["6. Alamat", ": #{@student.try(:address)}"],
          ["7. Alamat Bertugas", ": #{@student.try(:address_posbasik)}"],
          ["8. Penganjur", ": #{@student.try(:ssponsor)}"],
          ["9. Jantina",": #{(Student::GENDER.find_all{|disp, value| value == @student.gender.to_s}).map {|disp, value| disp} [0]} "],
          ["10. Tarikh Lahir", ": #{@student.try(:sbirthdt).try(:strftime, '%d %b %Y')}"],
          ["11. Taraf Perkahwinan", ": #{(Student::MARITAL_STATUS.find_all{|disp, value| value == @student.mrtlstatuscd.to_s}).map {|disp, value| disp} [0]} "],
          ["12. Emel", ": #{@student.try(:semail)}" ],
          ["13. Tarikh Pendaftaran", ": #{@student.try(:regdate).try(:strftime, '%d %b %Y')}"]]
          
          table(data, :column_widths => [150, 250], :cell_style => { :size => 11})  do
            a = 0
            b = 25
            row(0).font_style = :bold
            row(0).background_color = 'FFE34D'
            while a < b do
            row(a).borders = []
            a += 1
          end
            
          end
        move_down 10
       end
       
  
  def table2
  
    data = [["Maklumat Kursus", ""],
           ["14. Nama Kursus", ": #{@student.course_id.blank? ? " " : @student.course.programme_list}"], 
           ["15. Sesi Pengambilan",": #{@student.intake.blank? ? "-" : @student.intake.strftime("%B %Y")}"], 
           ["16. Catatan",": #{@student.course_remarks}"]] 
        
          table(data, :column_widths => [150, 250], :cell_style => { :size => 11})  do
            a = 0
            b = 5
            row(0).font_style = :bold
            row(0).background_color = 'FFE34D'
            while a < b do
            row(a).borders = []
            a += 1
          end
          end
       move_down 10
          end
      end
      
  def table3

    data =[["Status Kesihatan", ""],
          ["17. Fizikal", ": #{@student.try(:physical)}"],
          ["18. Alergik", ": #{@student.try(:allergy)}"],
          ["19. Penyakit", ": #{@student.try(:disease)}"],
          ["20. Jenis Darah", ": #{(Student::BLOOD_TYPE.find_all{|disp, value| value == @student.bloodtype.to_s}).map {|disp, value| disp} [0]}"], 
          ["21. Ubat", ": #{@student.try(:physical)}"],
          ["22. Catatan", ": #{@student.try(:remarks)}"]]
               
          table(data, :column_widths => [150, 250], :cell_style => { :size => 11})  do
          a = 0
          b = 8
          row(0).font_style = :bold
          row(0).background_color = 'FFE34D'
          while a < b do
          row(a).borders = []
          a += 1
          end
             
          end
        move_down 10
          end
          
          def table4
            start_new_page
            
            data =[["Kelayakan Akademik", ""]]

                  table(data, :column_widths => [150, 250], :cell_style => { :size => 11})  do
                    row(0).font_style = :bold
                    row(0).background_color = 'FFE34D'
                    row(0).borders = []
                  end
                  
                  @q = @student.qualifications
                  
                  if @q.count > 0
                  data2 = 
                   @student.qualifications.map do |qualification|
                  ["#{(DropDown::QTYPE.find_all{|disp, value| value == qualification.level_id}).map {|disp, value| disp}[0]} ", ": #{qualification.try(:qname)} dari #{qualification.institute}"]
                end
              else
                data2 = [["",""]]
              end
                table(data2, :column_widths => [150, 250], :cell_style => { :size => 10}) do
                row(0).borders = []
                end
                
                @spm = @student.spmresults.map
                
                if @spm.count > 0
                data3 = 
                 @student.spmresults.map do |spmresult|
                ["#{spmresult.spm_subject}  ", "- #{spmresult.grade} "]
              end
            else 
              data3 = [["",""]]
            end
            
              table(data3, :column_widths => [150, 250], :cell_style => { :size => 10}) do
                a = 0
                b = 13
                while a < b do
                row(a).borders = []
                a += 1
              end
              end
                  
              move_down 10
               end
           
           def table5
             

             data =[["Penjamin",""],
                   ["23. Maklumat Penjamin",": "],
                   ["a. Hubungan", ": Penjamin I"]]
                   table(data, :column_widths => [150, 250], :cell_style => { :size => 11})  do
                     a = 0
                     b = 11
                     row(0).font_style = :bold
                     row(0).background_color = 'FFE34D'
                     while a < b do
                     row(a).borders = []
                     a += 1
                   end  
                   end
                   
                puid = @student.id
                @garantor = Kin.where("student_id = ? AND kintype_id = ? ", puid,  98 )
                 
                if @garantor.count > 0
                   data2 = 
                    @garantor.map do |e|
                   ["b. Nama", ": #{e.name} "]
                 end
               else
                 data2 = [["", ""]]
               end
                 table(data2, :column_widths => [150, 250], :cell_style => { :size => 10}) do
                   row(0).borders = []
                 end
                 
                 if @garantor.count > 0
                 data3 = 
                  @garantor.map do |e|
                 ["c. MyKad No", ": #{e.mykadno} "]
               end
           else
             data3 = [["", ""]]
           end
               table(data3, :column_widths => [150, 250], :cell_style => { :size => 10}) do
                 row(0).borders = []
               end
               
               if @garantor.count > 0
               add = 
                @garantor.map do |e|
               ["d. Alamat", ": #{e.kinaddr} "]
             end
           else
             add = [["", ""]]
           end
             table(add, :column_widths => [150, 250], :cell_style => { :size => 10}) do
               row(0).borders = []
             end
             
             data4 = [["e. Hubungan", ": Penjamin II"]]
             table(data4, :column_widths => [150, 250], :cell_style => { :size => 10}) do
               row(0).borders = []
             end
             
             
             puid = @student.id
             @garantor1 = Kin.where("student_id = ? AND kintype_id = ? ", puid,  99)
             
              if @garantor1.count > 0
             nama = 
              @garantor1.map do |e|
             ["f. Nama", ": #{e.name} "]
           end
         else
           nama = [["", ""]]
         end
           table(nama, :column_widths => [150, 250], :cell_style => { :size => 10}) do
             row(0).borders = []
           end
           
           if @garantor1.count > 0
           kadno = 
            @garantor1.map do |e|
           ["g. MyKad No", ": #{e.mykadno} "]
         end
       else
         kadno = [["", ""]]
       end
         table(kadno, :column_widths => [150, 250], :cell_style => { :size => 10}) do
           row(0).borders = []
         end
         
         if @garantor1.count > 0
         add2 = 
          @garantor1.map do |e|
         ["h. Alamat", ": #{e.kinaddr} "]
       end
     else
       add2 = [["", ""]]
     end
       table(add2, :column_widths => [150, 250], :cell_style => { :size => 10}) do
         row(0).borders = []
       end
                         
                   move_down 10
                    end


        def table6

          data =[["Waris Terdekat",""]]


                table(data, :column_widths => [150, 250], :cell_style => { :size => 11})  do
                  row(0).font_style = :bold
                  row(0).background_color = 'FFE34D'
                  row(0).borders = []
                end
                
                puid = @student.id
                @thekins = Kin.where("student_id = ? AND kintype_id != ? AND kintype_id != ? ", puid,  98, 99)
                
                if @thekins.count > 0
                data5 = 
                 @thekins.map do |e|
                ["a. Hubungan", ": #{(DropDown::KIN_TYPE.find_all{|disp, value| value == e.kintype_id}).map {|disp, value| disp} [0]} "]
              end
            else
              data5 = [["", ""]]
            end    
              table(data5, :column_widths => [150, 250], :cell_style => { :size => 10}) do
                row(0).borders = []
              end
                
                if @thekins.count > 0
                data1 = 
                 @thekins.map do |e|
                ["b. Nama", ": #{e.name} "]
              end
            else
              data1 = [["", ""]]
            end 
              table(data1, :column_widths => [150, 250], :cell_style => { :size => 10}) do
                row(0).borders = []
              end
              
              if @thekins.count > 0
              data2 = 
               @thekins.map do |e|
              ["c. Tarikh Lahir", ": #{e.kinbirthdt} "]
            end
          else
            data2 = [["", ""]]
          end 
            table(data2, :column_widths => [150, 250], :cell_style => { :size => 10}) do
              row(0).borders = []
            end
            
            if @thekins.count > 0
            data3 = 
             @thekins.map do |e|
            ["d. No Telefon", ": #{e.phone} "]
          end
        else
          data3 = [["", ""]]
        end 
          table(data3, :column_widths => [150, 250], :cell_style => { :size => 10}) do
            row(0).borders = []
          end
          
          if @thekins.count > 0
          data4 = 
           @thekins.map do |e|
          ["e. Alamat", ": #{e.kinaddr} "]
        end
      else
        data4 = [["", ""]]
      end 
        table(data4, :column_widths => [150, 250], :cell_style => { :size => 10}) do
          row(0).borders = []
        end

end