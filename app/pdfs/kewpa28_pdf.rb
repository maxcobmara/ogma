class Kewpa28Pdf < Prawn::Document
  def initialize(asset_loss, view, lead)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @asset_loss = asset_loss
    @view = view
    @lead = lead
    
    bounding_box([bounds.left, bounds.top], :width  => bounds.width, :height => bounds.height) do    

        font "Times-Roman"
        text "KEW.PA-28", :align => :right, :size => 16, :style => :bold
        move_down 20
        text "LAPORAN AWAL KEHILANGAN ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
        move_down 20
        text "Nyatakan :-", :align => :left, :size => 12
        move_down 10
        text "1.      Keterangan Aset Yang Hilang", :align => :left, :size => 12
        move_down 5
        text "  (a)   Jenis Aset  : #{@asset_loss.try(:asset).try(:typename)}", :align => :left, :size => 12, :indent_paragraphs => 40

        text "  (b)   Jenama dan Model  : #{@asset_loss.try(:asset).try(:name)} #{@asset_loss.try(:asset).try(:modelname)}", :align => :left, :size => 12, :indent_paragraphs => 40

        text "  (c)   Kuantiti  :", :align => :left, :size => 12, :indent_paragraphs => 40

        text "  (d)   Tarikh Perolehan  : #{@asset_loss.try(:asset).try(:purchasedate).try(:strftime, "%d/%m/%y")}", :align => :left, :size => 12, :indent_paragraphs => 40

        text "  (e)   Harga Perolehan Asal  : #{@asset_loss.try(:asset).try(:purchaseprice)}", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 10
        text "2.      Tempat sebenar di mana kehilangan berlaku.", :align => :left, :size => 12
        text "#{@asset_loss.try(:location).try(:location_list)}", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 10
        text "3.      Tarikh kehilangan berlaku atau diketahui.", :align => :left, :size => 12
        text "#{@asset_loss.try(:lost_at).try(:strftime, "%d/%m/%y")}", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 10
        text "4.      Cara bagaimana kehilangan berlaku.", :align => :left, :size => 12
        text "#{@asset_loss.try(:how_desc)}", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 10
        text "5.      Nama dan jawatan pegawai yang akhir sekali menyimpan/mengguna aset yang hilang.", :align => :left, :size => 12
        text "#{@asset_loss.try(:handled_by).try(:staff).try(:name)}", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 10
        text "6.      Sama ada seseorang pegawai yang difikirkan prima facie bertanggungjawab ke atas kehilangan itu.", :align => :left, :size => 12
        text "Jika ya, nama dan jawatannya", :align => :left, :size => 12, :indent_paragraphs => 40
        text "#{@asset_loss.try(:is_prima_facie?) ? "Nama :" : "Tiada"}", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 10
        text "7.      Sama ada seseorang pegawai telah ditahan kerja.", :align => :left, :size => 12
        text "#{@asset_loss.try(:is_staff_action?) ? "Ada" : "Tiada"}", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 10
        text "8.      No. Rujukan dan Tarikh Laporan Polis.", :align => :left, :size => 12
        text "#{@asset_loss.try(:police_report_code)}", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 10
        text "9.      Langkah-langkah sedia ada untuk menggelakkan kehilangan itu berlaku.", :align => :left, :size => 12
        text "#{@asset_loss.try(:preventive_measures)}", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 10
        text "10.     Langkah-langkah segera yang diambil bagi mencegah berulangnya kejadian itu.", :align => :left, :size => 12
        text "#{@asset_loss.try(:new_measures)}", :align => :left, :size => 12, :indent_paragraphs => 40
        move_down 10
    
        ### - For test - sample - signatory must be attached with last item on the last page - 12 May 2015
        #move_down 500
        ###
    
        #minimum height required for last item+SIGNATORY
        if y < 135   #bounds.height - y > 100
          start_new_page
        end
    
        #START - last item + SIGNATORY PART on last page 
        text "11.     Catatan.", :align => :left, :size => 12
        text "#{@asset_loss.try(:notes)}", :align => :left, :size => 12, :indent_paragraphs => 40
    
        move_down 50
        text "#{'.'*45}", :align => :left, :size => 12, :indent_paragraphs => 250
        text "Tandatangan Ketua Jabatan", :align => :left, :size => 12, :indent_paragraphs => 250
        text "Nama        :	#{@asset_loss.hod.name}", :align => :left, :size => 12, :indent_paragraphs => 250
        text "Jawatan     :	#{@lead.name}", :align => :left, :size => 12, :indent_paragraphs => 250
        text "Tarikh      :	#{@asset_loss.endorsed_on.try(:strftime, "%d/%m/%y")}", :align => :left, :size => 12, :indent_paragraphs => 250
        text "Cop Jabatan :	    ", :align => :left, :size => 12, :indent_paragraphs => 250
        #END - last item + SIGNATORY PART on last page 
   
      end
  
    end  
  
end