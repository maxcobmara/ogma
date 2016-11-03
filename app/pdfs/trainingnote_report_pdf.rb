class Trainingnote_reportPdf < Prawn::Document
  def initialize(trainingnotes, view, college)
    super({top_margin: 50,  page_size: 'A4', page_layout: :landscape })
    @trainingnotes = trainingnotes
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
    row_count=1
    row_red=[]
    row_non_remove=[]
    @trainingnotes.each do |prog,x|
      if x
        x.each_with_index do |y, nos|
          row_count+=1 if y.topicdetail.topic_code 
          row_non_remove << nos+2 if  y.lesson_plan_trainingnotes.count > 0  || !y.timetable_id.blank?    #2 rows - header
        end
      else
        row_count+=1
        row_red << row_count if prog.topicdetail_id.blank? && !prog.timetable_id.blank?
        row_non_remove << row_count if  prog.lesson_plan_trainingnotes.count > 0  || !prog.timetable_id.blank?
      end
    end
 
    table(line_item_rows, :column_widths => [15,20, 70, 100, 100, 90, 70, 40, 50, 100, 100], :cell_style => { :size => 8,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      column(0).align =:center
      row(2..row_count).column(0).borders=[:top, :left, :bottom]
      row(2..row_count).column(1).borders=[:top, :right, :bottom]
      for item in row_red
        row(item).column(2).text_color ='EC0C16'
        row(item).column(2).font_style = :bold
      end
      for norem in row_non_remove
        row(norem).column(0).text_color ='EC0C16'
      end
    end
  end

  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('training.trainingnote.list').upcase}<br> #{@college.name.upcase}", colspan: 11}],
              [{content: 'No', colspan: 2}, I18n.t('training.trainingnote.programme'),I18n.t('training.trainingnote.subject'), I18n.t('training.trainingnote.topic_subtopic'), I18n.t('training.trainingnote.title'), I18n.t('training.trainingnote.reference'), I18n.t('training.trainingnote.version'), I18n.t('training.trainingnote.release'), I18n.t('training.trainingnote.file_name'), I18n.t('training.trainingnote.staff_id') ]]
    body=[]
    @trainingnotes.each do |prog,x|
      if x
        x.each_with_index do |y, nos|
          ###START---
          if y.topicdetail.topic_code
	     if y.timetable_id?
               status='*'#'Non-removable, but editable'
            else
              if y.lesson_plan_trainingnotes.count > 0
                status='#'#'Non-removable'
	      else
		status=''#'OK'
	      end
	     end
	     programme=Programme.find(y.topicdetail.topic_code).root.name
	     subject=Programme.find(y.topicdetail.topic_code).parent.subject_list 
	     topic=Programme.find(y.topicdetail.topic_code).name
	     ###---refer NOTE
	     if y.topicdetail_id==nil && y.timetable_id!=nil
	       topicdetail_status='**'#'Topic Detail not exist'
	     else
	       topicdetail_status=''
	     end
	     body << [status,"#{counter += 1}", programme, subject, topic, "#{y.title} #{topicdetail_status}", y.reference, y.version, y.release.try(:strftime, '%d-%m-%Y'), y.document_file_name, y.note_creator.rank_id? ? y.note_creator.staff_with_rank : y.note_creator.try(:name)]
	  end 
	  ###END---
	end

      else
        ##START
        #---NOTE - this part shall cater for existing Training Notes without Topic Detail - applied only to KSKBJB
        # as for AMSAS - latest codes updates -- New Training Note (Topic selection - filtered by Topic Detail record)
        # TODO - to remove this part when no longer required
        if prog.timetable_id?
          status='*'
        else
          if prog.lesson_plan_trainingnotes.count > 0
            status='#'#'Non-removable'
          else
            status=''#'OK'
          end
        end
        if prog.topicdetail_id.blank? && prog.timetable_id!=nil
          topicdetail_status=I18n.t('training.trainingnote.topicdetail_not_exist')
        else
          topicdetail_status=''
        end
        body <<  [status, "#{counter += 1}", {content: topicdetail_status, colspan: 3}, "#{prog.title} #{topicdetail_status}", prog.reference, prog.version, prog.release.try(:strftime, '%d %b %Y'), prog.document_file_name, prog.note_creator.rank_id? ? prog.note_creator.staff_with_rank : prog.note_creator.try(:name)]
        ###END---
      end
    end
    header+body
  end
  
  def footer
    draw_text "#{I18n.t('training.trainingnote.legend')}", :at => [0, 0], :size => 8
    draw_text "(1) ", :at => [40, 0], :size => 8
    fill_color "ECOC16"
    draw_text "*", :size => 8, :at => [55, 0]
    fill_color "000000"
    draw_text "#{I18n.t('training.trainingnote.plan_remark1')}", :size => 8, :at => [60, 0]

    draw_text "(2) ", :at => [40, -10], :size => 8
    fill_color "ECOC16"
    draw_text "#", :size => 8, :at => [55, -10]
    fill_color "000000"
    draw_text "#{I18n.t('training.trainingnote.plan_remark2')}", :size => 8, :at => [60, -10]
    
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [750,-5]
  end

end