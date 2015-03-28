class Borang_maklumat_pelajarPdf < Prawn::Document
  def initialize(student, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @student = student
    @view = view

    
    
    font "Times-Roman"
    text "KOLEJ KEJURURAWATAN JOHOR BAHRU", :align => :center, :size => 14, :style => :bold
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