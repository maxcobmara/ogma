class Kewpa7Pdf < Prawn::Document
  def initialize(location, current_user, asset_placements, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @location = location
    #@current_user = current_user
    @asset_admin_post = Position.where('name ILIKE(?) OR tasks_main ILIKE(?) OR tasks_other ILIKE(?)', "%pegawai aset%", "%pegawai aset%", "%pegawai aset%").first
    @asset_placements = asset_placements
    @college=college
    font "Times-Roman"
    text "KEW.PA-7", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "SENARAI ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
    description
    heading
    asset_list if @asset_placements.count > 1
    #move_down 500
    if y < 360
      start_new_page
      heading
    end
    asset_last if @asset_placements.count > 0
    blank_rows if @asset_placements.count < 14 #4
    signature_block
    row_only_block
    note_block
  end
  
  def description
    move_down 15
    #data = [["BAHAGIAN", ":", @college.name],["LOKASI", ":", "#{@location.combo_code} - #{@location.name}"]]
    #table(data,  :column_widths => [100, 10, 415], :cell_style => {:border_color => "FFFFFF",  :size => 10, :height => 20})
    text "BAHAGIAN : #{@college.name}", :size => 12
    text "LOKASI : #{@location.combo_code}", :size => 12
  end
  
  def heading
    move_down 5
    heading_row = [[ 'Bil', 'Keterangan Aset', "", 'Kuantiti']]
    table(heading_row, :column_widths => [30, 130, 250, 115], :cell_style => { :size => 10, :height => 20}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      columns(1).borders = [:top, :left, :bottom]
      columns(2).borders = [:top, :right, :bottom]
      columns(3).align = :center
      self.header = true
      self.width = 525
      header = true
    end
  end

  def asset_list
    table(line_item_rows, :column_widths => [30, 130, 250, 115], :cell_style => { :size => 10, :height => 20})  do
      columns(1).borders = [:top, :left, :bottom]
      columns(2).borders = [:top, :right, :bottom]
      columns(3).align = :center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.width = 525
    end
  end
  
  def line_item_rows
    counter = counter || 0
    a=[]
    @asset_placements.each do |asset_placement|
      a << ["#{counter += 1}", "#{asset_placement.asset.assetcode}", "#{asset_placement.asset.typename} #{asset_placement.asset.name} #{asset_placement.asset.modelname}","#{asset_placement.asset.assettype==1 ? 1 : asset_placement.quantity}"] if counter < @asset_placements.count-1
    end  
  end
  
  def asset_last
    ccount=@asset_placements.count
    asset_placement=@asset_placements[ccount-1]
    asset_last_row =[["#{ccount}", "#{asset_placement.asset.assetcode}", "#{asset_placement.asset.typename} #{asset_placement.asset.name} #{asset_placement.asset.modelname}","#{asset_placement.asset.assettype==1 ? 1 : asset_placement.quantity}"]]
    
    table(asset_last_row, :column_widths => [30, 130, 250, 115], :cell_style => { :size => 10, :height => 20}) do
      columns(1).borders = [:top, :left, :bottom]
      columns(2).borders = [:top, :right, :bottom]
      columns(3).align = :center
      self.width = 525
    end
  end

  def blank_rows
    table(b_rows, :column_widths => [30, 130, 250, 115], :cell_style => { :size => 10, :height => 20}) do
      columns(1).borders = [:top, :left, :bottom]
      columns(2).borders = [:top, :right, :bottom]
      columns(3).align = :center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.width = 525
    end
  end
  
  def b_rows
    b=[]
    0.upto(13-@asset_placements.count-1) do |count|
      b+= [ ["","","",""]]
    end
    b
  end
  
  def signature_block
    move_down 20
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
     ["Nama : #{@asset_admin_post.try(:staff).try(:name)}", "Nama : #{@location.try(:administrator).try(:name)}"],
     ["Jawatan : #{@asset_admin_post.try(:name)}", "Jawatan : #{@location.try(:position).try(:name)}"],
     ["Tarikh : #{Date.today.strftime('%d-%b-%Y')}", "Tarikh : #{Date.today.strftime('%d-%b-%Y')}"]
    ]
  end  
  
  def row_only_block
    table row_only_block_content do
      rows(0).borders=[:bottom]
      self.cell_style = { size: 5, height:10 }
      self.width = 520
    end
  end
  
  def row_only_block_content
    [[""]]
  end
  
  def note_block
    move_down 10
    table note_block_content do
      columns(0).width = 50
      columns(1).width = 25
      self.width = 525
      self.cell_style ={:border_color=>"FFFFFF"}
      self.cell_style = { size: 10, height:20 }
    end
  end
  
  def note_block_content
    [["Nota:","a) ", "Disediakan oleh Pegawai Aset"],
     ["","b) ","Pegawai yang mengesahkan ialah pegawai yang bertanggujawab"],
     ["","","ke atas aset berkenaan contohnya :"],
     ["","","i) Lokasi bilik Setiausaha Bahagian - disahkan oleh Setiausaha Bahagian"],
     ["","","ii) Lokasi bilik mesyuarat - disahkan oleh pegawai yang menguruskan bilik mesyuarat"],
     ["","c) ","Dikemaskini apabila terdapat perubahan kuantiti, lokasi atau pegawai bertanggujawab"]
     ]
  end
  
end