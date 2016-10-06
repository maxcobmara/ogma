class LatereturnReportPdf < Prawn::Document  
  def initialize(transactions, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @transactions = transactions
    @view = view
    @college = college
    font "Helvetica"
    if college.code=="kskbjb"
      move_down 10
    end
    bounding_box([10,770], :width => 400, :height => 100) do |y2|
       image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
    end
    bounding_box([90,760], :width => 350, :height => 100) do |y2|
      move_down 10
      text "#{college.name}", :align => :center, :style => :bold
      text "#{I18n.t('library.transaction.latereturn_report')}", :align => :center, :style => :bold
    end
    
    if college.code=="kskbjb"
      bounding_box([400,750], :width => 400, :height => 100) do |y2|
        image "#{Rails.root}/app/assets/images/kskb_logo-6.png",  :width =>97.2, :height =>77.76
      end
    else
      bounding_box([430,770], :width => 400, :height => 90) do |y2|
        image "#{Rails.root}/app/assets/images/amsas_logo_small.png"
      end
    end
    table_staff
    move_down 10
    table_student
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def table_staff
    #:padding=>[2,5,3,5] #tlbr
    count=0
    data=[["NO",I18n.t('library.transaction.borrower_name').upcase,I18n.t('library.transaction.book_title').upcase,I18n.t('library.transaction.checkoutdate').upcase, I18n.t('library.transaction.returneddate').upcase, I18n.t('library.transaction.late_by_days').upcase, "#{I18n.t('library.transaction.total_fine').upcase} (RM)"]]
    
    data << [{content: I18n.t('library.transaction.staff').upcase+@college.code.upcase, colspan: 7}]
    for transaction in @transactions.where('staff_id is not null')
      data << [count+=1, transaction.staff.staff_with_rank, transaction.accession.book.title, transaction.checkoutdate.strftime('%d-%m-%Y'), transaction.returneddate.strftime('%d-%m-%Y'), transaction.late_days, "#{transaction.finepay? ? @view.number_with_precision(transaction.fine, precision: 2) : '0.00'}" ]
    end
    
    table(data, :column_widths => [30, 120, 135, 60, 60, 45, 70], :cell_style => {:size=>10, :borders => [:left, :right, :top, :bottom],  :inline_format => :true, :padding=>[3,5,3,2]}, :header => 2) do
      row(0).font_style=:bold
      column(5..6).style :align => :right
    end  
  end
  
  def table_student
    #:padding=>[2,5,3,5] #tlbr
    count2=0
    data=[["NO",I18n.t('library.transaction.borrower_name').upcase,I18n.t('library.transaction.book_title').upcase,I18n.t('library.transaction.checkoutdate').upcase, I18n.t('library.transaction.returneddate').upcase, I18n.t('library.transaction.late_by_days').upcase, "#{I18n.t('library.transaction.total_fine').upcase} (RM)"]]
    
    data << [{content: I18n.t('library.transaction.student').upcase, colspan: 7}]
    for transaction in @transactions.where('student_id is not null')
      data << [count2+=1, transaction.student.student_with_rank, transaction.accession.book.title, transaction.checkoutdate.strftime('%d-%m-%Y'), transaction.returneddate.strftime('%d-%m-%Y'), transaction.late_days, "#{transaction.finepay? ? @view.number_with_precision(transaction.fine, precision: 2) : '0.00'}" ]
    end
    
    table(data, :column_widths => [30, 120, 135, 60, 60, 45, 70], :cell_style => {:size=>10, :borders => [:left, :right, :top, :bottom],  :inline_format => :true, :padding=>[3,5,3,2]}, :header => 2) do
      row(0).font_style=:bold
      column(5..6).style :align => :right
    end  
  end
  
  def footer
    draw_text "#{page_number} #{I18n.t('instructor_appraisal.from')} 1",  :size => 8, :at => [240,-5]
  end
  
end
