class Kewpa18Pdf < Prawn::Document
  def initialize(disposal, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @disposal = disposal
    @view = view
    font "Times-Roman"
    text "KEW.PA-18", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "KEMENTERIAN/JABATAN : KKM/KSKBJB", :align => :left, :size => 14
    move_down 20
    text "SIJIL PENYAKSIAN PEMUSNAHAN ASET ALIH KERAJAAN MALAYSIA", :align => :center, :size => 14, :style => :bold
    move_down 20
    text "Disahkan aset seperti maklumat berikut telah dimusnahkan", :align => :left, :size => 14
    move_down 40
    text "Jenis Aset :  #{@disposal.try(:asset).try(:typename)} #{@disposal.try(:asset).try(:name)} #{@disposal.try(:asset).try(:modelname)}", :align => :left, :size => 14, :indent_paragraphs => 50
    text "Kuantiti   :  #{@disposal.quantity} ", :align => :left, :size => 14, :indent_paragraphs => 50
    text "Secara     :  #{@disposal.discard_options}", :align => :left, :size => 14, :indent_paragraphs => 50
    text "Tarikh     :  #{@disposal.discarded_on.try(:strftime, "%d/%m/%y")}", :align => :left, :size => 14, :indent_paragraphs => 50
    text "Tempat     :  #{@disposal.discard_location}", :align => :left, :size => 14, :indent_paragraphs => 50
    move_down 80
    table1
   
  end
  
  
  def table1
    
    data1 = [["", "", "",""],
             ["Tandatangan", "","Tandatangan"],
             ["","","",""],
             ["Nama : #{@disposal.discard_witness1.try(:name)}","","Nama : #{@disposal.discard_witness2.try(:name)}"],
             ["Jawatan : #{@disposal.discard_witness1.try(:positions).try(:first).try(:name)}", "","Jawatan : #{@disposal.discard_witness2.try(:positions).try(:first).try(:name)}",""],
             ["Tarikh : #{@disposal.discarded_on.try(:strftime, "%d/%m/%y")}","","Tarikh : #{@disposal.discarded_on.try(:strftime, "%d/%m/%y")}",""],
             ["Cop :","","Cop :", ""]]
             
    table(data1, :column_widths => [180, 80, 180], :cell_style => { :size => 7})  do
      row(0).columns(0).borders = [:bottom]
      row(0).columns(1).borders = [ ]
      row(0).columns(2).borders = [:bottom]
      row(0).columns(3).borders = [ ]
      row(1).columns(0).borders = [ ]
      row(1).columns(0).align = :center
      row(1).columns(1).borders = [ ]
      row(1).columns(2).borders = [ ]
      row(1).columns(2).align = :center
      row(2).borders = [ ]
      row(3).borders = [ ]
      row(4).borders = [ ]
      row(5).borders = [ ]
      row(6).borders = [ ]
      self.width = 525
    end
  end
  

end