class Cofile_listPdf < Prawn::Document
  def initialize(cofiles, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @cofiles = cofiles
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
    table(line_item_rows, :column_widths => [30, 80, 130, 60, 80, 80, 60], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width = 520
    end
  end

  def line_item_rows
    counter = counter||0
    header=[[{content: "#{I18n.t('cofile.index').upcase}<br> #{@college.name.upcase}", colspan: 7}],
            ["No", I18n.t('cofile.cofileno'), I18n.t('cofile.name'), I18n.t('cofile.location'), I18n.t('cofile.owner'), I18n.t('cofile.onloan_to'), I18n.t('cofile.onloandt') ]]
    header +
    @cofiles.map do |cofile|
        ["#{counter+=1}", cofile.cofileno, cofile.name, cofile.location, "#{@college.code=='amsas' ? cofile.owner.staff_with_rank : cofile.owner.mykad_with_staff_name}", "#{@college.code=='amsas' ? cofile.try(:borrower).try(:staff_with_rank) : cofile.try(:borrower).try(:mykad_with_staff_name)}", "#{cofile.onloan? ? cofile.onloandt.try(:strftime, '%d-%m-%Y') : ''}"]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end