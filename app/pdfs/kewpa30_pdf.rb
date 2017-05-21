class Kewpa30Pdf < Prawn::Document
  def initialize(asset_loss, view)
    super({top_margin: 50, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @asset_loss = asset_loss
    @view = view

    bounding_box([bounds.left, bounds.top], :width  => bounds.width, :height => bounds.height) do    
    
        font "Times-Roman"
        text "KEW.PA-30", :align => :right, :size => 16, :style => :bold
        move_down 20
        text "LAPORAN AKHIR KEHILANGAN ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
        move_down 30
        text "Nyatakan :-", :align => :left, :size => 12
        move_down 20
        text "1.      Keterangan Aset Yang Hilang", :align => :left, :size => 12
        move_down 10
        text "  (a)   Jenis Aset  : #{@asset_loss.try(:asset).try(:typename)}", :align => :left, :size => 12, :indent_paragraphs => 30
        move_down 5
        text "  (b)   Jenama dan Model  : #{@asset_loss.try(:asset).try(:name)} #{@asset_loss.try(:asset).try(:modelname)}", :align => :left, :size => 12, :indent_paragraphs => 30
        move_down 5
        text "  (c)   Kuantiti  :", :align => :left, :size => 12, :indent_paragraphs => 30
        move_down 5
        text "  (d)   Tarikh Perolehan  : #{@asset_loss.try(:asset).try(:purchasedate).try(:strftime, "%d/%m/%y")}", :align => :left, :size => 12, :indent_paragraphs => 30
        move_down 5
        text "  (e)   Harga Perolehan Asal  : #{@asset_loss.try(:asset).try(:purchaseprice)}", :align => :left, :size => 12, :indent_paragraphs => 30
        move_down 20
        text "2.      Perihal Kehilangan", :align => :left, :size => 12
        move_down 10
        text "(a)   Tarikh deketahui: #{@asset_loss.try(:lost_at).try(:strftime, "%d/%m/%y")}", :align => :left, :size => 12, :indent_paragraphs => 30
        move_down 5
        text "(b)   Tarikh sebenar berlaku: #{@asset_loss.try(:lost_at).try(:strftime, "%d/%m/%y")}", :align => :left, :size => 12, :indent_paragraphs => 30
        move_down 5
        text "(c)   Tempat Kejadian: #{@asset_loss.try(:location).try(:location_list)}", :align => :left, :size => 12, :indent_paragraphs => 30
        move_down 5
        text "(d)   Bagaimana kehilangan diketahui: #{@asset_loss.try(:how_desc)}" , :align => :left, :size => 12, :indent_paragraphs => 30
        move_down 5
        text "(e)   Bagaimana kehilangan berlaku:", :align => :left, :size => 12, :indent_paragraphs => 30
        move_down 20
        text "3.      Sama ada Laporan Hasil Penyiasatan Polis telah diterima. ", :align => :left, :size => 12
        text "  Jika ada, sila sertakan : #{@asset_loss.try(:police_report_code)}", :align => :left, :size => 12, :indent_paragraphs => 25
        move_down 60
        text "4.      (a)   Nama pegawai yang :", :align => :left, :size => 12
        move_down 10
        text "          (i)   Secara langsung menjaga aset tersebut ", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 50
        text "          (ii)   Bertanggungjawab sebagai penyelia. ", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 50
        text "          (iii)   Bertanggungjawab ke atas kehilangan itu. ", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 50
        start_new_page
        text "4.  (b)   Nama pegawai yang :", :align => :left, :size => 12
        move_down 10
        text "(i)   Jawatan hakiki pada masa kehilangan ", :align => :left, :size => 12, :indent_paragraphs => 25
        move_down 20
        text "(i)   Tugasnya (sertakan senarai tugas). ", :align => :left, :size => 12, :indent_paragraphs => 25
        move_down 20
        text " (i)   Taraf Jawatan (sama ada tetap /dalam percubaan /sementara /kontrak) ", :align => :left, :size => 12, :indent_paragraphs => 25
        move_down 20
        text "(i)   Sama ada ditahan kerja atau digantung kerja. Jika ada nyatakan 
               tarikh kuatkuasa hukuman. ", :align => :left, :size => 12, :indent_paragraphs => 25
        move_down 20
        text "(i)   Tarikh bersara atau penamatan perkhidmatan. ", :align => :left, :size => 12, :indent_paragraphs => 25
        move_down 20
        text " (i)   Sama ada pernah melakukan apa-apa kesalahan dan hukumannya. 
               (Jika ada, berikan butir-butir ringkas dan rujukannya) ", :align => :left, :size => 12, :indent_paragraphs => 25
        move_down 20
        text "(i)   Maklumat lain, jika ada. ", :align => :left, :size => 12, :indent_paragraphs => 25
        move_down 40
        text "5.    Nyatakan adakah Tatacara Pengurusan Aset Alih Kerajaan, Arahan Keselamatan Kerajaan atau arahan 
        lain termasuk langkah berjaga-jaga yang tidak dipatuhi atau diikuti. Jika ada nyatakan peraturan atau 
        arahan tersebut.", :align => :left, :size => 12
        move_down 40
        text "6.    Apakah langkah-langkah yang telah diambil untuk mencegah berulangnya kejadian ini.", :align => :left, :size => 12
        move_down 40
        text "7.    Rumusan Siasatan", :align => :left, :size => 12
        move_down 60
        text "8.    Nyatakan sama ada surcaj atau tatatertib patut dikenakan atau tidak dengan memberikan justifikasi.", :align => :left, :size => 12
        move_down 60
        text "Tandatangan	:	...............................(Pengerusi)", :align => :left, :size => 12
        text "Nama          :	.........................................", :align => :left, :size => 12
        text "Jawatan       :	.........................................", :align => :left, :size => 12
        text "Tarikh        :	.........................................", :align => :left, :size => 12
        move_down 40
        start_new_page
        text "Tandatangan	:	...............................(Ahli)", :align => :left, :size => 12
        text "Nama          :	.........................................", :align => :left, :size => 12
        text "Jawatan       :	.........................................", :align => :left, :size => 12
        text "Tarikh        :	.........................................", :align => :left, :size => 12
        move_down 40
        text "Tandatangan	:	...............................(Ahli)", :align => :left, :size => 12
        text "Nama          :	.........................................", :align => :left, :size => 12
        text "Jawatan       :	.........................................", :align => :left, :size => 12
        text "Tarikh        :	.........................................", :align => :left, :size => 12
        move_down 40
    
        ### - For test - sample - signatory must be attached with last item on the last page - 12 May 2015
        #move_down 500
        ###
    
        if bounds.height - y > 265
          start_new_page
        end
    
        #START - last item + last SIGNATORY PART on last page 
        text "9.  Syor dan Ulasan Pegawai Pengawal :-", :align => :left, :size => 12
        move_down 30
        text "      Syor:", :align => :left, :size => 12
        move_down 60
        text "      Ulasan:", :align => :left, :size => 12
        move_down 70
        text "Tandatangan              :	", :align => :left, :size => 12
        text "Nama                     :	", :align => :left, :size => 12
        text "Jawatan                  :	", :align => :left, :size => 12
        text "Tarikh                   :	", :align => :left, :size => 12
        text "Cop Kementerian/Jabatan :	", :align => :left, :size => 12
        #END - last item + last SIGNATORY PART on last page 
    end    
    
   
  end
  
  
end