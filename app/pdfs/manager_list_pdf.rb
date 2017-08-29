class Manager_listPdf < Prawn::Document
  def initialize(mylate_attendances, myearly_attendances, approvelate_attendances, approveearly_attendances, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @mylate_attendances=mylate_attendances
    @myearly_attendances=myearly_attendances
    @approvelate_attendances=approvelate_attendances
    @approveearly_attendances=approveearly_attendances
    @view = view
    @college=college
    font "Helvetica"
    retrieve_record
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end

  def retrieve_record
    body=[]
    counter = 1
    rec_cnt=0
    arr=[]
    arr2=[]
    if @approvelate_attendances.size > 0
        counter+=1
        body << [{content: "#{I18n.t('attendance.late_to_approve')}", colspan: 8}]
	arr << counter
        @approvelate_attendances.each do |attendance|
	    counter+=1
	    arr2 << counter
            body << ["#{rec_cnt+=1}", attendance.logged_at.strftime('%d-%m-%Y'), "#{attendance.logged_at.strftime('%H:%M') if attendance.log_type.capitalize=='I'}", "#{attendance.logged_at.strftime('%H:%M') if attendance.log_type.capitalize=='O'}", attendance.try(:attended).try(:staff_with_rank), "#{attendance.reason? ? attendance.reason : I18n.t('staff_attendance.not_submitted_yet')}", "#{attendance.approver.try(:name) if attendance.is_approved == true}", "#{I18n.t('yes2') if attendance.is_approved == true} #{I18n.t('no2') if attendance.is_approved == false }"]
        end
    end
    if @approveearly_attendances.size > 0
        counter+=1
        body << [{content: "#{I18n.t('attendance.early_return_to_approve')}", colspan: 8}]
	arr << counter
        @approveearly_attendances.each do |attendance|
	    counter+=1
	    arr2 << counter
            body << ["#{rec_cnt+=1}", attendance.logged_at.strftime('%d-%m-%Y'), "#{attendance.logged_at.strftime('%H:%M') if attendance.log_type.capitalize=='I'}", "#{attendance.logged_at.strftime('%H:%M') if attendance.log_type.capitalize=='O'}", attendance.try(:attended).try(:staff_with_rank), "#{attendance.reason? ? attendance.reason : I18n.t('staff_attendance.not_submitted_yet')}", "#{attendance.approver.try(:name) if attendance.is_approved == true}", "#{I18n.t('yes2') if attendance.is_approved == true} #{I18n.t('no2') if attendance.is_approved == false }"]
        end
    end
    if @mylate_attendances.size > 0
        counter+=1
        body << [{content: "#{I18n.t('attendance.days_iam_late')}", colspan: 8}]
	arr << counter
        @mylate_attendances.each do |attendance|
	    counter+=1
	    arr2 << counter
            body << ["#{rec_cnt+=1}", attendance.logged_at.strftime('%d-%m-%Y'), "#{attendance.logged_at.strftime('%H:%M') if attendance.log_type.capitalize=='I'}", "#{attendance.logged_at.strftime('%H:%M') if attendance.log_type.capitalize=='O'}", attendance.try(:attended).try(:staff_with_rank), "#{attendance.reason? ? attendance.reason : I18n.t('staff_attendance.not_submitted_yet')}", "#{attendance.approver.try(:name) if attendance.is_approved == true}", "#{I18n.t('yes2') if attendance.is_approved == true} #{I18n.t('no2') if attendance.is_approved == false }"]
        end
    end
    if @myearly_attendances.size > 0
        counter+=1
        body << [{content: "#{I18n.t('attendance.days_iam_early')}", colspan: 8}]
	arr << counter
        @myearly_attendances.each do |attendance|
	    counter+=1
	    arr2 << counter
            body << ["#{rec_cnt+=1}", attendance.logged_at.strftime('%d-%m-%Y'), "#{attendance.logged_at.strftime('%H:%M') if attendance.log_type.capitalize=='I'}", "#{attendance.logged_at.strftime('%H:%M') if attendance.log_type.capitalize=='O'}", attendance.try(:attended).try(:staff_with_rank), "#{attendance.reason? ? attendance.reason : I18n.t('staff_attendance.not_submitted_yet')}", "#{attendance.approver.try(:name) if attendance.is_approved == true}", "#{I18n.t('yes2') if attendance.is_approved == true} #{I18n.t('no2') if attendance.is_approved == false }"]
        end
    end
    @body=body
    @title_rows=arr
    @data_rows=arr2
  end
  
  def record
    title_rows=@title_rows
    data_rows=@data_rows
    table(line_item_rows, :column_widths => [30, 70, 40, 40, 90, 85, 80, 85], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      row(2).align=:center
      for arow in title_rows
	row(arow).align=:center
	row(arow).font_style=:bold
	row(arow).background_color='FFE34D'
      end
      for arow in data_rows
	row(arow).columns(2..3).align=:center
	row(arow).columns(2..3).text_color ='EC0C16'
      end
      self.width = 520
    end
  end
  
  def line_item_rows
    body=@body
    header=[[{content: "#{I18n.t('attendance.title').upcase}<br> #{@college.name.upcase}", colspan: 8}],
            ["No", I18n.t('attendance.attdate'), I18n.t('attendance.time_in'), I18n.t('attendance.time_out'), I18n.t('attendance.staff_id'), I18n.t('attendance.reason'), I18n.t('attendance.approve_id'), I18n.t('attendance.approvestatus')]]
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [500,-5]
  end

end