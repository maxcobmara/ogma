class Borang_maklumat_pelajarPdf < Prawn::Document
  def initialize(student, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @student = student
    @view = view

    
    
    font "Times-Roman"
    text "KOLEJ KEJURURAWATAN JOHOR BAHRU", :align => :center, :size => 14, :style => :bold
    move_down 5
    text "KUMPULAN:",  :align => :center, :size => 14, :style => :bold
    move_down 5
    text "BORANG MAKLUMAT PELATIH", :align => :center, :size => 14, :style => :bold
    move_down 20
    table1
    table2
    table3
    table4
    table5
    table6
  
  end
  
  def table1
    
    data =[["Butiran Peribadi", "#{@student.id}"],
          ["1. MyKad No", ": #{@student.try(:formatted_mykad)}"],
          ["2. Nama", ": #{@student.try(:name)}"],
          ["3. No Matrik", ": #{@student.try(:matrixno)}"],
          ["4. Status", ": #{@student.try(:sstatus)}"],
          ["5. No. Telefon",": #{@student.try(:stelno)}"],
          ["6. Alamat", ": #{@student.try(:address)}"],
          ["7. Alamat Bertugas", ": #{@student.try(:address_posbasik)}"],
          ["8. Penganjur", ": #{@student.try(:ssponsor)}"],
          ["9. Jantina",": #{(Student::GENDER.find_all{|disp, value| value == @student.gender.to_s}).map {|disp, value| disp} [0]} "],
          ["10. Tarikh Lahir", ": #{@student.try(:sbirthdt)}"],
          ["11. Taraf Perkahwinan", ": #{(Student::MARITAL_STATUS.find_all{|disp, value| value == @student.mrtlstatuscd.to_s}).map {|disp, value| disp} [0]} "],
          ["12. Emel", ": #{@student.try(:semail)}" ],
          ["13. Tarikh Pendaftaran", ": #{@student.try(:regdate)}"]]
          
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
           ["14. Nama Kursus", ": #{@student.course_id.blank? ? " " : @student.course_id}"], 
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

            data =[["Kelayakan Akademik", ""],
                  ["SPM/SPVM dan setaraf", ":"],
                  ["Keputusan SPM", ": "]]

                  table(data, :column_widths => [150, 250], :cell_style => { :size => 11})  do
                    a = 0
                    b = 4
                    row(0).font_style = :bold
                    row(0).background_color = 'FFE34D'
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
                   ["a. Hubungan", ": Penjamin I"],
                   ["b. Nama",": "],
                   ["c. MyKad No", ": "],
                   ["d. Alamat",": "],
                   ["e. Hubungan", ": Penjamin II"],
                   ["f. Nama",": "],
                   ["g. MyKad No", ": "],
                   ["h. Alamat", ": "]]

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
                   move_down 10
                    end


        def table6

          data =[["Waris Terdekat",""],
                ["a. Hubungan", ": "],
                ["b. Nama",": "],
                ["c. Tarikh Lahir", ": "],
                ["d. No Telefon",": "],
                ["e. Alamat", ": "]]


                table(data, :column_widths => [150, 250], :cell_style => { :size => 11})  do
                  a = 0
                  b = 7
                  row(0).font_style = :bold
                  row(0).background_color = 'FFE34D'
                  while a < b do
                  row(a).borders = []
                  a += 1
                end
             
                end
              end