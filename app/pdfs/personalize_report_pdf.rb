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
    table(line_item_rows, :column_widths => [30, 200, 60, 70, 400], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
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
    header = [[{content: "#{I18n.t('training.weeklytimetable.personalize_timetable_list').upcase}<br> #{@college.name.upcase}", colspan: 5}],
              [{content: "#{I18n.t('training.weeklytimetable_detail.lecturer_id')} :  #{Staff.find(@userable_id).staff_with_rank}", colspan: 5}],
              [ 'No', I18n.t('training.weeklytimetable.programme_id'), I18n.t('training.weeklytimetable.startdate'), I18n.t('training.weeklytimetable.enddate'), I18n.t('training.weeklytimetable.date_day_time_topic_method')]]
    body=[]
    aa=""
    @personalize.each do |sdate, items2|
      bb=""
      items2.each_with_index do |item, index|
        if index==0
          aa=item.weeklytimetable_details.where(lecturer_id: @userable_id)
          aa.each{|x|bb+=x.get_date_day_of_schedule+' ('+x.get_time_slot+') - '+x.weeklytimetable_topic.subject_list+' ('+x.render_class_method.first+') <br>'}
          body << ["#{counter+=1}", item.schedule_programme.programme_list, sdate.try(:strftime, "%d-%m-%Y"), item.try(:enddate).try(:strftime, "%d-%m-%Y"), "#{bb}"]
        end
      end
     end
     header+body
  end
end