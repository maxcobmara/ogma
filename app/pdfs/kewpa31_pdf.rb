class Kewpa31Pdf < Prawn::Document
  def initialize(asset_loss, view, lead)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @asset_losses = asset_loss
    @view = view
    @lead = lead
    font "Times-Roman"
    text "KEW.PA-31", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "SIJIL HAPUS KIRA ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
    
    move_down 40
    text "Mejuruk kelulusan Perbendaharaan Bil #{'.'*40} bertarikh 
    #{'.'*40} Aset berikut telah dihapuskira dan Daftar Harta Modal/Inventori berkenaan telah dikemaskini.", :align => :left, :size => 14
    move_down 30
    table1
    table2
    cop
    
    
  end
  
  def table1
    table(line_item_rows,:column_widths => [40, 300, 140]) 

  end
  
  def line_item_rows
    counter = counter || 0
    header = [[ 'Bil', 'Jenis Aset', 'No. Pendaftaran']]
    header +
      @asset_losses.map do |asset_loss|

      ["#{counter += 1}", "#{asset_loss.try(:asset).try(:typename)} #{asset_loss.try(:asset).try(:name)} #{asset_loss.try(:asset).try(:modelname)}", "#{asset_loss.try(:asset).try(:assetcode)}"  ]
    end
  end  
  
  def table2
    data = [["","",""],
          ["","",""],
          ["","",""],
        ["","",""]]
        
      table(data,:column_widths => [40, 300, 140]) do
        row(0).height = 20
        row(1).height = 20
        row(2).height = 20
        row(3).height = 20
      end
      move_down 40
  end
 def cop    
   data = [["Tandatangan Ketua Jabatan", ": "],
            ["Nama", ": #{@lead.try(:staff).try(:name)}"],
            ["Jawatan", ": #{@lead.name}"],
            ["Tarikh",": #{@asset_losses.try(:updated_at).try(:strftime, "%d/%m/%y")}"],
            ["Cop Kemeterian/Jabatan", ":"]]
            
    table(data,:column_widths => [150, 300])  do
         row(0).borders = [ ]
         row(0).height = 20
         row(1).borders = [ ]
         row(1).height = 20
         row(2).borders = [ ]
         row(2).height = 20
         row(3).borders = [ ]
         row(3).height = 20
         row(4).borders = [ ]
         row(4).height = 20
       end
   
  end
  
  
end