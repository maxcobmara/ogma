class Kewpa19Pdf < Prawn::Document
  def initialize(disposal, view, lead)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @disposal = disposal
    @view = view
    @lead = lead
    font "Times-Roman"
    text "KEW.PA-19", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "KEMENTERIAN/JABATAN : KKM/KSKNJB", :align => :left, :size => 14
    move_down 20
    text "SIJIL PELUPUSAN ASET KERAJAAN MALAYSIA", :align => :center, :size => 14, :style => :bold
    move_down 20
    text "Merujuk surat kelulusan No rujukan   #{@disposal.document.refno}  , bertarikh   #{@disposal.document.letterdt} , 
    saya mengesahkan tindakan pelupusan telah dilaksanakan seperti berikut :-", :align => :left, :size => 10
    move_down 10
    text "1.  Aset berikut telah dilupuskan secara pindahan/hadiah." , :align => :left, :width => 200, :size => 10
    text "  Bilangan item #{@disposal.quantity} dipindahkan / hadiah kepada #{@disposal.receiver_name} ", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    text  "(Surat Akuan Terima Disertakan)", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    
    move_down 10
    text "2.  Aset berikut telah dilupuskan secara jual.", :align => :left, :width => 200, :size => 10
    text "Bilangan item #{@disposal.quantity}  No. Resit  #{@disposal.documentation_no} ", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    text "     (Salinan Resit Disertakan)", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    move_down 10
    text "3.  Aset berikut telah dilupuskan secara musnah.", :align => :left, :width => 200, :size => 10
    text "Bilangan item : #{@disposal.quantity}", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    text  "Cara dimusnahkan : #{@disposal.discard_options}", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    text "(Sijil Menyaksikan Pemusnahan disertakan)", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    
    move_down 10
    text "4.  Aset berikut telah dilupuskan melalui kaedah-kaedah lain.", :align => :left, :width => 200, :size => 10
    text "Bilangan item : #{@disposal.quantity}", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    text "Kaedah pelupusan : #{@disposal.type_others_desc}", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    text "(Dokumen berkaitan disertakan)", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    move_down 10
    text "5.  Aset berikut telah dimasukkan ke dalam stok.", :align => :left, :width => 200, :size => 10
    text "Bilangan item : #{@disposal.quantity}", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    text "Salinan Kad Kawalan Stok Disertakan)", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    move_down 40
    table1
   
  end
  
  def table1
    
    data = [["Tandatangan Ketua Jabatan", ":", ""],
    ["Nama", ": #{@lead.try(:staff).try(:name)}",""],
    ["Jawatan", ": #{@lead.name}",""],
    ["Tarikh",": #{@disposal.discarded_on.try(:strftime, "%d/%m/%y")}",""],
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