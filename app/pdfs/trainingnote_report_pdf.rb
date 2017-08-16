class Trainingnote_reportPdf < Prawn::Document
  def initialize(trainingnotes, trainingnotes2, view, curr_user)
    super({top_margin: 30,  bottom_margin: 35, page_size: 'A4', page_layout: :landscape })
    @trainingnotes = trainingnotes
    @trainingnotes2 = trainingnotes2
    @view = view
    @college=curr_user.college
    @curr_user=curr_user
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      if curr_user.userable_type=='Staff'
        footer
      end
    end
  end

  def record
    row_red=[]
    row_non_remove=[]
    row_count=2
    row_programmes=[]
    row_subjects=[]
    row_topics=[]
    @trainingnotes2.where('topicdetail_id is not null').group_by{|r|r.topicdetail.subject_topic.root}.sort.reverse.each do |prog, notes_byprog|
        row_programmes << row_count
        row_count+=1
        notes_byprog.sort_by{|u|u.topicdetail.subject_topic.parent.code}.group_by{|t|t.topicdetail.subject_topic.subject_of_topic_subtopic}.each do |subject, notes_bysubject|
            row_subjects << row_count
	    row_count+=1
	
	    notes_bysubject.sort_by{|u|u.topicdetail.subject_topic.code}.group_by{|u|u.topicdetail.subject_topic}.each do |topic, trainingnotes|
	        if trainingnotes.count > 1
	          row_topics << row_count
	          row_count+=1
		end
	        for note in trainingnotes
	            if note.topicdetail.topic_code
	                if note.timetable_id?
                            row_non_remove << row_count       #status='*'     #'Non-removable, but editable'
                        else
                            if note.lesson_plan_trainingnotes.count > 0
                                row_non_remove << row_count   #status='#'   #'Non-removable'
	                    else
			        #status=''#'OK'
	                    end
	                end
                    end 
	            row_count+=1
	        end
	    end

        end
    end
    
    topicdetail_not_exist_title=row_count
    
    for tnote in @trainingnotes2.where('topicdetail_id is null')
      row_count+=1
      row_red << row_count if tnote.topicdetail_id.blank? #&& !tnote.timetable_id.blank?
      row_non_remove << row_count if  tnote.lesson_plan_trainingnotes.count > 0  || !tnote.timetable_id.blank?
    end
    
    # [15,20,    70, 100, 100,   90, 70, 40, 50, 100, 100]
    table(line_item_rows, :column_widths => [15,20, 180, 100, 40, 60, 190, 150], :cell_style => { :size => 8,  :inline_format => :true}, :header => 2) do
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
      for row_programme in row_programmes
	row(row_programme).background_color = 'FFE34D'
	row(row_programme).borders=[:top, :left, :bottom, :right]
	row(row_programme).font_style =:bold
      end
      for row_subject in row_subjects
	row(row_subject).background_color='FDF8A1' #'FDD4EA'
	row(row_subject).borders=[:top, :left, :bottom, :right]
      end
      for row_topic in row_topics
	row(row_topic).background_color='FDFBD4' #'D4FDE5'
	row(row_topic).borders=[:top, :left, :bottom, :right]
      end
      row(topicdetail_not_exist_title).borders=[:top, :left, :bottom, :right]
      row(topicdetail_not_exist_title).background_color='E8E9E8'
      row(topicdetail_not_exist_title).text_color ='EC0C16'
      row(topicdetail_not_exist_title).font_style = :bold
      
      self.width=755
    end
  end

  def line_item_rows
    counter = counter || 0
    #I18n.t('training.trainingnote.programme'),I18n.t('training.trainingnote.subject'), I18n.t('training.trainingnote.topic_subtopic'),
    header = [[{content: "#{I18n.t('training.trainingnote.list').upcase}<br> #{@college.name.upcase}", colspan: 8}],
              [{content: 'No', colspan: 2}, I18n.t('training.trainingnote.title'), I18n.t('training.trainingnote.reference'), I18n.t('training.trainingnote.version'), I18n.t('training.trainingnote.release'), I18n.t('training.trainingnote.file_name'), I18n.t('training.trainingnote.staff_id') ]]
    body=[]

    @trainingnotes2.where('topicdetail_id is not null').group_by{|r|r.topicdetail.subject_topic.root}.sort.reverse.each do |prog, notes_byprog|
        body << [{content: prog.programme_list, colspan: 8}]
        notes_byprog.sort_by{|u|u.topicdetail.subject_topic.parent.code}.group_by{|t|t.topicdetail.subject_topic.subject_of_topic_subtopic}.each do |subject, notes_bysubject|
            body << [{content: subject.subject_list, colspan: 8}]
            notes_bysubject.sort_by{|u|u.topicdetail.subject_topic.code}.group_by{|u|u.topicdetail.subject_topic}.each do |topic, trainingnotes|
	        if trainingnotes.count > 1
                    body << [{content: "#{I18n.t('training.trainingnote.topic_subtopic').upcase}: #{topic.subject_list}", colspan: 8}]
		end
		for trainingnote in trainingnotes
                    if trainingnote.topicdetail.topic_code
		        if trainingnote.timetable_id?
                            status='*'#'Non-removable, but editable'
                        else
                            if trainingnote.lesson_plan_trainingnotes.count > 0
                                status='#'#'Non-removable'
	                    else
		                status=''#'OK'
	                    end
	                end
		    end 
		    programme=prog.programme_list
	            subject2=subject.subject_list 
	            topic2=topic.subject_list
	            ###---refer NOTE
	            if trainingnote.topicdetail_id==nil && trainingnote.timetable_id!=nil
	                topicdetail_status='**'#'Topic Detail not exist'
	            else
	                topicdetail_status=''
	            end
		    #programme, subject2, topic2,
	            body << [status,"#{counter += 1}", "#{trainingnote.title} #{topicdetail_status}", trainingnote.reference, trainingnote.version, trainingnote.release.try(:strftime, '%d-%m-%Y'), trainingnote.document_file_name, trainingnote.note_creator.rank_id? ? trainingnote.note_creator.staff_with_rank : trainingnote.note_creator.try(:name)]
		end
            end
        end
    end
   
    # TODO - to remove this part(below) when no longer required
    body << [{content: I18n.t('training.trainingnote.topicdetail_not_exist'), colspan: 8}]
    for tnote in @trainingnotes2.where('topicdetail_id is null')
	if tnote.timetable_id?
            status='*'#'Non-removable, but editable'
        else
            if tnote.lesson_plan_trainingnotes.count > 0
                 status='#'#'Non-removable'
            else
	         status=''#'OK'
            end
        end
        title_blank="#{tnote.title} <br>"
	if tnote.topicdetail_id.blank?
	    title_blank+="#{I18n.t('training.trainingnote.topicdetail_not_exist')}"
	    if  tnote.timetable_id!=nil
	      @topic=WeeklytimetableDetail.find(tnote.timetable_id).topic
	      title_blank+="<br>(#{I18n.t('training.trainingnote.topic')} : #{Programme.find(@topic).semester_subject_topic})"
	    end
	end
# 	if tnote.topicdetail_id.blank? && tnote.timetable_id!=nil
#              topicdetail_status=I18n.t('training.trainingnote.topicdetail_not_exist')
#         end
	#{content: topicdetail_status, colspan: 3},
	body << [status,"#{counter += 1}", title_blank, tnote.reference, tnote.version,  tnote.release.try(:strftime, '%d-%m-%Y'), tnote.document_file_name, tnote.note_creator.rank_id? ? tnote.note_creator.staff_with_rank : tnote.note_creator.try(:name)]
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