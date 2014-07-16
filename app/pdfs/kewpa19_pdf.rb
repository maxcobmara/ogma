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
    text "Merujuk surat kelulusan No rujukan   <b>#{@disposal.document.refno}</b>  , bertarikh   <b>#{@disposal.document.letterdt}</b> , 
    saya mengesahkan tindakan pelupusan telah dilaksanakan seperti berikut :-", :align => :left, :size => 10, :inline_format => true
    move_down 10
    text "1.  Aset berikut telah dilupuskan secara pindahan/hadiah." , :align => :left, :width => 200, :size => 10
    text "  Bilangan item <b>#{@disposal.quantity}</b> dipindahkan / hadiah kepada <b>#{@disposal.receiver_name}</b> ", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13,:inline_format => true
    text  "(Surat Akuan Terima Disertakan)", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    
    move_down 10
    text "2.  Aset berikut telah dilupuskan secara jual.", :align => :left, :width => 200, :size => 10
    text "Bilangan item </b>#{@disposal.quantity}</b>  No. Resit  <b>#{@disposal.documentation_no}</b> ", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13, :inline_format => true
    text "     (Salinan Resit Disertakan)", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    move_down 10
    text "3.  Aset berikut telah dilupuskan secara musnah.", :align => :left, :width => 200, :size => 10
    text "Bilangan item : <b>#{@disposal.quantity}</b>", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13,:inline_format => true
    text  "Cara dimusnahkan : <b>#{@disposal.discard_options}</b>", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13,:inline_format => true
    text "(Sijil Menyaksikan Pemusnahan disertakan)", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    
    move_down 10
    text "4.  Aset berikut telah dilupuskan melalui kaedah-kaedah lain.", :align => :left, :width => 200, :size => 10
    text "Bilangan item : <b>#{@disposal.quantity}</b>", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13, :inline_format => true
    text "Kaedah pelupusan : <b>#{@disposal.type_others_desc}</b>", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13, :inline_format => true
    text "(Dokumen berkaitan disertakan)", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
    move_down 10
    text "5.  Aset berikut telah dimasukkan ke dalam stok.", :align => :left, :width => 200, :size => 10
    text "Bilangan item : <b>#{@disposal.quantity}</b>", :align => :left, :width => 200, :size => 10, :indent_paragraphs => 13
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