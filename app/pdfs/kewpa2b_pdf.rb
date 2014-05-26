class Kewpa2bPdf < Prawn::Document
  def initialize(asset, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @asset = asset
    @view = view

    font "Times-Roman"
    text "KEW.PA-2", :align => :right, :size => 14, :style => :bold
    move_down 10
    text "DAFTAR HARTA MODAL", :align => :center, :size => 12, :style => :bold
    move_down 10
    text "BUTIR BUTIR PENAMBAHAN, PENGGANTIAN DAN NAIKTARAF", :align => :center, :size => 12
    move_down 10
    text "Bahagian A ", :align => :center, :size => 12, :style => :bold
    move_down 5
    
    make_tables1
    make_tables2

  end
  

    
  def make_tables1
    
    
    header = [ ["Bil ", "Tarikh", "Butiran", "Tempoh Jaminan", "kos (RM)", " Nama & Tandatangan"]]
    table(header , :column_widths => [30, 90, 100, 100, 100, 100], :cell_style => { :size => 10}) do
    row(0).font_style = :bold
    row(0).align = :center
    row(0).background_color = 'FFE34D'
  end
 end  
 
 def make_tables2
   table(line_item_rows, :column_widths => [30, 90, 100, 100, 100, 100], :cell_style => { :size => 10})
 end
 def line_item_rows
   counter = counter || 0

   @asset.maints.map do |maint|
     ["#{counter += 1}", "#{maint.created_at}", "#{maint.details} ", "#{maint.workorderno} ",
       "#{maint.maintcost} ",""]
   end
 end

  
end

  

  
