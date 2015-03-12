class Kewpa7Pdf < Prawn::Document
  def initialize(location, current_user, asset_placements)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @location = location
    #@current_user = current_user
    @asset_admin = current_user
    @asset_placements = asset_placements
    font "Times-Roman"
    text "KEW.PA-7", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "SENARAI ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
    description
    asset_list
    signature_block
    row_only_block
    note_block
  end
  
  def description
    move_down 15
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
      columns(1).width = 140
      columns(2).borders = [:top, :right, :bottom]
      columns(3).align = :center
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.cell_style = { size: 10, height:20 }
      self.width = 525
      header = true
      
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[ 'Bil', 'Keterangan Aset', "", 'Kuantiti']]
    a= 
       @asset_placements.map do |asset_placement|
      ["#{counter += 1}", "#{asset_placement.asset.assetcode}", "#{asset_placement.asset.typename} #{asset_placement.asset.name} #{asset_placement.asset.modelname}","#{asset_placement.asset.assettype==1 ? 1 : asset_placement.quantity}"] 
      end
    b=[]
    0.upto(14-@asset_placements.count-1) do |count|
      b+= [ ["","","",""]]
    end
  
    header+a+b
      
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
     ["Nama : #{@asset_admin.try(:userable).try(:name)}", "Nama : #{@location.try(:administrator).try(:name)}"],
     ["Jawatan : #{@asset_admin.try(:userable).try(:positions).try(:first).try(:name)}", "Jawatan : #{@location.try(:position).try(:name)}"],
     ["Tarikh : #{Date.today.strftime('%d-%m-%Y')}", "Tarikh : #{Date.today.strftime('%d-%m-%Y')}"]
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