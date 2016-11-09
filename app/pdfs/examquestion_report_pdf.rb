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
      record
    end
    #record
    
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
    count=2
    yo=page_number-1
    @programme_exams.each do |prog, examquestions|
      if @progg[page_number-1]==prog 
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

    table(line_item_rows, :column_widths => [25, 50, 230, 180, 40, 50, 70, 50, 60], :cell_style => { :size => 8,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'

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
    header = [[{content: "#{I18n.t('exam.examquestion.list').upcase}<br> #{@college.name.upcase}", colspan: 9}],
              [ 'No',  I18n.t('exam.examquestion.questiontype'),  I18n.t('exam.examquestion.question'), I18n.t('exam.examquestion.answer'), I18n.t('exam.examquestion.marks'), I18n.t('exam.examquestion.category'), I18n.t('exam.examquestion.difficulty'), I18n.t('exam.examquestion.qstatus'), I18n.t('exam.examquestion.creator_id'),]]
    body=[]
    yo2=page_number-1
    @programme_exams.each do |prog, examquestions|
      if @progg[page_number-1]==prog
        ###
        unless prog.blank?
          body << [ {content: "#{I18n.t('exam.examquestion.programme_id')} : #{Programme.find(prog).name}", colspan: 9}]
        end
        examquestions.group_by{|t|t.subject_details}.sort.each do |subject_details, examquestions| 
          body << [ {content: "#{I18n.t('exam.examquestion.subject_id')} : #{subject_details}", colspan: 7}, {content: "#{I18n.t('exam.examquestion.total_questions')} = #{examquestions.count.to_s}", colspan: 2}]
  
          #--------------------------------------------------------------------
          @groupbytopic=examquestions.group_by{|x|x.topic_id} 
          @groupbytopic.sort.each do |topic, allquestions|
              body << [ {content: "#{I18n.t('exam.examquestion.topic_id')} : #{Programme.find(topic).subject_list}", colspan: 5}, {content: "#{Programme.find(topic).parent.code.to_s} | #{topic.to_s}", colspan: 2}, {content: "#{I18n.t('exam.examquestion.total_questions')} = #{allquestions.count.to_s}", colspan: 2} ]

              questions=allquestions.group_by{|t|t.questiontype}
              questions.each do |questiontype,questionbytype|            
                  questionbytype.each do |question|
                      if question.question.include?('span')==false
                        qtext=question.question
                      else
                        #http://stackoverflow.com/questions/7414267/strip-html-from-string-ruby-on-rails
                        qtext=ActionView::Base.full_sanitizer.sanitize(question.question, :tags => %w(img br p span), :attributes => %w(src style))
                        qtext=qtext.gsub!("&nbsp;", " ")
                      end
                      body << ["#{counter+=1}", question.questiontype, qtext, question.answer, question.marks, question.category,   question.render_difficulty, question.qstatus, question.creator_details]
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
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [770,-5]
  end
  
  # [ 'No', I18n.t('exam.examquestion.subject_id'),  I18n.t('exam.examquestion.topic_id'),  I18n.t('exam.examquestion.questiontype'),  I18n.t('exam.examquestion.question'), I18n.t('exam.examquestion.answer'), I18n.t('exam.examquestion.marks'), I18n.t('exam.examquestion.category'), I18n.t('exam.examquestion.difficulty'), I18n.t('exam.examquestion.qstatus'), I18n.t('exam.examquestion.creator_id'),]
  
  #body << [ {content: "#{I18n.t('exam.examquestion.topic_id')} : #{Programme.find(topic).subject_list}", colspan: 7}, {content: "#{Programme.find(topic).parent.code.to_s} | #{topic.to_s}", colspan: 2}, {content: "#{I18n.t('exam.examquestion.total_questions')} = #{allquestions.count.to_s}", colspan: 2} ]
  
  #body << ["#{counter+=1}", subject_details, question.topic.name, question.questiontype, @view.simple_format(question.question), question.answer, question.marks, question.category, question.render_difficulty, question.qstatus, question.creator_details]

end