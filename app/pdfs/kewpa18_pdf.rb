class Kewpa18Pdf < Prawn::Document
  def initialize(disposal, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @disposals = disposal
    @view = view
    font "Times-Roman"
    text "KEW.PA-18", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "KEMENTERIAN/JABATAN : KKM/KSKBJB", :align => :left, :size => 14
    text "SIJIL PENYAKSIAN PEMUSNAHAN ASET ALIH KERAJAAN MALAYSIA", :align => :center, :size => 14, :style => :bold
    move_down 20
    text "Disahkan aset seperti maklumat berikut telah dimusnahkan", :align => :left, :size => 14
    move_down 20
    text_box "Jenis Aset : ", :size => 14, :at =>[100,250]
    text_box "Kuantiti : ", :size => 14, :at =>[100,230]
    text_box "Secara : ", :size => 14, :at =>[100,210]
    text_box "Tarikh : ", :size => 14, :at =>[100,190]
    text_box "Tempat : ", :size => 14, :at =>[100,170]
    move_down 40
    table1
   
  end
  
  
  def table1
    
    data1 = [["", "", "",""],
             ["Tandatangan", "","Tandatangan"],
             ["","","",""],
             ["Nama :","","Nama :"],
             ["Jawatan :", "","Jawatan :",""],
             ["Tarikh","","Tarikh",""],
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