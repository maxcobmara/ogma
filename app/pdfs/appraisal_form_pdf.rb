class Appraisal_formPdf < Prawn::Document
  def initialize(staff_appraisal, curr_user, view)
    super({top_margin: 50, left_margin: 38, page_size: 'A4', page_layout: :portrait})
    @staff_appraisal = staff_appraisal
    @view = view
    @curr_user=curr_user
    #font " "
     
    #refer ogma/config/initializers/prawn_extensions.rb 
    #https://www.bunkus.org/blog/2009/07/different-background-images-and-page-layouts-in-a-single-pdf-with-prawn/
    #works for tables that automatically span into new pages (background), as 'color' must be called upon new page creation (note cursor position)
    #http://inboxhealthinterns.blogspot.com/2014/07/using-prawn-to-dynamically-generate-pdfs.html
    #calling 'color' after text/table already displayed, will cover text/table 
    run_after_new_page do
      color
    end
    
    
    def color_4
    #fill_color "FAFAD2" 
    #fill_rectangle [-40, 900], 1200, 1000
 
                fill_color 'FAFAD2'
                fill_and_stroke_rectangle [-40, 900], 1200, 1000
                fill_color '000000'

  end
  def color_3
              
              fill_color 'BBEEBB'
              fill_and_stroke_rectangle [-40, 900], 1200, 1000
              fill_color '000000'

end
  def color_5

              fill_color 'FAF0E6'
              fill_and_stroke_rectangle [-40, 900], 1200, 1000
              fill_color '000000'

end
def color
   if @staff_appraisal.person_type == 4
      color_4
      
    elsif @staff_appraisal.person_type == 5
      color_5
      
    elsif @staff_appraisal.person_type == 3
      color_3
    end
 end

    color   
    text "BORANG J.P.A. (Prestasi) #{@staff_appraisal.person_type}", :align => :right, :size => 12, :style => :bold, :color => "010000"
    text "SULIT", :align => :left, :size => 12
    
    text "No. K.P : #{@staff_appraisal.appraised.formatted_mykad}", :align => :right, :size => 12, :style => :bold
    #bounding_box([430, 730], :width => 100) do
     #     text "#{@staff_appraisal.appraised.formatted_mykad}"
      #          stroke_bounds
       # end
    move_down 10
    if @staff_appraisal.person_type == 4
       image "#{Rails.root}/app/assets/images/kerajaan4.png", :position => :center
      
     elsif @staff_appraisal.person_type == 5
       image "#{Rails.root}/app/assets/images/kerajaan5.png", :position => :center
      
     elsif @staff_appraisal.person_type == 3
       image "#{Rails.root}/app/assets/images/kerajaan3.png", :position => :center
     end
    
    text "KERAJAAN MALAYSIA", :align => :center, :size => 12, :style => :bold   
    move_down 10
    text "LAPORAN PENILAIAN PRESTASI", :align => :center, :size => 12, :style => :bold    
    text "PEGAWAI KUMPULAN #{@staff_appraisal.try(:person_type_description)}", :align => :center, :size => 12, :style => :bold 
    text "Tahun #{(@staff_appraisal.evaluation_year).year}", :align => :center, :size => 10, :style => :bold 
    move_down 10
    tajuk1
    bahagian1
    bahagian2a
    table_bahagian2
    bahagian2b
    table_latihan2b
    bahagian2b2
    table_latihan3
    bahagian2b3
    bahagian3  #line 
    if @staff_appraisal.person_type == 4
    bahagian4_4 #line 
    bahagian5_4  #line 422
    elsif @staff_appraisal.person_type == 5
    bahagian4_5
    bahagian5_5
    elsif @staff_appraisal.person_type == 3   
    bahagian4_3 #line 351
    bahagian5_3
  end
    bahagian6 #line 686
    bahagian7 
    bahagian8 #line 736
    bahagian9 
    lampiranA #line 822
    lampiranA1 
    table_lampiranA1 
    lampiranA1a 
    lampiranA2 #line 916
    table_lampiranA2
    lampiranA2b #line 933
    table_lampiranAa3
    lampiranA3a
    if y < 250 
      start_new_page
    end
    lampiranA3b
    lampiranA3c
    
    string = " <page>"
      # Green page numbers 1 to 7
      options = { :at => [bounds.right - 395, 0],
                  :width => 150,
                  :align => :right,
                  :page_filter => (1..12),
                  :start_count_at => 1,
                  :color => "010000" }
      number_pages string, options
    
  end
  
  def tajuk1
    data = [["PERINGATAN"],
           ["Pegawai Penilai (PP) iaitu Pegawai Penilai Pertama (PPP) dan Pegawai Penilai Kedua (PPK) serta Pegawai Yang Dinilai (PYD) hendaklah memberi perhatian kepada perkara-perkara berikut sebelum dan semasa membuat penilaian:" ]]
   
    table(data , :column_widths => [520], :cell_style => { :size => 10}) do
      row(0).align = :center
     row(0).borders = [:left, :right, :top]
     row(1).borders = [:left, :right]
     row(0).font_style = :bold
     self.row_colors = ["FEFEFE", "FFFFFF"]

    end 
    
    data1 = [['	i.', "PYD hendaklah melengkapkan maklumat di Bahagian I di bawah dan Bahagian I dalam borang Sasaran Kerja Tahunan (SKT) seperti di Lampiran 'A' pada awal tahun;"],
      ["ii.","PYD hendaklah melengkapkan Bahagian II manakala PP hendaklah melengkapkan Bahagian III hingga Bahagian IX pada akhir tahun penilaian;"],
      ["iii.", "PYD dan PP hendaklah merujuk Panduan Pelaksanaan Sistem Penilaian Prestasi Anggota Perkhidmatan Awam Malaysia (Tahun 2002) sekiranya memerlukan keterangan lanjut semasa mengisi Borang Laporan Penilaian Prestasi Tahunan (LNPT) dan membuat penilaian;"],
        ["	iv.", "PP hendaklah menggunakan Skala Penilaian Prestasi seperti di Lampiran 'B'; dan"],
        ["v.", "PPP hendaklah memaklumkan kepada PYD langkah-langkah meningkatkan prestasi/kemajuan kerjaya yang perlu dilakukan sebelum menandatangani di ruangan Bahagian VIII."]]
      
          table(data1, :column_widths => [30,490], :cell_style => { :size => 10}) do
           row(0).column(0).borders = [:left]
           row(0).column(1).borders = [:right]
           row(1).column(0).borders = [:left]
           row(1).column(1).borders = [:right]
           row(2).column(0).borders = [:left]
           row(2).column(1).borders = [:right]
           row(3).column(0).borders = [:left]
           row(3).column(1).borders = [:right]
           row(4).column(0).borders = [:left, :bottom]
           row(4).column(1).borders = [:right, :bottom]
           self.row_colors = ["FEFEFE", "FFFFFF"]
      end
      move_down 40
  end
  
  def bahagian1

    text "BAHAGIAN 1 - MAKLUMAT PEGAWAI", :align => :left, :size => 12, :style => :bold     
    text "(Diisi oleh PYD)", :align => :left, :size => 12, :indent_paragraphs => 30
    move_down 20
    data1 = [['	i.', "Nama : #{@staff_appraisal.appraised.name} "],
      ["ii.","Jawatan dan Gred : #{@staff_appraisal.appraised.positions[0].try(:name)} .. #{@staff_appraisal.appraised.staffgrade.name}"],
      ["iii.", "Kementerian/Jabatan : Kolej Sains Kesihatan Bersekutu Johor Bahru"]]
      
          table(data1 , :column_widths => [30,490], :cell_style => { :size => 10}) do
          row(0).column(0).borders = [:left, :top]
          row(0).column(1).borders = [:right, :top]
          row(1).column(0).borders = [:left]
          row(1).column(1).borders = [:right]
          row(2).column(0).borders = [:left, :bottom]
          row(2).column(1).borders = [:right, :bottom]
          self.row_colors = ["FEFEFE", "FFFFFF","FEFEFE", "FFFFFF"]
           
     end
     move_down 20
end
  
  
  def bahagian2a
    start_new_page
    color
    text "BAHAGIAN II - KEGIATAN DAN SUMBANGAN DI LUAR TUGAS RASMI/LATIHAN", :align => :left, :size => 12, :style => :bold     
    text "(Diisi oleh PYD)", :align => :left, :size => 12, :indent_paragraphs => 20
    move_down 20
    text "1. KEGIATAN DAN SUMBANGAN DI LUAR TUGAS RASMI", :align => :left, :size => 12, :style => :bold     
    move_down 10
    text "Senaraikan kegiatan dan sumbangan di luar tugas rasmi seperti sukan/pertubuhan/sumbangan kreatif di peringkat Komuniti/Jabatan/Daerah/Negeri/Negara/Antarabangsa yang berfaedah kepada Organisasi/Komuniti/Negara pada tahun yang dinilai.", :align => :left, :size => 12
    move_down 10
 end
    
    def table_bahagian2
    
      table line_item_rows do
        row(0).background_color = 'FFFFFF'
        row(0).font_style = :bold
        self.row_colors = ["FEFEFE", "FFFFFF"]
        self.header = true
        self.cell_style = { size: 9 }
        self.width = 525
        header = true
      end
    end
    
    
    def line_item_rows
      counter = counter || 0
      header = [[ 'Senarai kegiatan/aktiviti/sumbangan', 'Peringkat kegiatan/aktiviti/sumbangan (nyatakan jawatan atau pencapaian)']]
      header +
        @staff_appraisal.evactivities.map do |evactivity|
        ["#{evactivity.evactivity}", "#{(DropDown::EVACT.find_all{|disp, value| value == evactivity.actlevel}).map {|disp, value| disp}[0]}"]
      end
    end  
  
    def bahagian2b
     move_down 30
     
    text "2. Latihan", :align => :left, :size => 12, :style => :bold   
    move_down 10
    text "	i.	Senaraikan program latihan (seminar, kursus, bengkel dan lain-lain) yang dihadiri dalam tahun yang dinilai.", :align => :left, :size => 12
     move_down 10
   end
   
     def table_latihan2b
    
       table line_item_rows2 do
         row(0).background_color = 'FFFFFF'
         row(0).font_style = :bold
         self.row_colors = ["FEFEFE", "FFFFFF"]
         self.header = true
         self.cell_style = { size: 9 }
         self.width = 525
         header = true
       end
     end
    
    
     def line_item_rows2
       ptdoyear=@staff_appraisal.evaluation_year.year
       year_start=Date.new(ptdoyear,1,1)
       nextyear_start=year_start+1.year 
       schedule_of_ptdoyear=Ptschedule.where('start >=? and start <?', year_start, nextyear_start).pluck(:id)
       counter = counter || 0
       header = [[ 'Nama Latihan (Nyatakan sijil jika ada)', 'Tarikh/Tempoh', ' Tempat']]
       header +
         Ptdo.where('staff_id = ? and ptschedule_id IN(?)',@staff_appraisal.appraised, schedule_of_ptdoyear).map do |ptdo|
         ["#{ptdo.ptschedule.course.name}", "#{ptdo.ptschedule.start.try(:strftime, "%d-%m-%Y")} / #{ptdo.ptschedule.course.course_total_days}", "#{ptdo.ptschedule.location}"]
       end
     end   
     
     def bahagian2b2
     move_down 20
    text " ii. Senaraikan latihan yang diperlukan.", :align => :left, :size => 12
     move_down 10
   end
     
     def table_latihan3
    
       table line_item_rows3 do
         row(0).background_color = 'FFFFFF'
         row(0).font_style = :bold
         self.row_colors = ["FEFEFE", "FFFFFF"]
         self.header = true
         self.cell_style = { size: 9 }
         self.width = 525
         header = true
       end
     end
    
    
     def line_item_rows3
       counter = counter || 0
       header = [[ 'Nama/Bidang Latihan', 'Sebab Diperlukan']]
       header +
         @staff_appraisal.trainneeds.map do |trainneed|
         [ "#{trainneed.name}", "#{trainneed.reason}"]
       end
     end  
     
     def bahagian2b3     
     move_down 30
    text "Saya mengesahkan bahawa semua kenyataan di atas adalah benar.", :align => :left, :size => 12 
     move_down 20
     
     data1 = [["#{@staff_appraisal.appraised.name}"," #{@staff_appraisal.submit_for_evaluation_on.try(:strftime, '%d-%m-%Y')}"],
           [ "Tandatangan PYD", "Tarikh"]] 
           
           table(data1 , :column_widths => [261,260], :cell_style => { :size => 11}) do
             row(0).font_style = :bold
             row(1).borders = [ ] 
             row(1).align = :center
	     column(1).align = :center
             row(0).background_color = 'FFFFFF'
           end
end


def bahagian3
  start_new_page
  color
  text "BAHAGIAN III - PENGHASILAN KERJA ( Wajaran 50% )", :align => :left, :size => 12, :style => :bold   
  move_down 20  
  text "Pegawai Penilai dikehendaki memberikan penilaian berdasarkan pencapaian kerja sebenar PYD berbanding dengan SKT yang ditetapkan. Penilaian hendaklah berasaskan kepada penjelasan setiap kriteria yang dinyatakan di bawah dengan menggunakan skala 1 hingga 10 :", :align => :left, :size => 12
  move_down 10
  
  data1 = [["", "KRITERIA (Dinilai berasaskan SKT)", "PPP", "PPK"],
           ["1.", "   KUANTITI HASIL KERJA", "", ""],
           ["","Kuantiti hasil kerja seperti jumlah bilangan, kadar, kekerapan dan sebagainya berbanding dengan sasaran kuantiti 
             kerja yang ditetapkan.", "#{@staff_appraisal.e1g1q1}" , "#{@staff_appraisal.e2g1q1 if @staff_appraisal.viewable(@curr_user) == "display" }" ],
             ["2. ","  KUALITI HASIL KERJA", "",""],
             ["2.1. ","Dinilai dari segi kesempurnaan, teratur dan kemas.", "#{@staff_appraisal.e1g1q2}","#{@staff_appraisal.e2g1q2 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["2.2."," Dinilai dari segi usaha dan inisiatif untuk mencapai kesempurnaan hasil kerja.","#{@staff_appraisal.e1g1q3 }","#{@staff_appraisal.e2g1q3 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["3. ","  KETEPATAN MASA","",""],
             ["","Kebolehan menghasilkan kerja atau melaksanakan tugas dalam tempoh masa yang ditetapkan.","#{@staff_appraisal.e1g1q4}","#{@staff_appraisal.e2g1q4 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["4. ","  KEBERKESANAN HASIL KERJA", "",""],
             ["","Dinilai dari segi memenuhi kehendak 'stake-holder' atau pelanggan.","#{@staff_appraisal.e1g1q5}","#{@staff_appraisal.e2g1q5 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["", "Jumlah markah mengikut wajaran","#{@staff_appraisal.e1g1_total} / 50 x 50 = #{@view.number_with_precision(@staff_appraisal.e1g1_percent, precision: 2, locale: "en") }","#{@staff_appraisal.e1g2_total if @staff_appraisal.viewable(@curr_user) == "display" } / 50 x 50 = #{@view.number_with_precision(@staff_appraisal.e2g1_percent, precision: 2, locale: "en") if @staff_appraisal.viewable(@curr_user) == "display" }"]]
             
       table(data1 , :column_widths => [30, 291,100,100], :cell_style => { :size => 10}) do
         row(0).column(1).align = :center
         column(2).align = :center  
         column(3).align = :center        
         row(0).column(0).borders = [:left, :top]
         row(0).column(1).borders = [:right, :top]
         row(1).font_style = :bold
         row(1).column(0).borders = [:left, :top]
         row(1).column(1).borders = [:right, :top]
         row(1).column(2).borders = [ ]
         row(1).column(3).borders = [:right, :left]
         row(2).column(0).borders = [:left]
         row(2).column(1).borders = [:right]
         row(2).column(2).borders = [ ]
         row(2).column(3).borders = [:right, :left]
         row(3).column(0).borders = [:left, :top]
         row(3).column(1).borders = [:right, :top]
         row(3).column(2).borders = [ :top ]
         row(3).column(3).borders = [:right, :left, :top]
         row(3).font_style = :bold
         row(4).column(0).borders = [:left]
         row(4).column(1).borders = [:right]
         row(4).column(2).borders = [ ]
         row(4).column(3).borders = [:right, :left]
         row(5).column(0).borders = [:left]
         row(5).column(1).borders = [:right]
         row(5).column(2).borders = [ ]
         row(5).column(3).borders = [:right, :left]
         row(6).column(0).borders = [:left, :top]
         row(6).column(1).borders = [:right, :top]
         row(6).column(2).borders = [ :top ]
         row(6).column(3).borders = [:right, :left, :top]
         row(6).font_style = :bold
         row(7).column(0).borders = [:left]
         row(7).column(1).borders = [:right]
         row(7).column(2).borders = [ ]
         row(7).column(3).borders = [:right, :left]
         row(8).column(0).borders = [:left, :top]
         row(8).column(1).borders = [:right, :top]
         row(8).column(2).borders = [ :top ]
         row(8).column(3).borders = [:right, :left, :top]
         row(8).font_style = :bold
         row(9).column(0).borders = [:left]
         row(9).column(1).borders = [:right]
         row(9).column(2).borders = [ ]
         row(9).column(3).borders = [:right, :left]
         row(10).column(0).borders = [:left, :top, :bottom]
         row(10).column(1).borders = [:right, :top, :bottom]
         row(0).font_style = :bold
         self.row_colors = ["FEFEFE", "FFFFFF"]

       end 
       move_down 30  
end

def bahagian4_4
  
  text "BAHAGIAN IV - PENGETAHUAN DAN KEMAHIRAN ( Wajaran 25% )", :align => :left, :size => 12, :style => :bold  
  move_down 20     
  text "Pegawai Penilai dikehendaki memberikan penilaian berasaskan kepada penjelasan setiap kriteria yang dinyatakan di bawah dengan menggunakan skala 1 hingga 10:", :align => :left, :size => 12
  move_down 10
  
  data1 = [["", "KRITERIA ", "PPP", "PPK"],
           ["1.", "  ILMU PENGETAHUAN DAN KEMAHIRAN DALAM BIDANG KERJA", "", ""],
           ["","Mempunyai ilmu pengetahuan dan kemahiran/kepakaran dalam menghasilkan kerja meliputi kebolehan mengenalpasti, menganalisis serta menyelesaikan masalah.", "#{@staff_appraisal.e1g2q1}" , "#{@staff_appraisal.e2g2q1 if @staff_appraisal.viewable(@curr_user) == "display" }" ],
             ["2. ","  PELAKSANAAN DASAR, PERATURAN DAN ARAHAN PENTADBIRAN", "",""],
             ["","Kebolehan menghayati dan melaksanakan dasar, peraturan dan arahan pentadbiran berkaitan dengan bidang tugasnya.", "#{@staff_appraisal.e1g2q2}","#{@staff_appraisal.e2g2q2 if @staff_appraisal.viewable(@curr_user) == "display" }"]]
        
             
       table(data1 , :column_widths => [30, 291,100,100], :cell_style => { :size => 10}) do
         row(0).column(1).align = :center
         column(2).align = :center  
         column(3).align = :center 
         row(0).column(0).borders = [:left, :top]
         row(0).column(1).borders = [:right, :top]
         row(1).column(0).borders = [:left, :top]
         row(1).column(1).borders = [:right, :top]
         row(1).column(2).borders = [ :top ]
         row(1).font_style = :bold
         row(1).column(3).borders = [:right, :left, :top]
         row(2).column(0).borders = [:left]
         row(2).column(1).borders = [:right]
         row(2).column(2).borders = [ ]
         row(2).column(3).borders = [:right, :left]
         row(3).column(0).borders = [:left, :top]
         row(3).column(1).borders = [:right, :top]
         row(3).column(2).borders = [ :top ]
         row(3).column(3).borders = [:right, :left, :top]
         row(3).font_style = :bold
         row(4).column(0).borders = [:left, :bottom]
         row(4).column(1).borders = [:right,:bottom]
         row(4).column(2).borders = [:right,:bottom]
         row(4).column(3).borders = [:right,:bottom]
         row(0).font_style = :bold
         self.row_colors = ["FEFEFE", "FFFFFF"]

       end 
       start_new_page
       color
       
       data2 = [["", "KRITERIA (Dinilai berasaskan SKT)", "PPP", "PPK"],
                 ["3. ","  KUANTITI HASIL KERJA","",""],
                 ["","Kuantiti hasil kerja seperti jumlah bilangan, kadar, kekerapan dan sebagainya berbanding dengan sasaran kuantiti kerja yang ditetapkan.","#{@staff_appraisal.e1g2q3}","#{@staff_appraisal.e2g2q3 if @staff_appraisal.viewable(@curr_user) == "display" }"],
                 ["", "Jumlah markah mengikut wajaran","#{@staff_appraisal.e1g2_total} / 30 x 25 = #{@view.number_with_precision(@staff_appraisal.e1g2_percent, precision:2, locale: "en")}",
                   "#{@staff_appraisal.e2g2_total if @staff_appraisal.viewable(@curr_user) == "display" }/ 30 x 25 = #{@view.number_with_precision(@staff_appraisal.e2g2_percent, precision: 2, locale: "en") if @staff_appraisal.viewable(@curr_user) == "display" }"]]
                   
                   table(data2 , :column_widths => [30, 291,100,100], :cell_style => { :size => 10}) do
                     row(0).column(1).align = :center
                     column(2).align = :center  
                     column(3).align = :center 
                     row(0).column(0).borders = [:left, :top]
                     row(0).column(1).borders = [:right, :top]
                     row(1).column(0).borders = [:left, :top]
                     row(1).column(1).borders = [:right, :top]
                     row(1).column(2).borders = [ :top ]
                     row(1).font_style = :bold
                     row(1).column(3).borders = [:right, :left, :top]
                     row(2).column(0).borders = [:left]
                     row(2).column(1).borders = [:right]
                     row(2).column(2).borders = [ ]
                     row(2).column(3).borders = [:right, :left]
                     row(3).column(0).borders = [:left, :top, :bottom]
                     row(3).column(1).borders = [:right, :top, :bottom]
                     row(0).font_style = :bold
                     self.row_colors = ["FEFEFE", "FFFFFF"]

                   end 
                   move_down 30 
end

def bahagian4_3
  
  text "BAHAGIAN IV - PENGETAHUAN DAN KEMAHIRAN ( Wajaran 25% )", :align => :left, :size => 12, :style => :bold  
  move_down 20     
  text "Pegawai Penilai dikehendaki memberikan penilaian berasaskan kepada penjelasan setiap kriteria yang dinyatakan di bawah dengan menggunakan skala 1 hingga 10:", :align => :left, :size => 12
  move_down 10
  
  data1 = [["", "KRITERIA ", "PPP", "PPK"],
           ["1.", "  ILMU PENGETAHUAN DAN KEMAHIRAN DALAM BIDANG KERJA", "", ""],
           ["","Mempunyai ilmu pengetahuan dan kemahiran/kepakaran dalam menghasilkan kerja meliputi kebolehan mengenalpasti, menganalisis serta menyelesaikan masalah.", "#{@staff_appraisal.e1g2q1}" , "#{@staff_appraisal.e2g2q1 if @staff_appraisal.viewable(@curr_user) == "display" }" ],
             ["2. ","  PELAKSANAAN DASAR, PERATURAN DAN ARAHAN PENTADBIRAN", "",""],
             ["","Kebolehan menghayati dan melaksanakan dasar, peraturan dan arahan pentadbiran berkaitan dengan bidang tugasnya.", "#{@staff_appraisal.e1g2q2}","#{@staff_appraisal.e2g2q2 if @staff_appraisal.viewable(@curr_user) == "display" }"]]
             
       table(data1 , :column_widths => [30, 291,100,100], :cell_style => { :size => 10}) do
         row(0).column(1).align = :center
         column(2).align = :center  
         column(3).align = :center 
         row(0).column(0).borders = [:left, :top]
         row(0).column(1).borders = [:right, :top]
         row(1).column(0).borders = [:left, :top]
         row(1).column(1).borders = [:right, :top]
         row(1).column(2).borders = [ :top ]
         row(1).font_style = :bold
         row(1).column(3).borders = [:right, :left, :top]
         row(2).column(0).borders = [:left]
         row(2).column(1).borders = [:right]
         row(2).column(2).borders = [ ]
         row(2).column(3).borders = [:right, :left]
         row(3).column(0).borders = [:left, :top]
         row(3).column(1).borders = [:right, :top]
         row(3).column(2).borders = [ :top ]
         row(3).column(3).borders = [:right, :left, :top]
         row(3).font_style = :bold
         row(4).column(0).borders = [:left, :bottom]
         row(4).column(1).borders = [:right,:bottom]
         row(4).column(2).borders = [:right,:bottom]
         row(4).column(3).borders = [:right,:bottom]
         row(0).font_style = :bold
         self.row_colors = ["FEFEFE", "FFFFFF"]

       end 
       start_new_page
       color
       
       data2 = [["", "KRITERIA (Dinilai berasaskan SKT)", "PPP", "PPK"],
                 ["3. "," KEBERKESANAN KOMUNIKASI","",""],
                 ["","Kebolehan menyampaikan maksud, pendapat, kefahaman atau arahan secara lisan dan tulisan berkaitan dengan bidang tugas merangkumi penguasaan bahasa melalui tulisan dan lisan dengan menggunakan tatabahasa dan persembahan yang baik","#{@staff_appraisal.e1g2q3}","#{@staff_appraisal.e2g2q3 if @staff_appraisal.viewable(@curr_user) == "display" }"],
                 ["", "Jumlah markah mengikut wajaran","#{@staff_appraisal.e1g2_total} / 30 x 25 = #{@view.number_with_precision(@staff_appraisal.e1g2_percent, precision: 2, locale: "en")}",
                   "#{@staff_appraisal.e2g2_total if @staff_appraisal.viewable(@curr_user) == "display" } / 30 x 25 = #{@view.number_with_precision(@staff_appraisal.e2g2_percent, precision: 2, locale: "en") if @staff_appraisal.viewable(@curr_user) == "display" }"]]
                   
                   table(data2 , :column_widths => [30, 291,100,100], :cell_style => { :size => 10}) do
                     row(0).column(1).align = :center
                     column(2).align = :center  
                     column(3).align = :center 
                     row(0).column(0).borders = [:left, :top]
                     row(0).column(1).borders = [:right, :top]
                     row(1).column(0).borders = [:left, :top]
                     row(1).column(1).borders = [:right, :top]
                     row(1).column(2).borders = [ :top ]
                     row(1).font_style = :bold
                     row(1).column(3).borders = [:right, :left, :top]
                     row(2).column(0).borders = [:left]
                     row(2).column(1).borders = [:right]
                     row(2).column(2).borders = [ ]
                     row(2).column(3).borders = [:right, :left]
                     row(3).column(0).borders = [:left, :top, :bottom]
                     row(3).column(1).borders = [:right, :top, :bottom]
                     row(0).font_style = :bold
                     self.row_colors = ["FEFEFE", "FFFFFF"]

                   end 
                   move_down 40  
end

def bahagian4_5
  text "BAHAGIAN IV - KUALITI PERIBADI ( Wajaran 25% )", :align => :left, :size => 12, :style => :bold 
  move_down 10 
  text "Pegawai Penilai dikehendaki memberikan penilaian berasaskan kepada penjelasan setiap kriteria yang dinyatakan di bawah dengan menggunakan skala 1 hingga 10:", :align => :left, :size => 12
  move_down 5
  
  data1 = [["", "KRITERIA ", "PPP", "PPK"],
           ["1.", "  KEBOLEHAN MENGELOLA", "", ""],
           ["","Keupayaan dan kebolehan menggembleng segala sumber dalam kawalannya seperti kewangan, tenaga manusia,peralatan dan maklumat bagi merancang mengatur, membahagi dan mengendalikan sesuatu tugas untuk mencapai objektif organisasi.", "#{@staff_appraisal.e1g2q1}" , "#{@staff_appraisal.e2g2q1 if @staff_appraisal.viewable(@curr_user) == "display" }" ],
             ["2. ","  DISIPLIN", "",""],
             ["","Mempunyai daya kawalan diri dari segi mental dan fizikal termasuk mematuhi peraturan, menepati masa, menunaikan janji dan bersifat sabar.", "#{@staff_appraisal.e1g2q2}","#{@staff_appraisal.e2g2q2 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["3. ","  PROAKTIF DAN INOVATIF","",""],
             ["","Kebolehan menjangka kemungkinan, mencipta dan mengeluarkan idea baru serta membuat pembaharuan bagi mempertingkatkan kualiti dan produktiviti organisasi.","#{@staff_appraisal.e1g2q3}","#{@staff_appraisal.e2g2q3 if @staff_appraisal.viewable(@curr_user) == "display" }"]]
               
               table(data1 , :column_widths => [30, 291,100,100], :cell_style => { :size => 10}) do
                 row(0).column(1).align = :center
                 column(2).align = :center  
                 column(3).align = :center 
                 row(0).column(0).borders = [:left, :top]
                 row(0).column(1).borders = [:right, :top]
                 row(1).column(0).borders = [:left, :top]
                 row(1).column(1).borders = [:right, :top]
                 row(1).column(2).borders = [ :top ]
                 row(1).font_style = :bold
                 row(1).column(3).borders = [:right, :left, :top]
                 row(2).column(0).borders = [:left]
                 row(2).column(1).borders = [:right]
                 row(2).column(2).borders = [ ]
                 row(2).column(3).borders = [:right, :left]
                 row(3).column(0).borders = [:left, :top]
                 row(3).column(1).borders = [:right, :top]
                 row(3).column(2).borders = [ :top ]
                 row(3).column(3).borders = [:right, :left, :top]
                 row(3).font_style = :bold
                 row(4).column(0).borders = [:left]
                 row(4).column(1).borders = [:right]
                 row(4).column(2).borders = [ ]
                 row(4).column(3).borders = [:right, :left]
                 row(5).column(0).borders = [:left, :top]
                 row(5).column(1).borders = [:right, :top]
                 row(5).column(2).borders = [ :top ]
                 row(5).column(3).borders = [:right, :left, :top]
                 row(5).font_style = :bold
                 row(6).column(0).borders = [:left, :bottom]
                 row(6).column(1).borders = [:right,:bottom]
                 row(6).column(2).borders = [:right,:bottom]
                 row(6).column(3).borders = [:right,:bottom]
                 row(0).font_style = :bold
    
                 self.row_colors = ["FEFEFE", "FFFFFF"]

               end 
               start_new_page
               color
       
               data2 = [["", "KRITERIA (Dinilai berasaskan SKT)", "PPP", "PPK"],
               ["4. ","  JALINAN HUBUNGAN DAN KERJASAMA","",""],
               ["","Kebolehan pegawai dalam mewujudkan suasana kerjasama yang harmoni dan mesra serta boleh menyesuaikan diri dalam semua keadaan.","#{@staff_appraisal.e1g2q4}","#{@staff_appraisal.e2g2q4 if @staff_appraisal.viewable(@curr_user) == "display" }"],
               ["", "Jumlah markah mengikut wajaran","#{@staff_appraisal.e1g2_total} / 30 x 25 = #{@view.number_with_precision(@staff_appraisal.e1g2_percent, precision: 2, locale: "en")} ",
                 "#{@staff_appraisal.e2g2_total if @staff_appraisal.viewable(@curr_user) == "display" } / 30 x 25 = #{@view.number_with_precision(@staff_appraisal.e2g2_percent, precision: 2, locale: "en") if @staff_appraisal.viewable(@curr_user) == "display" }"]]
                   
                           table(data2 , :column_widths => [30, 291,100,100], :cell_style => { :size => 10}) do
                             row(0).column(1).align = :center
                             column(2).align = :center  
                             column(3).align = :center 
                             row(0).column(0).borders = [:left, :top]
                             row(0).column(1).borders = [:right, :top]
                             row(1).column(0).borders = [:left, :top]
                             row(1).column(1).borders = [:right, :top]
                             row(1).column(2).borders = [ :top ]
                             row(1).font_style = :bold
                             row(1).column(3).borders = [:right, :left, :top]
                             row(2).column(0).borders = [:left]
                             row(2).column(1).borders = [:right]
                             row(2).column(2).borders = [ ]
                             row(2).column(3).borders = [:right, :left]
                             row(3).column(0).borders = [:left, :top, :bottom]
                             row(3).column(1).borders = [:right, :top, :bottom]
                             row(0).font_style = :bold
                             self.row_colors = ["FEFEFE", "FFFFFF"]

                           end 
                           move_down 40    
end

def bahagian5_4
  
  text "BAHAGIAN V - KUALITI PERIBADI ( Wajaran 20% )", :align => :left, :size => 12, :style => :bold    
  move_down 20   
  text "Pegawai Penilai dikehendaki memberikan penilaian berasaskan kepada penjelasan setiap kriteria yang dinyatakan di bawah dengan menggunakan skala 1 hingga 10:", :align => :left, :size => 12
  move_down 20  
  
  data1 = [["", "KRITERIA (Dinilai berasaskan SKT)", "PPP", "PPK"],
           ["1.", "  KEBOLEHAN MENGELOLA", "", ""],
           ["","Keupayaan dan kebolehan menggembleng segala sumber dalam kawalannya seperti kewangan, tenaga manusia, peralatan dan maklumat bagi merancang mengatur, membahagi dan mengendalikan sesuatu tugas untuk mencapai objektif organisasi.", "#{@staff_appraisal.e1g3q1}" , "#{@staff_appraisal.e2g3q1 if @staff_appraisal.viewable(@curr_user) == "display" }" ],
             ["2. ","   DISIPLIN", "",""],
             ["","Mempunyai daya kawalan diri dari segi mental dan fizikal termasuk mematuhi peraturan, menepati masa, menunaikan janji dan bersifat sabar.", "#{@staff_appraisal.e1g3q2}","#{@staff_appraisal.e2g3q2 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["3. ","   PROAKTIF DAN INOVATIF","",""],
             ["","Kebolehan menjangka kemungkinan, mencipta dan mengeluarkan idea baru serta membuat pembaharuan bagi mempertingkatkan kualiti dan produktiviti organisasi.","#{@staff_appraisal.e1g3q3}","#{@staff_appraisal.e2g3q3 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["4. ","   JALINAN HUBUNGAN DAN KERJASAMA","",""],
             [""," Kebolehan pegawai dalam mewujudkan suasana kerjasama yang harmoni dan mesra serta boleh menyesuaikan diri dalam semua keadaan.","#{@staff_appraisal.e1g3q4}","#{@staff_appraisal.e2g3q4 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["", "Jumlah markah mengikut wajaran","#{@staff_appraisal.e1g3_total} / 50 x 20 = #{@view.number_with_precision(@staff_appraisal.e1g3_percent, precision: 2, locale: "en")}","#{@staff_appraisal.e2g3_total if @staff_appraisal.viewable(@curr_user) == "display" } / 50 x 20 = #{@view.number_with_precision(@staff_appraisal.e2g3_percent, precision: 2, locale: "en") if @staff_appraisal.viewable(@curr_user) == "display" }"]]
             
       table(data1 , :column_widths => [30, 291,100,100], :cell_style => { :size => 10}) do
         row(0).font_style = :bold
         row(1).font_style = :bold
         row(0).column(1).align = :center
         column(2).align = :center  
         column(3).align = :center 
         row(0).column(0).borders = [:left, :top]
         row(0).column(1).borders = [:right, :top]
         row(1).column(0).borders = [:left, :top]
         row(1).column(1).borders = [:right, :top]
         row(1).column(2).borders = [ :top ]
         row(1).column(3).borders = [:right, :left, :top]
         row(2).column(0).borders = [:left]
         row(2).column(1).borders = [:right]
         row(2).column(2).borders = [ ]
         row(2).column(3).borders = [:right, :left]
         row(3).column(0).borders = [:left, :top]
         row(3).column(1).borders = [:right, :top]
         row(3).column(2).borders = [ :top ]
         row(3).column(3).borders = [:right, :left, :top]
         row(3).font_style = :bold
         row(4).column(0).borders = [:left]
         row(4).column(1).borders = [:right]
         row(4).column(2).borders = [ ]
         row(4).column(3).borders = [:right, :left]
         row(5).column(0).borders = [:left, :top]
         row(5).column(1).borders = [:right, :top]
         row(5).column(2).borders = [ :top ]
         row(5).column(3).borders = [:right, :left, :top]
         row(5).font_style = :bold
         row(6).column(0).borders = [:left]
         row(6).column(1).borders = [:right]
         row(6).column(2).borders = [ ]
         row(6).column(3).borders = [:right, :left]
         row(7).column(0).borders = [:left, :top]
         row(7).column(1).borders = [:right, :top]
         row(7).column(2).borders = [ :top ]
         row(7).column(3).borders = [:right, :left, :top]
         row(7).font_style = :bold
         row(8).column(0).borders = [:left]
         row(8).column(1).borders = [:right]
         row(8).column(2).borders = [ ]
         row(8).column(3).borders = [:right, :left]
         row(9).column(0).borders = [:left, :top, :bottom]
         row(9).column(1).borders = [:right, :top, :bottom]
         self.row_colors = ["FEFEFE", "FFFFFF"]

       end 
       move_down 40   
end

def bahagian5_5
  
  text "BAHAGIAN V - KUALITI PERIBADI ( Wajaran 20% )", :align => :left, :size => 12, :style => :bold    
  move_down 20   
  text "Pegawai Penilai dikehendaki memberikan penilaian berasaskan kepada penjelasan setiap kriteria yang dinyatakan di bawah dengan menggunakan skala 1 hingga 10:", :align => :left, :size => 12
  move_down 20  
  
  data1 = [["", "KRITERIA (Dinilai berasaskan SKT)", "PPP", "PPK"],
           ["1.", "  ILMU PENGETAHUAN DAN KEMAHIRAN DALAM BIDANG KERJA", "", ""],
           ["","Mempunyai ilmu pengetahuan dan kemahiran/kepakaran dalam menghasilkan kerja meliputi kebolehan mengenalpasti, menganalisis serta menyelesaikan masalah.", "#{@staff_appraisal.e1g3q1}" , "#{@staff_appraisal.e2g3q1 if @staff_appraisal.viewable(@curr_user) == "display" }" ],
             ["2. "," PELAKSANAAN PERATURAN DAN ARAHAN PENTADBIRAN", "",""],
             ["","Kebolehan menghayati dan melaksanakan dasar, peraturan dan arahan pentadbiran berkaitan dengan bidang tugasnya.", "#{@staff_appraisal.e1g3q2}","#{@staff_appraisal.e2g3q2 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["3. ","KEBERKESANAN KOMUNIKASI","",""],
             ["","Kebolehan menyampaikan maksud, pendapat, kefahaman atau arahan","#{@staff_appraisal.e1g3q3}","#{@staff_appraisal.e2g3q3 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["", "Jumlah markah mengikut wajaran","#{@staff_appraisal.e1g3_total} / 50 x 20 = #{@view.number_with_precision(@staff_appraisal.e1g3_percent, precision: 2, locale: "en")}","#{@staff_appraisal.e2g3_total if @staff_appraisal.viewable(@curr_user) == "display" } / 50 x 20 = #{@view.number_with_precision(@staff_appraisal.e2g3_percent, precision: 2, locale: "en") if @staff_appraisal.viewable(@curr_user) == "display" }"]]
             
       table(data1 , :column_widths => [30, 291,100,100], :cell_style => { :size => 10}) do
         row(0).font_style = :bold
         row(1).font_style = :bold
         row(0).column(1).align = :center
         column(2).align = :center  
         column(3).align = :center 
         row(0).column(0).borders = [:left, :top]
         row(0).column(1).borders = [:right, :top]
         row(1).column(0).borders = [:left, :top]
         row(1).column(1).borders = [:right, :top]
         row(1).column(2).borders = [ :top ]
         row(1).column(3).borders = [:right, :left, :top]
         row(2).column(0).borders = [:left]
         row(2).column(1).borders = [:right]
         row(2).column(2).borders = [ ]
         row(2).column(3).borders = [:right, :left]
         row(3).column(0).borders = [:left, :top]
         row(3).column(1).borders = [:right, :top]
         row(3).column(2).borders = [ :top ]
         row(3).column(3).borders = [:right, :left, :top]
         row(3).font_style = :bold
         row(4).column(0).borders = [:left]
         row(4).column(1).borders = [:right]
         row(4).column(2).borders = [ ]
         row(4).column(3).borders = [:right, :left]
         row(5).column(0).borders = [:left, :top]
         row(5).column(1).borders = [:right, :top]
         row(5).column(2).borders = [ :top ]
         row(5).column(3).borders = [:right, :left, :top]
         row(5).font_style = :bold
         row(6).column(0).borders = [:left]
         row(6).column(1).borders = [:right]
         row(6).column(2).borders = [ ]
         row(6).column(3).borders = [:right, :left]
         row(7).column(0).borders = [:left, :top, :bottom]
         row(7).column(1).borders = [:right, :top, :bottom]
         self.row_colors = ["FEFEFE", "FFFFFF"]

       end 
       move_down 40   
end

def bahagian5_3
  
  text "BAHAGIAN V - KUALITI PERIBADI ( Wajaran 20% )", :align => :left, :size => 12, :style => :bold    
  move_down 20   
  text "Pegawai Penilai dikehendaki memberikan penilaian berasaskan kepada penjelasan setiap kriteria yang dinyatakan di bawah dengan menggunakan skala 1 hingga 10:", :align => :left, :size => 12
  move_down 20  
  
  data1 = [["", "KRITERIA (Dinilai berasaskan SKT)", "PPP", "PPK"],
           ["1.", "  CIRI-CIRI PEMIMPIN", "", ""],
           [" ", " Mempunyai wawasan, komitmen, kebolehan membuat keputusan, menggerak dan memberi dorongan kepada pegawai ke arah pencapaian objektif organisasi.", "#{@staff_appraisal.e1g3q1 }", "#{@staff_appraisal.e2g3q1 if @staff_appraisal.viewable(@curr_user) == "display" }"],
           ["1.", "  KEBOLEHAN MENGELOLA", "", ""],
           ["","Keupayaan dan kebolehan menggembleng segala sumber dalam kawalannya seperti kewangan, tenaga manusia, peralatan dan maklumat bagi merancang mengatur, membahagi dan mengendalikan sesuatu tugas untuk mencapai objektif organisasi.", "#{@staff_appraisal.e1g3q2 }" , "#{@staff_appraisal.e2g3q2 if @staff_appraisal.viewable(@curr_user) == "display" }" ],
             ["2. ","   DISIPLIN", "",""],
             ["","Mempunyai daya kawalan diri dari segi mental dan fizikal termasuk mematuhi peraturan, menepati masa, menunaikan janji dan bersifat sabar.", "#{@staff_appraisal.e1g3q3 }","#{@staff_appraisal.e2g3q3 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["3. ","   PROAKTIF DAN INOVATIF","",""],
             ["","Kebolehan menjangka kemungkinan, mencipta dan mengeluarkan idea baru serta membuat pembaharuan bagi mempertingkatkan kualiti dan produktiviti organisasi.","#{@staff_appraisal.e1g3q4 }","#{@staff_appraisal.e2g3q4 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["4. ","   JALINAN HUBUNGAN DAN KERJASAMA","",""],
             [""," Kebolehan pegawai dalam mewujudkan suasana kerjasama yang harmoni dan mesra serta boleh menyesuaikan diri dalam semua keadaan.","#{@staff_appraisal.e1g3q5 }","#{@staff_appraisal.e2g3q5 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["", "Jumlah markah mengikut wajaran","#{@staff_appraisal.e1g3_total } / 50 x 20 = #{@view.number_with_precision(@staff_appraisal.e1g3_percent, precision: 2, locale: "en")}","#{@staff_appraisal.e2g3_total if @staff_appraisal.viewable(@curr_user) == "display" } / 50 x 20 = #{@view.number_with_precision(@staff_appraisal.e2g3_percent, precision: 2, locale: "en") if @staff_appraisal.viewable(@curr_user) == "display" }"]]
             
       table(data1 , :column_widths => [30, 291,100,100], :cell_style => { :size => 10}) do
         row(0).font_style = :bold
         row(1).font_style = :bold
         row(0).column(1).align = :center
         column(2).align = :center  
         column(3).align = :center 
         row(0).column(0).borders = [:left, :top]
         row(0).column(1).borders = [:right, :top]
         row(1).column(0).borders = [:left, :top]
         row(1).column(1).borders = [:right, :top]
         row(1).column(2).borders = [ :top ]
         row(1).column(3).borders = [:right, :left, :top]
         row(2).column(0).borders = [:left]
         row(2).column(1).borders = [:right]
         row(2).column(2).borders = [ ]
         row(2).column(3).borders = [:right, :left]
         row(3).column(0).borders = [:left, :top]
         row(3).column(1).borders = [:right, :top]
         row(3).column(2).borders = [ :top ]
         row(3).column(3).borders = [:right, :left, :top]
         row(3).font_style = :bold
         row(4).column(0).borders = [:left]
         row(4).column(1).borders = [:right]
         row(4).column(2).borders = [ ]
         row(4).column(3).borders = [:right, :left]
         row(5).column(0).borders = [:left, :top]
         row(5).column(1).borders = [:right, :top]
         row(5).column(2).borders = [ :top ]
         row(5).column(3).borders = [:right, :left, :top]
         row(5).font_style = :bold
         row(6).column(0).borders = [:left]
         row(6).column(1).borders = [:right]
         row(6).column(2).borders = [ ]
         row(6).column(3).borders = [:right, :left]
         row(7).column(0).borders = [:left, :top]
         row(7).column(1).borders = [:right, :top]
         row(7).column(2).borders = [ :top ]
         row(7).column(3).borders = [:right, :left, :top]
         row(7).font_style = :bold
         row(8).column(0).borders = [:left]
         row(8).column(1).borders = [:right]
         row(8).column(2).borders = [ ]
         row(8).column(3).borders = [:right, :left]
         row(9).column(0).borders = [:left, :top]
         row(9).column(1).borders = [:right, :top]
         row(9).column(2).borders = [ :top ]
         row(9).column(3).borders = [:right, :left, :top]
         row(9).font_style = :bold
         row(10).column(0).borders = [:left]
         row(10).column(1).borders = [:right]
         row(10).column(2).borders = [ ]
         row(10).column(3).borders = [:right, :left]
         row(11).column(0).borders = [:left, :top, :bottom]
         row(11).column(1).borders = [:right, :top, :bottom]
         self.row_colors = ["FEFEFE", "FFFFFF"]

       end 
       move_down 40   
end

def bahagian6
  start_new_page
  color
  text "BAHAGIAN VI - KEGIATAN DAN SUMBANGAN DI LUAR TUGAS RASMI ( Wajaran 5% )", :align => :left, :size => 12, :style => :bold  
  text "(Sukan/Pertubuhan/Sumbangan Kreatif)", :align => :left, :size => 12
  move_down 20   
  text "Berasaskan maklumat di Bahagian II perenggan 1, Pegawai Penilai dikehendaki memberi penilaian dengan menggunakan skala 1 hingga 10. TIada sebarang markah boleh diberikan (kosong) jika PYD tidak mencatat kegiatan atau sumbangannya.", :align => :left, :size => 12
  move_down 20   
  
  data1 = [ ["", " ", "PPP","PPK"],
    [ "", "Peringkat Komuniti / Jabatan / Daerah / Negeri / Negara / Antarabangsa", "#{@staff_appraisal.e1g4 }", "#{@staff_appraisal.e2g3q1 if @staff_appraisal.viewable(@curr_user) == "display" }"],
             ["","Jumlah markah mengikut wajaran","#{@staff_appraisal.e1g4} / 10 x 5 = #{(@staff_appraisal.e1g4_percent)}",
               "#{@staff_appraisal.e2g4 if @staff_appraisal.viewable(@curr_user) == "display" } / 10 x 5 = #{(@staff_appraisal.e2g4_percent) if @staff_appraisal.viewable(@curr_user) == "display" }"]]
             
       table(data1 , :column_widths => [20,291,100,100], :cell_style => { :size => 10}) do
         row(0).column(0).borders = [:left, :top]
         row(0).column(1).borders = [:right, :top]
         row(0).align = :center  
         row(1).align = :center  
         row(1).column(0).borders = [:left]
         row(1).column(1).borders = [:right]
         row(2).column(0).borders = [:left, :top, :bottom]
         row(2).column(1).borders = [:right, :top, :bottom]
         row(2).column(0).font_style = :bold
         self.row_colors = ["FEFEFE", "FFFFFF"]

       end 
       move_down 40  
end

def bahagian7

  text "BAHAGIAN VII - JUMLAH MARKAH KESELURUHAN", :align => :left, :size => 12, :style => :bold  
  move_down 20
  text "Pegawai Penilai dikehendaki mencatatkan jumlah markah keseluruhan yang diperolehi oleh PYD dalam bentuk peratus (%) berdasarkan jumlah markah bagi setiap Bahagian yang diberi markah.", :align => :left, :size => 12

  move_down 20
  
  data1 = [[ "", "PPP(%)", "PPK(%)", "MARKAH PURATA (%) 
    untuk diisi oleh Urus Setia PPSM)"],
             ["MARKAH KESELURUHAN",
               "#{@view.number_with_precision(@staff_appraisal.e1_total, precision: 2, locale: "en")}","#{@view.number_with_precision(@staff_appraisal.e2_total, precision: 2, locale: "en") if @staff_appraisal.viewable(@curr_user) == "display" }", ""]] 
             
       table(data1 , :column_widths => [150,80,80, 200], :cell_style => { :size => 10}) do
         row(0).column(0).font_style = :bold
         self.row_colors = ["FEFEFE", "FFFFFF"]

       end 
       move_down 40  
end

def bahagian8
  
  text "BAHAGIAN VIII - ULASAN KESELURUHAN DAN PENGESAHAN OLEH PEGAWAI PENILAI PERTAMA", :align => :left, :size => 12, :style => :bold  
  move_down 20
  text "1.  Tempoh PYD bertugas di bawah pengawasan: Tahun #{@staff_appraisal.e1_years} Bulan #{@staff_appraisal.e1_months}", :align => :left, :size => 12
  move_down 10
  text "2.  Penilai Pertama hendaklah memberi ulasan keseluruhan prestasi PYD.", :align => :left, :size => 12
  move_down 10
  text "(i)  Prestasi keseluruhan.", :align => :left, :size => 12
  move_down 10
  text "#{@staff_appraisal.e1_performance}..............", :align => :left, :size => 12, :indent_paragraphs => 30
  move_down 10
  text "(ii)  Kemajuan kerjaya.", :align => :left, :size => 12
  move_down 10
  text "#{@staff_appraisal.e1_progress}..............", :align => :left, :size => 12, :indent_paragraphs => 30
  move_down 10
  start_new_page
  color
  text "3.  Adalah disahkan bahawa prestasi pegawai ini telah dimaklumkan kepada PYD.", :align => :left, :size => 12
  move_down 20
  data1 = [[ "Nama PPP :", "#{@staff_appraisal.eval1_officer.name}"],
            ["Jawatan :", "#{@staff_appraisal.eval1_officer.positions.first.name}"],
             ["Kementerian /Jabatan : ","Kolej Sains Kesihatan Bersekutu Johor Bahru"],
           ["No. K.P : ","#{@staff_appraisal.eval1_officer.formatted_mykad}"]]
             
       table(data1 , :column_widths => [150,371], :cell_style => { :size => 11}) do
         row(0).column(0).borders = [:left, :top]
         row(0).column(1).borders = [:right, :top, :bottom]
         row(1).column(0).borders = [:left]
         row(1).column(1).borders = [:right, :bottom]
         row(2).column(0).borders = [:left]
         row(2).column(1).borders = [:right, :bottom]
         row(3).column(0).borders = [:left, :bottom]
         row(3).column(1).borders = [:right, :bottom]
         self.row_colors = ["FEFEFE", "FFFFFF"]
       end 
       
     move_down 10  
     
       data1 = [["#{@staff_appraisal.eval1_officer.name}","#{@staff_appraisal.submit_e2_on.try(:strftime, "%d-%m-%Y")}"],
             [ "Tandatangan PPP", "Tarikh"]] 
           
             table(data1 , :column_widths => [261, 260], :cell_style => { :size => 11}) do
               row(0).font_style = :bold
               row(1).borders = [ ]
               row(1).align = :center
               row(0).background_color = 'FFFFFF'
             end
      move_down 40    
end

def bahagian9

  text "BAHAGIAN IX - ULASAN KESELURUHAN OLEH PEGAWAI PENILAI KEDUA", :align => :left, :size => 12, :style => :bold  
  move_down 20
  text "1.  Tempoh PYD bertugas di bawah pengawasan: Tahun #{@staff_appraisal.e2_years} Bulan #{@staff_appraisal.e2_months}", :align => :left, :size => 12
  move_down 10
  text "2.  Penilai Pertama hendaklah memberi ulasan keseluruhan prestasi PYD.", :align => :left, :size => 12
  text "#{@staff_appraisal.e2_performance}..............", :align => :left, :size => 12, :indent_paragraphs => 30
  move_down 20
  data1 = [[ "Nama PPK :", "#{@staff_appraisal.eval2_officer.try(:name)}"],
            ["Jawatan :", "#{@staff_appraisal.eval2_officer.try(:positions).try(:first).try(:name)}"],
             ["Kementerian /Jabatan : ","Kolej Sains Kesihatan Bersekutu Johor Bahru"],
           ["No. K.P : ","#{@staff_appraisal.eval2_officer.try(:formatted_mykad)}"]]
             
       table(data1 , :column_widths => [150,371], :cell_style => { :size => 11}) do
         row(0).column(0).borders = [:left, :top]
         row(0).column(1).borders = [:right, :top, :bottom]
         row(1).column(0).borders = [:left]
         row(1).column(1).borders = [:right, :bottom]
         row(2).column(0).borders = [:left]
         row(2).column(1).borders = [:right, :bottom]
         row(3).column(0).borders = [:left, :bottom]
         row(3).column(1).borders = [:right, :bottom] 
         self.row_colors = ["FEFEFE", "FFFFFF"]
       end 
      move_down 10
       
       data1 = [["#{@staff_appraisal.eval2_officer.try(:name)}","#{@staff_appraisal.is_completed_on.try(:strftime, "%d-%m-%Y")}"],
             [ "Tandatangan PPP", "Tarikh"]] 
           
             table(data1 , :column_widths => [261,260], :cell_style => { :size => 11}) do
               row(0).font_style = :bold
               row(1).borders = [ ]
               row(1).align = :center
               row(0).background_color = 'FFFFFF'
             end
      move_down 80 
end

def lampiranA
  start_new_page
  color
  text "LAMPIRAN 'A", :align => :right, :size => 12, :style => :bold 
  move_down 20
  text "SASARAN KERJA TAHUNAN", :align => :center, :size => 12, :style => :bold 
  move_down 10
  
  
  data = [["PERINGATAN"],
         ["Pegawai Yang Dinilai (PYD) dan Pegawai Penilaian Pertama (PPP) hendaklah memberi perhatian kepada perkara-perkara berikut sebelum dan semasa melengkapkan borang ini:" ]]
 
  table(data , :column_widths => [520], :cell_style => { :size => 10}) do
    row(0).align = :center
    row(0).column(0).borders = [:left, :right, :top]
    row(1).column(0).borders = [:left, :right]
   row(0).font_style = :bold
   self.row_colors = ["FEFEFE", "FFFFFF"]  

  end 
  
  data1 = [['	i.', "PYD dan PPD hendaklah berbincang bersama dalam membuat penetapan Sasaran Kerja Tahunan 
    (SKT) dan menurunkan tandatangan di ruangan yang ditetapkan di Bahagian I"],
    ["ii.","SKT yang ditetapkan hendaklah mengandungi sekurang-kurangnya satu petunjuk prestasi iaitu sama ada kuantiti, kualiti,
       masa atau kos bergantung kepada kesesuaian sesuatu aktiviti/projek:"],
    ["iii.", "SKT yang telah ditetapkan pada awal tahun hendaklah dikaji semula di pertengahan tahun, 
      SKT yang digugurkan atau ditambah hendaklah dicatatkan di ruangan Bahagian II"],
      ["	iv.", "PYD dan PPP hendaklah membuat laporan dan ulasan keseluruhan pencapaian SKT pada akhir 
        tahun serta menurunkan tandatangan di ruangan yang ditetapkan di Bahagian III; dan"],
      ["v.", "sila rujuk Panduan Penyediaan Sasaran Kerja Tahunan (SKT) untuk mendapat keterangan lanjut."]]
    
        table(data1 , :column_widths => [30,490], :cell_style => { :size => 10}) do
       column(0).align = :right
       row(0).column(0).borders = [:left]
       row(0).column(1).borders = [:right]
       row(1).column(0).borders = [:left]
       row(1).column(1).borders = [:right]
       row(2).column(0).borders = [:left]
       row(2).column(1).borders = [:right]
       row(3).column(0).borders = [:left]
       row(3).column(1).borders = [:right]
       row(4).column(0).borders = [:left, :bottom]
       row(4).column(1).borders = [:right, :bottom]
       self.row_colors = ["FEFEFE", "FFFFFF"]  
    end
    move_down 40 
end

  def lampiranA1
    text "BAHAGIAN I -  MAKLUMAT PEGAWAI", :align => :left, :size => 12, :style => :bold  
    text "(PYD dan PPP hendaklah berbincang bersama sebelum menetapkan SKT dan petunjuk prestasinya)", :align => :left, :size => 12  
    move_down 10
  end
  
  def table_lampiranA1
    item_with_skt=[]
    heading=[0,1]
    item_count2=1
    nil_rows=[]
    @staff_appraisal.staff_appraisal_skts.where('half =?', 1).order(priority: :asc).each_with_index do |staff_appraisal_skt, indx|
        if staff_appraisal_skt.indicator_desc_quality!='' && staff_appraisal_skt.target_quality!=''
          item_count2+=1
          item_with_skt << item_count2
       end
       if staff_appraisal_skt.indicator_desc_time!='' && staff_appraisal_skt.target_time!=''
         item_count2+=1
         item_with_skt << item_count2
       end
       if staff_appraisal_skt.indicator_desc_quantity!='' && staff_appraisal_skt.target_quantity!=''
         item_count2+=1
         item_with_skt << item_count2
      end
      if staff_appraisal_skt.indicator_desc_cost!='' && staff_appraisal_skt.target_cost!=''
        item_count2+=1
        item_with_skt << item_count2
      end
        item_count2+=1
        nil_rows << item_count2
        item_count2+=1
        heading << item_count2
        item_count2+=1
        heading << item_count2
    end 
    table(line_item_rows6 , :column_widths => [50, 105, 105, 105, 50, 106], :cell_style => { :size => 11, :inline_format => :true}) do
      #row(0..1).background_color = "F0EEEE"
      #row(2..item_count_per_skt[0]-1).background_color = "FFFFFF"
      heading.each do |rr|
        row(rr).background_color="F0EEEE"
      end
      nil_rows.each do |rr|
        row(rr).borders=[]
      end
      item_with_skt.each do |rr|
        row(rr).background_color= "FFFFFF"
      end 
    end
  end
  
  def line_item_rows6
    counter = counter || 0
    multi_arr=[]
    arr=[]
    @staff_appraisal.staff_appraisal_skts.where('half =?', 1).order(priority: :asc).each_with_index do |staff_appraisal_skt, indx|
         counter += 1
         arr << [ "#{staff_appraisal_skt.priority.blank? ? staff_appraisal_skt.priority : counter}", {content: "#{staff_appraisal_skt.description}", colspan: 5}]
         arr << [ {content: "Petunjuk Prestasi", colspan: 2}, "Sasaran", "Pencapaian", "%", "Ulasan"]
         arr << [ "Kualiti", "#{staff_appraisal_skt.indicator_desc_quality}", "#{staff_appraisal_skt.target_quality}", "#{staff_appraisal_skt.achievement_quality}", "#{@view.number_with_precision(staff_appraisal_skt.progress_quality, precision: 2)}", "#{staff_appraisal_skt.notes_quality}"] if staff_appraisal_skt.indicator_desc_quality!='' && staff_appraisal_skt.target_quality!=''
         arr << [ "Masa", "#{staff_appraisal_skt.indicator_desc_time}", "#{staff_appraisal_skt.target_time}", "#{staff_appraisal_skt.achievement_time}", "#{@view.number_with_precision(staff_appraisal_skt.progress_time, precision:2)}", "#{staff_appraisal_skt.notes_time}"] if staff_appraisal_skt.indicator_desc_time!='' && staff_appraisal_skt.target_time!=''
         arr << [ "Kuantiti", "#{staff_appraisal_skt.indicator_desc_quantity}", "#{staff_appraisal_skt.target_quantity}", "#{staff_appraisal_skt.achievement_quantity}", "#{@view.number_with_precision(staff_appraisal_skt.progress_quantity, precision: 2)}", "#{staff_appraisal_skt.notes_quantity}"] if staff_appraisal_skt.indicator_desc_quantity!='' && staff_appraisal_skt.target_quantity!=''
         arr << [ "Kos", "#{staff_appraisal_skt.indicator_desc_cost}", "#{staff_appraisal_skt.target_cost}", "#{staff_appraisal_skt.achievement_cost}", "#{@view.number_with_precision(staff_appraisal_skt.progress_cost, precison: 2)}", "#{staff_appraisal_skt.notes_cost}"] if staff_appraisal_skt.indicator_desc_cost!='' && staff_appraisal_skt.target_cost!=''
          arr << ["","","","","",""]
    end
    arr
  end
  
  def lampiranA1a
    move_down 10
    data1 = [["#{@staff_appraisal.appraised.name}","#{@staff_appraisal.eval1_officer.name}"],
        [ "Tandatangan PYD", "Tandatangan PPP"],
        ["Tarikh : #{@staff_appraisal.skt_submit_on.try(:strftime, "%d-%m-%Y")}", "Tarikh : #{@staff_appraisal.skt_endorsed_on.try(:strftime, "%d-%m-%Y")}"]] 
      
    table(data1 , :column_widths => [261,260], :cell_style => { :size => 11}) do
          row(1).borders = [ ]
          row(0..2).align = :center
          row(2).borders = [ ]
          row(0).font_style = :bold
          row(0).background_color = 'FFFFFF'
    end 
    move_down 40
  end

  def lampiranA2
    start_new_page
    color
    text "BAHAGIAN II -  Kajian Semula Sasaran Kerja Tahun Pertengahan Tahun", :align => :left, :size => 12, :style => :bold  
    move_down 20
    text "1.   Aktiviti/Projek Yang Ditambah", :align => :left, :size => 12, :style => :bold    
    text "(PYD hendaklah menyeneraikan aktiviti/projek yang ditambah berserta petunjuk prestasinya setelah berbincang dengan PPP)", :align => :left, :size => 12  
    move_down 5
  end
  
  def table_lampiranA2
    item_with_skt=[]
    heading=[0,1]
    item_count2=1
    nil_rows=[]  
    @staff_appraisal.staff_appraisal_skts.where('half =?', 2).order(priority: :asc).each_with_index do |staff_appraisal_skt, indx|
       if staff_appraisal_skt.indicator_desc_quality!='' && staff_appraisal_skt.target_quality!=''
          item_count2+=1
          item_with_skt << item_count2
       end
       if staff_appraisal_skt.indicator_desc_time!='' && staff_appraisal_skt.target_time!=''
         item_count2+=1
         item_with_skt << item_count2
       end
       if staff_appraisal_skt.indicator_desc_quantity!='' && staff_appraisal_skt.target_quantity!=''
         item_count2+=1
         item_with_skt << item_count2
      end
      if staff_appraisal_skt.indicator_desc_cost!='' && staff_appraisal_skt.target_cost!=''
        item_count2+=1
        item_with_skt << item_count2
      end
      item_count2+=1
      nil_rows << item_count2
      item_count2+=1
      heading << item_count2
      item_count2+=1
      heading << item_count2
    end  
    if @staff_appraisal.staff_appraisal_skts.where('half =?', 2).count > 0
      table(line_item , :column_widths => [50, 105, 105, 105, 50, 106], :cell_style => { :size => 11, :inline_format => :true}) do
        heading.each do |rr|
          row(rr).background_color="F0EEEE"
        end
        nil_rows.each do |rr|
          row(rr).borders=[]
        end
        item_with_skt.each do |rr|
          row(rr).background_color= "FFFFFF"
        end 
      end
    else 
      table(line_item_empty, :column_widths => [50, 100, 100, 100, 50, 100], :cell_style => { :size => 11, :inline_format => :true}) do
        row(0..1).background_color = "F0EEEE"
        row(2..2).background_color = "FFFFFF"
        row(2).height = 20
      end
    end
  end
  
  def line_item_empty
    arr=[]
    arr << ["",  {content: "Ringkasan Aktiviti / Projek", colspan: 5}]
    arr << [{content: "Petunjuk Prestasi", colspan: 2}, "Sasaran", "Pencapaian", "%", "Ulasan"]
    arr << ["","","","","",""]
    arr
  end
  
  def line_item
     counter = counter || 0
     arr=[]
     @staff_appraisal.staff_appraisal_skts.where('half =?', 2).order(priority: :asc).each_with_index do |staff_appraisal_skt, indx|
         counter += 1
         arr << [ "#{staff_appraisal_skt.priority.blank? ? staff_appraisal_skt.priority : counter}", {content: "#{staff_appraisal_skt.description}", colspan: 5}]
         arr << [ {content: "Petunjuk Prestasi", colspan: 2}, "Sasaran", "Pencapaian", "%", "Ulasan"]
         arr << [ "Kualiti", "#{staff_appraisal_skt.indicator_desc_quality}", "#{staff_appraisal_skt.target_quality}", "#{staff_appraisal_skt.achievement_quality}", "#{@view.number_with_precision(staff_appraisal_skt.progress_quality, precision: 2)}", "#{staff_appraisal_skt.notes_quality}"] if staff_appraisal_skt.indicator_desc_quality!='' && staff_appraisal_skt.target_quality!=''
         arr << [ "Masa", "#{staff_appraisal_skt.indicator_desc_time}", "#{staff_appraisal_skt.target_time}", "#{staff_appraisal_skt.achievement_time}", "#{@view.number_with_precision(staff_appraisal_skt.progress_time, precision:2)}", "#{staff_appraisal_skt.notes_time}"] if staff_appraisal_skt.indicator_desc_time!='' && staff_appraisal_skt.target_time!=''
         arr << [ "Kuantiti", "#{staff_appraisal_skt.indicator_desc_quantity}", "#{staff_appraisal_skt.target_quantity}", "#{staff_appraisal_skt.achievement_quantity}", "#{@view.number_with_precision(staff_appraisal_skt.progress_quantity, precision: 2)}", "#{staff_appraisal_skt.notes_quantity}"] if staff_appraisal_skt.indicator_desc_quantity!='' && staff_appraisal_skt.target_quantity!=''
         arr << [ "Kos", "#{staff_appraisal_skt.indicator_desc_cost}", "#{staff_appraisal_skt.target_cost}", "#{staff_appraisal_skt.achievement_cost}", "#{@view.number_with_precision(staff_appraisal_skt.progress_cost, precison: 2)}", "#{staff_appraisal_skt.notes_cost}"] if staff_appraisal_skt.indicator_desc_cost!='' && staff_appraisal_skt.target_cost!=''
          arr << ["","","","","",""]
    end
    arr
  end
    
  def lampiranA2b
    move_down 30 
    text "BAHAGIAN II - Kajian Semula Sasaran Kerja Tahunan Pertengahan Tahun", :align => :left, :size => 12, :style => :bold 
    move_down 20
    text "1.   Aktiviti/Projek Yang Digugurkan", :align => :left, :size => 12, :style => :bold 
    text "(PYD hendaklah menyeneraikan aktiviti/projek yang digugurkan setelah berbincang dengan PPP)", :align => :left, :size => 12
    move_down 5
  end
  
  def table_lampiranAa3
    xx=@staff_appraisal.staff_appraisal_skts.where('is_dropped = ?', true).count
    table(line_item2, :column_widths => [30,480], :cell_style => { :size => 11}) do
      row(0).font_style = :bold
      self.row_colors = ["FEFEFE", "FFFFFF"]
      if xx==0
        row(1).height = 40
      end
    end
  end
  
  def line_item2
    counter = counter || 0
    header = [["Bil", "Aktiviti/Projek"]]
    header << ["", ""] if @staff_appraisal.staff_appraisal_skts.where('is_dropped = ?', true).count==0
    header +
      @staff_appraisal.staff_appraisal_skts.where('is_dropped = ?', true).order(priority: :asc).map do |staff_appraisal_skt|
        if staff_appraisal_skt.is_dropped == true
          ["#{counter += 1}", "#{staff_appraisal_skt.description}"]
        end
      end
  end

  def lampiranA3a
    move_down 20
    text "BAHAGIAN III -  Laporan dan Ulasan Keseluruhan Pencapaian Sasaran Kerja Tahunan Pada Akhir Tahun Oleh PYD dan PPP", :align => :left, :size => 12, :style => :bold  
    move_down 20                   
    text "1.   Laporan/Ulasan Oleh PYD", :align => :left, :size => 12, :style => :bold    
    
    data = []
    data << ["#{ @staff_appraisal.skt_pyd_report}"]
    table(data, :column_widths => [510], :cell_style => { :size => 11, :inline_format => :true }) do
      self.row_colors = ["FEFEFE", "FFFFFF"]    
      row(0).height =80
    end
  end 

  def lampiranA3b
    move_down 10
    text "2.   Laporan/Ulasan Oleh PPP", :align => :left, :size => 12, :style => :bold 
  
    data1 = [[" #{@staff_appraisal.skt_ppp_report} "]]
    table(data1, :column_widths => [510], :cell_style => { :size => 11}) do
      self.row_colors = ["FEFEFE", "FFFFFF"]    
      row(0).height =80
    end
  end 
  
  def lampiranA3c
    move_down 10
    data2 = [["#{@staff_appraisal.appraised.name}","#{@staff_appraisal.eval1_officer.name}"],
        [ "Tandatangan PYD", "Tandatangan PPP"],
        ["Tarikh : #{@staff_appraisal.skt_pyd_report_on.try(:strftime, "%d-%m-%Y")}", 
          "Tarikh : #{@staff_appraisal.skt_ppp_report_on.try(:strftime, "%d-%m-%Y")}"]] 
      
    table(data2 , :column_widths => [270,240], :cell_style => { :size => 11}) do
        row(0).font_style = :bold
        row(1).borders = [ ]
        row(0..2).align = :center
        row(2).borders = [ ]
        row(0).background_color = 'FFFFFF'
    end 
  end   

end

