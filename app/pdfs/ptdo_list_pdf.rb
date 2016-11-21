class Ptdo_listPdf < Prawn::Document
  def initialize(ptdos, view, college)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @ptdos = ptdos
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
    table(line_item_rows, :column_widths => [30, 120, 120, 140, 100], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      self.width=510
    end
  end

  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('staff.training.application_status.training_request').upcase}<br> #{@college.name.upcase}", colspan: 5}],
              [ 'No', I18n.t('staff.training.application_status.schedule'),  I18n.t('staff.training.application_status.course_name'), I18n.t('staff.training.application_status.staff_name'), I18n.t('staff.training.application_status.status')]]
    body =[]
    @ptdos.each do |ptdo|
          if ptdo.applicant.positions.count > 0
            group="#{I18n.t('staff.training.application_status.group_by')} #{ptdo.ptschedule_id.to_s} (#{ptdo.ptschedule.start.try(:strftime, '%d %b %y')} )"
          else
            group="#{I18n.t('staff.training.application_status.group_by')} #{ptdo.ptschedule_id.to_s} (#{ptdo.ptschedule.start.try(:strftime, '%d %b %y')} )"
          end
         body << ["#{counter += 1}", group, ptdo.try(:ptschedule).try(:course).try(:name), ptdo.applicant_details, ptdo.apply_dept_status]
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [470,-5]
  end

end