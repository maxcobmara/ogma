class Loanable_listPdf < Prawn::Document
  def initialize(loanables, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @loanables = loanables
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
    table(line_item_rows, :column_widths => [30, 130, 60, 60, 60, 60, 120], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
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
    counter = counter || 0
    header=[[{content: "#{I18n.t('asset.defect.list').upcase}<br> #{@college.name.upcase}", colspan: 7}],
            ["No", I18n.t('asset.assetcode'),  I18n.t('asset.category.title2'),  I18n.t('asset.name'),  I18n.t('asset.model'),  I18n.t('asset.serial_no'),  "#{I18n.t('asset.loan.loaned_by')} / #{ I18n.t('asset.loan.responsible_unit')}"]]
    header +
    @loanables.map do |loanable|
        ["#{counter+=1}", loanable.assetcode, loanable.category.description, loanable.name, loanable.modelname, loanable.serialno, "#{loanable.assignedto.try(:name)} / #{loanable.assignedto.try(:positions).first.try(:unit)}" ]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [720,-5]
  end

end