class Participantexpenses_listPdf < Prawn::Document
  def initialize(ptschedules, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :landscape })
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
    table(line_item_rows, :column_widths => [30, 110, 60, 120, 70, 50, 70, 70, 70, 60, 70], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      row(2..total_recs+2).column(4).align=:center
      row(2..total_recs+2).column(6).align=:right
      self.width=780
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('staff.training.schedule.participants_expenses').upcase}<br> #{@college.name.upcase}", colspan: 11}],
              [ 'No', I18n.t('staff.training.application_status.staff_name'),"#{I18n.t('staff.position')}",  I18n.t('staff.training.application_status.course_name'), "#{I18n.t('staff.training.schedule.start')}-#{I18n.t('staff.training.schedule.end')}", I18n.t('staff.training.schedule.duration'), I18n.t('staff.training.schedule.price'), I18n.t('staff.training.schedule.budget_ok'), I18n.t('staff.training.schedule.min_participants'), "#{I18n.t('staff.training.schedule.local_order')} / #{I18n.t('staff.training.schedule.cash')}", I18n.t('staff.training.schedule.remark')]]
    body =[]
    @ptschedules.each do |ptschedule| 
        ptdos = ptschedule.ptdos.where('trainee_report is not null')
        row_cnt=ptdos.count
        ptdos.each_with_index do |ptdo, indexx|
            counter+=1
            staff=ptdo.staff.staff_with_rank
            position=ptdo.staff.try(:positions).try(:first).try(:name)
            if indexx==0
                body << [counter, staff, position, {content: "#{ptschedule.course.name}", rowspan: row_cnt}, {content: "#{ptschedule.start.try(:strftime, '%d-%m-%Y')}  <br>#{I18n.t('to').downcase}<br> #{ptdo.ptschedule.enddate.try(:strftime, '%d-%m-%Y')}", rowspan: row_cnt}, {content: "#{ptschedule.course.course_total_days}", rowspan: row_cnt}, {content: "#{@view.ringgols(ptschedule.final_price)}", rowspan: row_cnt}, {content: "#{ ptschedule.budget_ok? ? (I18n.t('approved')) : (I18n.t('not_approved'))}", rowspan: row_cnt}, {content: "#{row_cnt >= ptschedule.min_participants ? (I18n.t('approved')) : (I18n.t('not_approved'))}<br>#{row_cnt} / #{ptschedule.min_participants} (#{ptschedule.max_participants})", rowspan: row_cnt}, {content: "#{ptschedule.render_payment}", rowspan: row_cnt}, {content: "#{ptschedule.remark}", rowspan: row_cnt}]
            else
                body << [counter, staff, position]
            end
        end
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [750,-5]
  end

end