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
      columns(0).width = 25
      columns(1).borders = [:top, :left, :bottom]
      columns(1).width = 130
      columns(3).align = :center
      columns(4).align = :right
      columns(4).width = 60
      columns(5).width = 60
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.cell_style = { size: 9 }
      self.width = 525
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[ 'Bil', 'Keterangan Aset', 'Jenis / Jenama / Model', 'Lokasi Aset', 'Harga Perolehan', 'Catatan']]
    header +
      @assets.map do |asset|
        asset_wplacement=Asset.wplacement.pluck(:id)
        if asset_wplacement.include?(asset.id)
          for placement in asset.asset_placements.sort_by{|x|x.location.combo_code}
           placements="#{placement.location.location_list}<br>"
	  end
	else
	  placements=""
	end
      ["#{counter += 1}", "#{asset.assetcode}", "#{asset.typename} #{asset.name} #{asset.modelname}", "#{asset.try(:hmlocation).try(:location_list)} #{placements}", @view.currency(asset.purchaseprice.to_f), "#{asset.remark}" ]
    end
  end
end