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
    data1 = [[{content: "1. Jenis Aset", colspan: 2}, ": #{@defective.try(:asset).try(:typename)}"],
             [{content: "2. Keterangan Aset", colspan: 2},": #{@defective.try(:asset).try(:name)}"],
             [{content: "3. No Siri Pendaftaran", colspan: 2},": #{@defective.try(:asset).try(:assetcode)}"],
             [{content: "4. Kos Penyelenggaraan Terdahulu", colspan: 2},": #{@defective.try(:asset).try(:maint).try(:maintcost)}"],
             [{content: "5. Pengguna Terakhir", colspan: 2},": #{@defective.reporter.try(:name)}  #{@defective.reporter.try(:position_old)}"],
             [{content: "6. Tarikh Kerosakan", colspan: 2},": #{@defective.created_at.try(:strftime, "%d/%m/%y")}"],
             [{content: "7. Perihal Kerosakan", colspan: 2},":"],
             ["", "- #{@defective.description}",""]]
             
             table(data1, :column_widths => [15, 165, 320], :cell_style => { :size => 11}) do
               row(0..7).borders = [ ]
               row(7).align = :left
             end
  end
  
  def table2
    data1 = [[{content: "8. Syor Pegawai Aset", colspan: 2}, ":"],
             ["", "- #{@defective.process_type}",""],
             ["", "- #{@defective.recommendation}",""]]
             
             table(data1, :column_widths => [15, 165, 320], :cell_style => { :size => 11}) do
               row(0..2).borders = [ ]
               row(1..2).align = :left
             end
             move_down 20
  end

  def signatory
     
      text "Nama : #{@defective.processor.try(:name)}", :align => :left, :size => 11
      text "Jawatan : #{@defective.processor.try(:position).try(:name)}", :align => :left, :size => 11
      text "Tarikh : #{@defective.processed_on.try(:strftime, "%d/%m/%y")}", :align => :left, :size => 11
      move_down 20
      text "Bahagian II (Keputusan Ketua Jabatan)", :align => :left, :size => 11
      move_down 10
      text "#{@defective.decision? ? I18n.t('approved') : I18n.t('not_approved')}", :align => :left, :size => 11
      move_down 40
      text "Tandatangan : ", :align => :left, :size => 11
      text "Nama : #{@lead.try(:name)}", :align => :left, :size => 11
      text "Jawatan : #{@lead.try(:positions).try(:first).try(:name)}", :align => :left, :size => 11
      text "Tarikh : #{@defective.decision_on.try(:strftime, '%d/%m/%Y')}", :align => :left, :size => 11
  end
end