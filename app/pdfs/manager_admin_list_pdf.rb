class Manager_admin_listPdf < Prawn::Document
  def initialize(late_early_recs, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @late_early_recs = late_early_recs
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
    total_records=@late_early_recs.count
    table(line_item_rows, :column_widths => [30, 60, 40, 40, 80, 75, 70, 75, 50], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      row(2..total_records+2).columns(2..3).align=:center
      row(2..total_records+2).column(2..3).text_color ='EC0C16'
      self.width = 520
    end
  end
  
  def line_item_rows
    counter = counter||0
    header=[[{content: "#{I18n.t('attendance.title2').upcase}<br> #{@college.name.upcase}", colspan: 9}],
            ["No", I18n.t('attendance.attdate'), I18n.t('attendance.time_in'), I18n.t('attendance.time_out'), I18n.t('attendance.staff_id'), I18n.t('staff_attendance.unit_department'), I18n.t('attendance.reason'), I18n.t('attendance.approve_id'), I18n.t('attendance.approvestatus')]]
    body=[]
    if @late_early_recs.size > 0
        @late_early_recs.each do |attendance|
            body << ["#{counter+=1}", attendance.logged_at.strftime('%d-%m-%Y'), "#{attendance.logged_at.strftime('%H:%M') if attendance.log_type.capitalize=='I'}", "#{attendance.logged_at.strftime('%H:%M') if attendance.log_type.capitalize=='O'}", attendance.try(:attended).try(:staff_with_rank), StaffAttendance.unit_for_thumb(attendance.thumb_id), "#{attendance.reason? ? attendance.reason : I18n.t('staff_attendance.not_submitted_yet')}", "#{attendance.approver.try(:name) if attendance.is_approved == true}", "#{I18n.t('yes2') if attendance.is_approved == true} #{I18n.t('no2') if attendance.is_approved == false }"]
        end
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end