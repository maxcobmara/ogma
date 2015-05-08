class Training_reportPdf < Prawn::Document
  def initialize(ptdos, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @ptdos = ptdos
    @view = view
    font "Times-Roman"
    move_down 20
    text "REKOD PENGESAHAN", :align => :center, :size => 12, :style => :bold
    move_down 10
    text "KEHADIRAN PROGRAM LATIHAN", :align => :center, :size => 12, :style => :bold
    move_down 20
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [30,500,200, :cell_style => { :size => 10,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 730
      header = true
    end
  end
  
  def line_item_rows
#     @circulation_details=[]
#     @documents.each do |document|
#       circulation_details=""
#       document.circulations.each_with_index do |circulation, ind|
#         circulation_details += "(#{ind+=1}) #{circulation.staff.name} - #{circulation.action_taken}<br>"
#       end
#       @circulation_details << circulation_details
#     end
    counter = counter || 0
    header = [[ 'Bil', 'Program Latihan', 'Bilangan Hari']]
    header +
      @ptdos.group_by{|x|x.training_classification}.map do |classsification, ptdos|
      ["#{counter += 1}", "#{classification}", "#{ptdos.count} "]
    end
  end
end