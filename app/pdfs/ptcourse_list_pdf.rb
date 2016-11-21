class Ptcourse_listPdf < Prawn::Document
  def initialize(ptcourses, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @ptcourses = ptcourses
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
    table(line_item_rows, :column_widths => [30, 100, 70, 50, 70, 130, 70], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      column(1..2).align = :center
      self.width=520
    end
  end

  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('staff.training.course.title').upcase}<br> #{@college.name.upcase}", colspan: 7}],
              [ 'No', I18n.t('staff.training.course.name'), I18n.t('staff.training.course.provider'), I18n.t('staff.training.course.duration'), I18n.t('staff.training.course.cost'), I18n.t('staff.training.course.description'), I18n.t('staff.training.course.approval')]]
    header +
    @ptcourses.map do |course|
         ["#{counter += 1}", course.name, course.provider.try(:name), "#{@view.number_with_precision(course.duration, precision: 0)} #{@view.duration_type(course)}",  @view.ringgols(course.cost), course.description, "#{course.approved? ? I18n.t('approved') : I18n.t('not_approved')}"]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [470,-5]
  end

end