class Personalize_reportPdf < Prawn::Document
  def initialize(personalize, view, college, userable_id)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @personalize= personalize
    @view = view
    @college=college
    @userable_id=userable_id
    font "Helvetica"
    record
  end
  
  def record
    table(line_item_rows, :column_widths => [30, 140, 60, 65, 65, 400], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0..1).style size: 11
      row(0).align = :center
      row(0..2).font_style = :bold
      row(2).background_color = 'FFE34D'
      row(1).borders=[]
      header = true
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('training.weeklytimetable.personalize_timetable_list').upcase}<br> #{@college.name.upcase}", colspan: 6}],
              [{content: "#{I18n.t('training.weeklytimetable_detail.lecturer_id')} :  #{Staff.find(@userable_id).staff_with_rank}", colspan: 6}],
              [ 'No', I18n.t('training.weeklytimetable.programme_id'), I18n.t('training.weeklytimetable.startdate'), I18n.t('training.weeklytimetable.enddate'), "Status", I18n.t('training.weeklytimetable.date_day_time_topic_method')]]
    body=[]
    @personalize.each do |sdate, items2|
      combined_wt=""
      combined_slot=""
      combined_status=""
         
      items2.map(&:id).uniq.each do |x|
        combined_wt+=Weeklytimetable.find(x).schedule_programme.programme_list+"<br>"
        slots=Weeklytimetable.find(x).weeklytimetable_details.where(lecturer_id: @userable_id)
        slots.each do |slot|
	  if @college.code=='amsas'
            combined_slot+=slot.get_date_day_of_schedule+' ('+slot.get_time_slot+') - '+slot.weeklytimetable_subject.subject_list+' ('+slot.render_class_method.first+') <br>'
	  else
	    combined_slot+=slot.get_date_day_of_schedule+' ('+slot.get_time_slot+') - '+slot.weeklytimetable_topic.subject_list+' ('+slot.render_class_method.first+') <br>'
	  end
        end
        combined_status+="#{Weeklytimetable.find(x).hod_approved? ? I18n.t('approved')+'<br>' : I18n.t('not_approved')+'<br>'}"

        combined_wt+="<br>"
        combined_slot+="<br>"
        combined_status+="<br>"
      end

      items2.each_with_index do |item, index|
        if index==items2.count-1
          body << ["#{counter+=1}", combined_wt, sdate.try(:strftime, "%d-%m-%Y"), item.try(:enddate).try(:strftime, "%d-%m-%Y"), "#{combined_status}", "#{combined_slot}"]
        end
      end
     end
     header+body
  end
end