class Document_reportPdf < Prawn::Document
  def initialize(documents, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @documents = documents
    @view = view
    @college=college
    font "Times-Roman"
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [30,50, 100, 90, 80, 80 ,110], :cell_style => { :size => 10,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 12
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
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
    if @college.code=='amsas'
       header = [[{content: "REKOD KELUAR-MASUK SURAT RASMI #{@college.name.upcase}", colspan: 7}],[ 'No', 'Tarikh', I18n.t('document.from2'), 'No Rujukan', 'Tarikh Surat', 'Perkara', 'Tindakan/Makluman']]
    else
      header = [[{content: "REKOD MASUK SURAT-SURAT RASMI #{@college.name.upcase}", colspan: 7}],[ 'No', 'Tarikh', 'Daripada', 'No Rujukan', 'Tarikh Surat', 'Perkara', 'Tindakan/Makluman']]
    end
    header +
      @documents.map do |document|
      ["#{counter += 1}", "#{document.letterxdt.try(:strftime, "%d/%m/%y")}", "#{document.from} " , "#{document.refno}"," #{document.letterdt.try(:strftime, "%d/%m/%y")}", "#{document.title}",  "#{@circulation_details[counter-1]}"]
    end
  end
end