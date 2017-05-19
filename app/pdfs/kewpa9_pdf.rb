class Kewpa9Pdf < Prawn::Document
  def initialize(defective, view , lead)
    super({top_margin: 50, left_margin: 50, page_size: 'A4', page_layout: :portrait })
    @defective = defective
    @view = view
    @lead = lead 
    
    font "Helvetica"
    text "KEW.PA-9", :align => :right, :size => 14, :style => :bold
    move_down 20
    text "BORANG ADUAN KEROSAKAN ASET ALIH KERAJAAN", :align => :center, :size => 12, :style => :bold
    move_down 20
    text "Bahagian 1", :align => :left, :size => 11
    table1
    #move_down 500
    if y < 260
      start_new_page
    end
    table2
    signatory
  end
  
  def table1
    data1 = [["1. Jenis Aset", ": #{@defective.try(:asset).try(:typename)}"],
             ["2. Keterangan Aset", ": #{@defective.try(:asset).try(:name)}"],
             ["3. No Siri Pendaftaran", ": #{@defective.try(:asset).try(:assetcode)}"],
             ["4. Kos Penyelenggaraan Terdahulu", ": #{@defective.try(:asset).try(:maint).try(:maintcost)}"],
             ["5. Pengguna Terakhir", ": #{@defective.reporter.try(:name)}  #{@defective.reporter.try(:position_old)}"],
             ["6. Tarikh Kerosakan", ": #{@defective.created_at.try(:strftime, "%d/%m/%y")}"],
             ["7. Perihal Kerosakan", ":"],
             ["#{@defective.description}",""]]
             
             table(data1, :column_widths => [180, 320], :cell_style => { :size => 11}) do
               row(0..7).borders = [ ]
               row(7).align = :center
             end
  end
  
  def table2
    data1 = [["8. Syor Pegawai Aset", ":"],
             ["#{@defective.process_type}",""],
             ["#{@defective.recommendation}",""]]
             
             table(data1, :column_widths => [180, 320], :cell_style => { :size => 11}) do
               row(0..2).borders = [ ]
               row(1..2).align = :center
             end
             move_down 20
  end

  def signatory
     
      text "Nama : #{@defective.processor.try(:name)}", :align => :left, :size => 11
      text "Jawatan : #{@defective.processor.try(:position).try(:name)}", :align => :left, :size => 11
      text "Tarikh : #{@defective.processed_on.try(:strftime, "%d/%m/%y")}", :align => :left, :size => 11
      move_down 20
      text "Bahagian II (Keputusan Ketua Jabatan)", :align => :left, :size => 11
      text "- #{@defective.decision}", :align => :left, :size => 11
      move_down 40
      text "Tandatangan : ", :align => :left, :size => 11
      text "Nama : #{@lead.try(:staff).try(:name)}", :align => :left, :size => 11
      text "Jawatan : #{@lead.try(:name)}", :align => :left, :size => 11
      text "Tarikh :", :align => :left, :size => 11
  end
end