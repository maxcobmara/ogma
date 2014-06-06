class Kewpa19Pdf < Prawn::Document
  def initialize(disposal, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @disposals = disposal
    @view = view
    font "Times-Roman"
    text "KEW.PA-19", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "KEMENTERIAN/JABATAN : KKM/KSKNJB", :align => :left, :size => 14
    move_down 20
    text "SIJIL PELUPUSAN ASET KERAJAAN MALAYSIA", :align => :center, :size => 14, :style => :bold
    move_down 20
    text "Merujuk surat kelulusan No rujukan .... bertarikh .... , saya mengesahkan tindakan 
    pelupusan telah dilaksanakan seperti berikut :-", :align => :left, :size => 10
    move_down 10
    text "1.  Aset berikut telah dilupuskan secara pindahan/hadiah.
              Bilangan item ...... dipindahkan / hadiah kepada (Surat Akuan Terima Disertakan)", :align => :left, :width => 200, :size => 10
    
    move_down 10
    text "2.  Aset berikut telah dilupuskan secara jual.
    Bilangan item ...... No. Resit       (Salinan Resit Disertakan)", :align => :left, :width => 200, :size => 10
    move_down 10
    text "3.  Aset berikut telah dilupuskan secara musnah.
       Bilangan item :
       Cara dimusnahkan :Tanam
        (Sijil Menyaksikan Pemusnahan disertakan)", :align => :left, :width => 200, :size => 10
    
    move_down 10
    text "4.  Aset berikut telah dilupuskan melalui kaedah-kaedah lain.
    Bilangan item :
    Kaedah pelupusan :
    (Dokumen berkaitan disertakan)", :align => :left, :width => 200, :size => 10
    move_down 10
    text "5.  Aset berikut telah dimasukkan ke dalam stok.
    Bilangan item :
    (Salinan Kad Kawalan Stok Disertakan)", :align => :left, :width => 200, :size => 10
    move_down 40
    table1
   
  end
  
  def table1
    
    data = [["Tandatangan Ketua Jabatan", ":", ""],
    ["Nama", ":",""],
    ["Jawatan", ":",""],
    ["Tarikh",":",""],
    ["Cop Jabatan / Bahagian", ":",""]]
    
    table(data, :column_widths => [150, 180], :cell_style => { :size => 10})  do
      row(0).borders = [ ]
      row(1).borders = [ ]
      row(2).borders = [ ]
      row(3).borders = [ ]
      row(4).borders = [ ]
    end
  end
  
end