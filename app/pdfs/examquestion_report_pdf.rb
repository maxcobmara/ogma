class Examquestion_reportPdf < Prawn::Document
  def initialize(examquestions, programme_exams, view, college)
    super({top_margin: 30, page_size: 'A4', page_layout: :landscape })
    @examquestions = examquestions
    @programme_exams = programme_exams
    @view = view
    @college=college
    font "Helvetica"
    @progg=[]
    @programme_exams.each{|prog, examquestions| @progg << prog}
    0.upto(@programme_exams.count-1) do |counting|
      start_new_page if counting > 0
      @ccc=counting
      record
    end
    
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end

  def record
    prog_line=[]
    subject_line=[]
    topic_line=[]
    question_line=[]
    count=3#2
    yo=page_number-1
    @programme_exams.each do |prog, examquestions|
      if @progg[@ccc]==prog
        unless prog.blank?
          prog_line << count
          count+=1
        end
        examquestions.group_by{|t|t.subject_details}.sort.each do |subject_details, examquestions| 
          subject_line << count
          count+=1
          #--------------------------------------------------------------------
          @groupbytopic=examquestions.group_by{|x|x.topic_id} 
          @groupbytopic.sort.each do |topic, allquestions|
              topic_line << count
              count+=1
              questions=allquestions.group_by{|t|t.questiontype}
              questions.each do |questiontype,questionbytype|            
                  questionbytype.each do |question|
                      question_line << count
                      count+=1
                  end
              end
          end #endof @groupbytopic.sort.each
          #--------------------------------------------------------------------
        end      
      end 
    end #endof @programme_exams.each

    table(line_item_rows, :column_widths => [25, 40, 230, 40, 50, 65, 50, 60, 20, 20, 20, 20, 20, 20, 20, 20, 20], :cell_style => { :size => 8,  :inline_format => :true}, :header => 3) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..2).font_style = :bold
      row(1..2).background_color = 'FFE34D'
      row(1).column(8).align =:center

      #programme lines
      for pline in prog_line
        row(pline).background_color='FDF8A1'
        row(pline).font_style = :bold
        row(pline).align = :center
      end
      
      #subject_lines
      for sline in subject_line
        row(sline).background_color='FDF8A1'#red for test - 'E18B8A'
        row(sline).font_style = :bold
        row(sline).align = :center
      end
      
      #topic lines
      for tline in topic_line
        row(tline).background_color='E1DD8A'
        row(tline).font_style = :bold
        row(tline).align = :center
      end
    end
  end
  
  def line_item_rows
    counter = counter || 0
    header = [[{content: "#{I18n.t('exam.examquestion.list').upcase}<br> #{@college.name.upcase}", colspan: 17}],
              [ {content: 'No', rowspan: 2}, {content: "#{I18n.t('exam.examquestion.questiontype')}", rowspan:2}, {content: "#{ I18n.t('exam.examquestion.question')} & #{I18n.t('exam.examquestion.answer')}", rowspan: 2}, {content: "#{I18n.t('exam.examquestion.marks')}", rowspan: 2} , {content: "#{I18n.t('exam.examquestion.category')}", rowspan: 2}, {content: "#{I18n.t('exam.examquestion.difficulty')}", rowspan: 2}, {content: "#{I18n.t('exam.examquestion.qstatus')}", rowspan: 2}, {content: "#{I18n.t('exam.examquestion.creator_id')}", rowspan: 2}, {content: "#{I18n.t('exam.examquestion.edit_details')} / #{I18n.t('exam.examquestion.quality_control')}", colspan: 9}], ["1", "2", "3", "4", "5", "6", "7", "8", "9"]]
    body=[]
    yo2=page_number-1
    @programme_exams.each do |prog, examquestions|
      if @progg[@ccc]==prog
        ###
        unless prog.blank?
          body << [ {content: "#{I18n.t('exam.examquestion.programme_id')} : #{Programme.find(prog).name}", colspan: 8}, {content: I18n.t('exam.examquestion.conformity'), colspan: 3, rowspan: 2}, {content: I18n.t('exam.examquestion.accuracy'), colspan: 3, rowspan: 2}, {content: I18n.t('exam.examquestion.fit'), colspan: 3, rowspan: 2}]
        end
        examquestions.group_by{|t|t.subject_details}.sort.each do |subject_details, examquestions| 
          body << [ {content: "#{I18n.t('exam.examquestion.subject_id')} : #{subject_details}", colspan: 5}, {content: "#{I18n.t('exam.examquestion.total_questions')} = #{examquestions.count.to_s}", colspan: 3}] ###
  
          #--------------------------------------------------------------------
          @groupbytopic=examquestions.group_by{|x|x.topic_id} 
          @groupbytopic.sort.each do |topic, allquestions|
              body << [ {content: "#{I18n.t('exam.examquestion.topic_id')} : #{Programme.find(topic).subject_list}", colspan: 3}, {content: "#{Programme.find(topic).parent.code.to_s} | #{topic.to_s}", colspan: 2}, {content: "#{I18n.t('exam.examquestion.total_questions')} = #{allquestions.count.to_s}", colspan: 3}, "1", "2", "3", "4", "5", "6", "7", "8", "9"] ###

              questions=allquestions.group_by{|t|t.questiontype}
              questions.each do |questiontype,questionbytype|            
                  questionbytype.each do |question|
                      #START - question
                      if question.question.include?('span')==false
                        qtext=question.question
                      else
                        qtext=@view.texteditor_content(question.question)
                      end

                      #START - answer===========================
		      qanswer=""
		      qanswer+="<br><b>#{I18n.t('exam.examquestion.answer')}</b>"
                      
                      #MCQ start
                      if question.questiontype=="MCQ"
                        qanswer+="<br>"
                        if question.answerchoices.count != 0 && question.answerchoices[0].description!=""
                          for answerchoice in question.answerchoices.sort_by{|x|x.item}
                            qanswer+="#{answerchoice.item}"
                            qanswer+=" #{answerchoice.description}<br>"
                          end  
                          qanswer+="<br>"
			end
                        for examanswer in question.examanswers.sort_by{|y|y.item}
                          qanswer+="#{examanswer.item}"
                          qanswer+=" #{examanswer.answer_desc}<br>"
			end
                      elsif question.questiontype=="SEQ" 
                        for shortessay in question.shortessays.sort_by{|x|x.item}	
                          qanswer+="<br>"
			  qanswer+="<u>#{I18n.t('exam.examquestion.subquestion')} #{shortessay.item} : </u><br>"
                          qanswer+="#{shortessay.subquestion} (#{shortessay.submark.to_s} #{I18n.t('exam.examquestion.marks')})<br>"
                          qanswer+="<u>#{I18n.t('exam.examquestion.keyword')} #{shortessay.item} :</u><br>"
                          qanswer+="#{shortessay.keyword}<br>"
                          qanswer+="<u>#{I18n.t('exam.examquestion.subanswer')} #{shortessay.item} :</u><br>"
			  ###-----------------
			  if shortessay.subanswer.include?('span')==false
			    subanswer=shortessay.subanswer
			  else
			    subanswer=@view.texteditor_content(shortessay.subanswer)
			  end
			  ###----------------
                          qanswer+="#{subanswer}"
			end
                      elsif question.questiontype=="TRUEFALSE"
			qanswer+="<br><u>#{I18n.t('exam.examquestion.booleanchoices')}</u><br>"
                        for booleanchoice in question.booleanchoices.sort_by{|x|x.item}
                          qanswer+="#{booleanchoice.item}. "
                          qanswer+="#{booleanchoice.description}<br>"
			end
                        qanswer+="<u>#{I18n.t( 'exam.examquestion.booleananswers')}</u><br>"
                        for booleananswer in question.booleananswers.sort_by{|y|y.item}
			  qanswer+="#{booleananswer.item}. "
                          qanswer+="#{I18n.t('exam.examquestion.true1') if booleananswer.answer==true}"
			  qanswer+="#{I18n.t('exam.examquestion.false1') if booleananswer.answer==false}"
                          qanswer+="<br>"
			end
                      end

                      #MCQ final ANSWER
                      if question.questiontype=="MCQ"
                        qanswer+="<u>#{I18n.t('exam.examquestion.answermcq')} : #{question.answer.to_s}</u>"
		      end
                      #answer field for other than MCQ & SEQ 
                      if !(question.questiontype=="MCQ" || question.questiontype=="SEQ")
                        qanswer+="<br>#{I18n.t('exam.examquestion.answer')} : #{question.answer  }"  
		      end
                      #END - answer=============================
		      
		      qtext+=qanswer
		      
		      unless question.questiontype=="SEQ"
                        qtext+="<br>"
                      end
		      qtext+="<br><b>#{I18n.t('exam.examquestion.usage_frequency')}:</b> #{Examquestion.joins(:exams).where(id: question.id).count}"

                      body << ["#{counter+=1}", question.questiontype, qtext, question.marks, question.category,   question.render_difficulty, question.qstatus, question.creator_details, "#{question.conform_curriculum? ? '/' : 'X'}", "#{question.conform_specification? ? '/' : 'X'}", "#{question.conform_opportunity? ? '/' : 'X'}", "#{question.accuracy_construct? ? '/' : 'X'}", "#{question.accuracy_topic? ? '/' : 'X'}", "#{question.accuracy_component? ? '/' : 'X'}", "#{question.fit_difficulty? ? '/' : 'X'}", "#{question.fit_important? ? '/' : 'X'}", "#{question.fit_fairness? ? '/' : 'X'}"]

                  end
              end
          end #endof @groupbytopic.sort.each
          #--------------------------------------------------------------------

        end    
      end
    end #endof @programme_exams.each
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [750,-5]
    draw_text "#{I18n.t('legend')} (#{I18n.t('exam.examquestion.edit_details')} / #{I18n.t('exam.examquestion.quality_control')}) : ", :size => 9, :at => [0, 5], :style => :bold
    draw_text "#{I18n.t('exam.examquestion.conformity').upcase}: 1-#{I18n.t('exam.examquestion.conform_curriculum')}, 2-#{I18n.t('exam.examquestion.conform_specification')}, 3-#{I18n.t('exam.examquestion.conform_opportunity')}  |  #{I18n.t('exam.examquestion.accuracy').upcase}: 4-#{I18n.t('exam.examquestion.accuracy_construct')}, 5-#{I18n.t('exam.examquestion.accuracy_topic')}, 6-#{I18n.t('exam.examquestion.accuracy_component')}  |  #{I18n.t('exam.examquestion.fit').upcase} : 7-#{ I18n.t('exam.examquestion.fit_difficulty')}, 8-#{ I18n.t('exam.examquestion.fit_important')}, 9-#{ I18n.t('exam.examquestion.fit_fairness')}", :size => 8, :at => [0, -5]
  end
  
  # [ 'No', I18n.t('exam.examquestion.subject_id'),  I18n.t('exam.examquestion.topic_id'),  I18n.t('exam.examquestion.questiontype'),  I18n.t('exam.examquestion.question'), I18n.t('exam.examquestion.answer'), I18n.t('exam.examquestion.marks'), I18n.t('exam.examquestion.category'), I18n.t('exam.examquestion.difficulty'), I18n.t('exam.examquestion.qstatus'), I18n.t('exam.examquestion.creator_id'),]
  
  #body << [ {content: "#{I18n.t('exam.examquestion.topic_id')} : #{Programme.find(topic).subject_list}", colspan: 7}, {content: "#{Programme.find(topic).parent.code.to_s} | #{topic.to_s}", colspan: 2}, {content: "#{I18n.t('exam.examquestion.total_questions')} = #{allquestions.count.to_s}", colspan: 2} ]
  
  #body << ["#{counter+=1}", subject_details, question.topic.name, question.questiontype, @view.simple_format(question.question), question.answer, question.marks, question.category, question.render_difficulty, question.qstatus, question.creator_details]

end