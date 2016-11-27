class Staffappraisal_listPdf < Prawn::Document
  def initialize(staff_appraisals, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @staff_appraisals = staff_appraisals
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
    table(line_item_rows, :column_widths => [30, 80, 150, 100, 60, 110], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width=530
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('staff.staff_appraisal.title').upcase}<br> #{@college.name.upcase}", colspan: 6}],
              [ 'No',I18n.t('staff.icno'), I18n.t('staff.name'), I18n.t('staff.position'), I18n.t('helpers.label.staff_appraisal.evaluation_year'), 'Status']]
    header +
    @staff_appraisals.map do |appraised|
         ["#{counter += 1}", appraised.appraised.try(:formatted_mykad), appraised.appraised.try(:name), appraised.appraised.try(:position_for_staff), appraised.evaluation_year.try(:strftime,'%Y'), appraised.evaluation_status]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end