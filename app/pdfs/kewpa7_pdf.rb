class Kewpa7Pdf < Prawn::Document
  def initialize(location, current_user)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @location = location
    @current_user = current_user
    font "Times-Roman"
    text "KEW.PA-7", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "SENARAI ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
    description
    asset_list
    signature_block
  end
  
  def description
    move_down 45
    data = [["BAHAGIAN", ":", "KSKB JOHOR" ],["LOKASI", ":", "#{@location.combo_code} - #{@location.name}"]]
    table(data, :width => 250, :cell_style => {:border_color => "FFFFFF"})
  end
  
  def asset_list
    move_down 5
    
    table line_item_rows do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      columns(0).width = 30
      columns(1).borders = [:top, :left, :bottom]
      columns(1).width = 125
      columns(2).borders = [:top, :right, :bottom]
      columns(3).align = :center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.cell_style = { size: 10 }
      self.width = 525
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[ 'Bil', 'Keterangan Aset', "", 'Quantity']]
    header +
    @location.assets.map do |asset|
      ["#{counter += 1}", "#{asset.assetcode}", "#{asset.typename} #{asset.name} #{asset.modelname}", 1]
    end
  end
  
  def signature_block
    move_down 50
    table signature_block_content do
      self.width = 525
      row(1).padding = [ 40,0,0,24]
      row(2).padding = [  0,0,20,24]
      self.cell_style = {:border_color => "FFFFFF"}
    end
  end
  
  def signature_block_content
    [["(a) Disediakan oleh :", "(b) Disahkan oleh :"],
     ["#{'.'*40}", "#{'.'*40}"],
     ["Tandatangan", "Tandatangan"],
     ["Nama : #{@current_user.try(:staff).try(:name)}", "Nama : #{@location.try(:administrator).try(:name)}"],
     ["Jawatan : #{@current_user.try(:staff).try(:position).try(:name)}", "Jawatan : #{@location.try(:position).try(:name)}"],
     ["Tarikh : #{Date.today}", "Tarikh : #{Date.today}"]
    ]
  end  
end