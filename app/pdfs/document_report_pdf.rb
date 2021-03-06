class Document_reportPdf < Prawn::Document
  def initialize(documents, view)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @documents = documents
    @view = view
    font "Times-Roman"
    move_down 20
    text "REKOD MASUK SURAT-SURAT RASMI KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", :align => :center, :size => 12, :style => :bold
    move_down 20
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [30,50, 100, 90, 80, 80 ,110], :cell_style => { :size => 10,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width = 540
      header = true
    end
  end
  
  def line_item_rows
    @circulation_details=[]
    @documents.each do |document|
      circulation_details=""
      document.circulations.each_with_index do |circulation, ind|
        circulation_details += "(#{ind+=1}) #{circulation.staff.name} - #{circulation.action_taken}<br>"
      end
      @circulation_details << circulation_details
    end
    counter = counter || 0
    header = [[ 'No', 'Tarikh', 'Daripada', 'No Rujukan', 'Tarikh Surat', 'Perkara', 'Tindakan/Makluman']]
    header +
      @documents.map do |document|
      ["#{counter += 1}", "#{document.letterxdt.try(:strftime, "%d/%m/%y")}", "#{document.from} " , "#{document.refno}"," #{document.letterdt.try(:strftime, "%d/%m/%y")}", "#{document.title}",  "#{@circulation_details[counter-1]}"]
    end
  end
end