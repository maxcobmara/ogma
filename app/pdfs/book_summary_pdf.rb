class Book_summaryPdf < Prawn::Document
  def initialize(all_accessions, search, params_count, view, college)
    super({top_margin: 30, page_size: 'A4', page_layout: :portrait })
    @all_accessions = all_accessions
    @search=search
    @params_count=params_count
    @view = view
    @college=college
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def record
    table(line_item_rows, :column_widths => [30,80, 80, 80, 170, 90], :cell_style => { :size => 10,  :inline_format => :true}, :header => 3) do
      row(0..1).borders =[]
      row(0).height=40
      row(1).height=40
      row(0).style size: 12
      row(0).align = :center
      row(0..2).font_style = :bold
      row(2).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.width = 530
      header = true
    end
  end

  def line_item_rows
    title_row="#{I18n.t('library.book.total_books_titles')} : #{@all_accessions.count} / #{@all_accessions.group_by(&:book_id).count}"
    if Accession.all.count==@all_accessions.count
      title_row+="<br>#{I18n.t('library.book.book_summary_all')}"
    elsif !@search.accessionno_from.blank? && !@search.accessionno_to.blank? && @params_count==2
      #search by accession_no
      title_row+="<br>#{I18n.t('library.book.book_summary_accessionno')} (#{I18n.t('library.book.range')} : #{@search.accessionno_from} - #{@search.accessionno_to})"
    elsif !@search.classlcc_cont.blank? && @params_count==1
      #search by call no (NLM/LC)
      title_row+="<br>#{I18n.t('library.book.book_summary_classlcc')} <b><i>#{@search.classlcc_cont.upcase}</i></b>"
    end
    counter = counter || 0
    header = [[{content: "#{@college.upcase}<br>#{I18n.t('library.book.book_summary').upcase}", colspan: 6}], 
              [{content: title_row, colspan: 6}],
              [ 'No', I18n.t('library.book.accessionno'), I18n.t('library.book.classlcc'), I18n.t('library.book.author'), I18n.t('library.book.title'), I18n.t('library.book.isbn')]]
    header +
      @all_accessions.map do |acc|
        ["#{counter += 1}", acc.accession_no, acc.book.classlcc, acc.book.author, acc.book.title,  acc.book.isbn]
      end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end
  
end