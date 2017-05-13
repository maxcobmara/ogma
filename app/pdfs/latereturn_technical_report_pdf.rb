class LatereturnTechnicalReportPdf < Prawn::Document  
  def initialize(transactions, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @transactions = transactions
    @view = view
    @college = college
    font "Helvetica"
    move_down 10
    text "#{I18n.t('library.transaction.latereturn_technical_report')} #{@transactions.first.returnduedate.year}", :align => :center, :style => :bold
     move_down 10
    table_visitor
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def table_visitor
    count3=0
    data=[["No",I18n.t('library.transaction.borrower_name'),I18n.t('repositories.document_title'), "#{I18n.t('library.transaction.checkoutdate')} <br>#{I18n.t('library.transaction.returnduedate')}", I18n.t('library.transaction.returneddate'), I18n.t('library.transaction.late_by_days').upcase]]
    
    for transaction in @transactions.order(returneddate: :asc)
      repoid=0
      Repository.digital_library.each{|x| repoid=x.id if x.code==transaction.digital_document}
      repo=Repository.find(repoid)
      data << [count3+=1, Visitor.find(transaction.loaner).visitor_with_title, repo.title, "#{transaction.checkoutdate.strftime('%d-%m-%Y')} #{transaction.returnduedate.strftime('%d-%m-%Y')}", transaction.returneddate.try(:strftime, '%d-%m-%Y'), "#{transaction.late_days if transaction.returneddate}" ]
    end
    
    table(data, :column_widths => [30, 120, 210, 60, 60, 40], :cell_style => {:size=>9, :borders => [:left, :right, :top, :bottom],  :inline_format => :true, :padding=>[5,5,5,5]}, :header => 2) do
      row(0).font_style=:bold
      row(0).background_color = 'FFE34D'
      column(0).align=:center
      column(5).align=:center
    end  
    
  end
  
  def footer
    draw_text "#{page_number} #{I18n.t('instructor_appraisal.from')} 1",  :size => 8, :at => [240,-5]
  end
  
end
