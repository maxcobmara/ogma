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
      amsas_heading
      move_down 10
      table_pesonal_details
      move_down 10
      table_ending
      page_count.times do |i|
        go_to_page(i+1)
        footer
      end
      ###
    end
  end
  
  def amsas_heading
    bounding_box([10,770], :width => 400, :height => 100) do |y2|
        image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
      end
      bounding_box([430,770], :width => 400, :height => 90) do |y2|
        image "#{Rails.root}/app/assets/images/amsas_logo_small.png"
      end
      bounding_box([150,750], :width => 350, :height => 100) do |y2|
          draw_text "PPL APMM", :at => [70, 105], :style => :bold, :size => 14
          draw_text "#{I18n.t('instructor_appraisal.document_no').upcase} : BK-LAT-KS-02-03", :at => [5, 80], :style => :bold, :size => 14
          draw_text "BORANG MAKLUMAT PERIBADI", :at => [-10, 65], :style => :bold, :size => 14
	  draw_text "PUSAT PENDIDIKAN DAN LATIHAN APMM", :at => [8, 35], :style => :bold, :size => 11
	  draw_text "AGENSI PENGUATKUASAAN MARITIM MALAYSIA", :at => [-10, 23], :style => :bold, :size => 11
	  draw_text "JABATAN PERDANA MENTERI", :at => [35, 11], :style => :bold, :size => 11  
      end
      text "BORANG MAKLUMAT PERIBADI", :align => :center, :style => :bold, :size => 14
      text "(Diisi dalam 2 salinan)", :align => :center, :size => 9
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
  
  def table_pesonal_details
    data=[["A.", {content: "MAKLUMAT PERIBADI PELATIH", colspan: 3}],[{content: "Nama Pelatih : #{@student.try(:name)}", colspan: 4}],
              [{content: "No. K/P (Baru) : #{@student.try(:formatted_mykad)}", colspan: 2}, {content: "Umur : #{@student.try(:age)}", colspan: 2}],
              [{content: "Tarikh Lahir : #{@student.try(:sbirthdt).try(:strftime, '%d-%m- %Y')}", colspan: 2},{content: "Tempat Lahir :" , colspan: 2}], 
              [{content: "Jantina : #{@student.gender==1? '<b>LELAKI</b> / PEREMPUAN' : 'Lelaki / <b>PEREMPUAN</b>'}", colspan: 2},
               {content: "Status Perkahwinan : #{@student.mrtlstatuscd}", colspan: 2}],
              [{content: "No. APMM : ", colspan: 2},{content: "No. Kad Kuasa :", colspan: 2}],
	      [{content: "No. Insuran :", colspan: 2},{content: "Jenis Insuran", colspan: 2}],
              [{content: "Jenis Darah : #{@student.bloodtype}", colspan: 4}],
	      [{content: "Bangsa / Keturunan : #{@student.try(:race)}", colspan: 2},{content: "Agama :", colspan: 2}],
	      [{content: "Kelulusan Akademik : SPM / STPM / DIPLOMA / IJAZAH / MASTER / PHD", colspan: 2},{content: "No. Tel Bimbit", colspan: 2}],
              [{content: "Pangkat : ", colspan: 2},{content: "Unit  / Bahagian / Cawangan", colspan: 2}], [{content: "Alamat Pejabat #{@student.try(:address_posbasik)}", colspan: 4}],
          [{content: "Poskod : ", colspan: 2},{content: "No. Tel Pejabat : ", colspan: 2}],
          [{content: "Emel (sekiranya ada) :", colspan: 4}],
          [{content: "Nama Bapa : ", colspan: 3}, "No. Tel :"],
          [{content: "Nama Ibu", colspan: 3}, "No. Tel :"],
          [{content: "Nama Isteri / Waris (sekiranya perlu) : ", colspan: 3}, "No. Tel :"],
          [{content: "Alamat Rumah : #{@student.address}<br> Poskod :", colspan: 4}],
          ["", "", "", ""] ]
          table(data, :column_widths => [50, 200, 60, 200], :cell_style => { :size => 11,  :borders => [:top, :bottom, :left, :right], :inline_format => :true, :padding => [2,5,2,5]})  do
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