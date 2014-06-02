class Kewpa9Pdf < Prawn::Document
  def initialize(defective, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @defective = defective
    @view = view
    font "Times-Roman"
    text "KEW.PA-9", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "BORANG ADUAN KEROSAKAN ASET ALIH KERAJAAN", :align => :center, :size => 14, :style => :bold
    move_down 20
    text "Bahagian 1", :align => :left, :size => 14
    table1
    data2
   
  end
  
  def table1
    data1 = [["1. Jenis Aset", ": #{@defective.try(:asset).try(:typename)}"],
             ["2. Keterangan Aset", ": #{@defective.try(:asset).try(:name)}"],
             ["3. No Siri Pendaftaran", ": #{@defective.try(:asset).try(:assetcode)}"],
             ["4. Kos Penyelenggaraan Terdahulu", ": #{@defective.try(:asset).try(:maint).try(:maintcost)}"],
             ["5. Pengguna Terakhir", ": #{@defective.reporter.try(:name)}  #{@defective.reporter.try(:position_old)}"],
             ["6. Tarikh Kerosakan", ": #{@defective.created_at.strftime("%d/%m/%y")}"],
             ["7. Perihal Kerosakan", ":"],
             ["#{@defective.description}",""],
             ["8. Syor Pegawai Aset", ":"],
             ["#{@defective.process_type}",""],
             ["#{@defective.recommendation}",""]]
             
             table(data1, :column_widths => [180, 340]) do
               
               row(0).borders = [ ]
               row(1).borders = [ ]
               row(2).borders = [ ]
               row(3).borders = [ ]
               row(4).borders = [ ]
               row(5).borders = [ ]
               row(6).borders = [ ]
               row(7).borders = [ ]
               row(7).align = :center
               row(8).borders = [ ]
               row(9).borders = [ ]
               row(9).align = :center
               row(10).borders = [ ]
               row(10).align = :center
             end
             move_down 20
end

  def data2
     
      text "Nama : #{@defective.processor.try(:name)}", :align => :left, :size => 14
      text "Jawatan : #{@defective.processor.try(:position).try(:name)}", :align => :left, :size => 14
      text "Tarikh : #{@defective.processed_on.strftime("%d/%m/%y")}", :align => :left, :size => 14
      move_down 20
      text "Bahagian II (Keputusan Ketua Jabatan)", :align => :left, :size => 14
      text "- #{@defective.decision}", :align => :left, :size => 14
      move_down 40
      text "Signature : ", :align => :left, :size => 14
      text "Nama :", :align => :left, :size => 14
      text "Jawatan :", :align => :left, :size => 14
      text "Tarikh :", :align => :left, :size => 14
  end
end