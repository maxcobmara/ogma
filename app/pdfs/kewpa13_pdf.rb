class Kewpa13Pdf < Prawn::Document
  def initialize(asset, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @assets = asset
    @view = view
    font "Times-Roman"
    text "KEW.PA-13", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "SENARAI ASET ALIH KERAJAAN YANG MEMERLUKAN PENYELENGGARAAN", :align => :center, :size => 14, :style => :bold
    asset_list
   
  end
  
  
  def asset_list
    move_down 5
    
    table line_item_rows do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      columns(0).width = 30
      columns(1).borders = [:top, :left, :bottom]
      columns(1).width = 133
      columns(3).align = :center
      columns(4).align = :right
      columns(4).width = 65
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.cell_style = { size: 9 }
      self.width = 525
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[ 'Bil', 'Keterangan Aset', 'Jenis / Jenama / Model', 'Lokasi Aset', 'Harga Perolehan']]
    header +
      @assets.map do |asset|
      ["#{counter += 1}", "#{asset.assetcode}", "#{asset.typename} #{asset.name} #{asset.modelname}", "#{asset.asset_placements.last}", @view.currency(asset.purchaseprice.to_f)]
    end
  end
end