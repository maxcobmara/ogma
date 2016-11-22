class Ptschedule_listPdf < Prawn::Document
  def initialize(ptschedules, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @ptschedules = ptschedules
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
    total_recs=@ptschedules.count
    table(line_item_rows, :column_widths => [30, 60, 160, 65, 80, 70, 65], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      row(2..total_recs+1).column(5..6).align =:right
      self.width=530
    end
  end

  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('staff.training.schedule.title').upcase}<br> #{@college.name.upcase}", colspan: 7}],
              [ 'No', I18n.t('staff.training.schedule.start'),"#{I18n.t('staff.training.course.name')} - #{ I18n.t('staff.training.course.description')}",  I18n.t('staff.training.schedule.location'), I18n.t('staff.training.course.provider'), I18n.t('staff.training.schedule.max_participants'), I18n.t('staff.training.schedule.min_participants')]]
    header +
    @ptschedules.map do |ptschedule|
         ["#{counter += 1}", ptschedule.start.try(:strftime, '%d-%m-%Y'), "#{ptschedule.course.name} -  #{ptschedule.course.description}", ptschedule.location, ptschedule.course.provider.try(:name), ptschedule.max_participants, ptschedule.min_participants]
    end
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end