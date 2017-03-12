class Evaluation_reportPdf < Prawn::Document
  def initialize(evaluate_courses, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @evaluate_courses = evaluate_courses
    @evaluate_courses_g=@evaluate_courses.group_by(&:subject_id)
    @view = view
    @college=college
    font "Helvetica"
    move_down 10
    text "#{college.name.upcase}", :align => :center, :size => 12, :style => :bold
    if @college.code=='amsas'
      title=(I18n.t 'exam.evaluate_course.title2')
    else
      title=(I18n.t 'exam.evaluate_course.title')
    end
    text title, :align => :center, :size => 12, :style => :bold
    record
  end
  
  def record
    heading_line=[0,1]
    empty_line=[]
    totallines=0
    @evaluate_courses_g.each do |subject, all_evaluate_courses|
      if @college.code=='amsas'
        aaa=all_evaluate_courses.group_by(&:visitor_id)
      else
        aaa=all_evaluate_courses.group_by(&:staff_id)
      end
      aaa.each do |staff, evaluate_courses|  #separate by lecturer
        if totallines==0
          totallines += 2+evaluate_courses.count+2
        else
          heading_line << totallines+1
          heading_line << totallines+2
          totallines+=2+evaluate_courses.count+2+1
        end
        empty_line << totallines
      end #separate by lecturer
    end
    table(line_item_rows, :column_widths => [30, 60, 108,33,33,33,33,33,33,33,33,33,45], :cell_style => {:size => 10,  :inline_format => :true}) do
      heading_line.each do |hl|
        row(hl).font_style =:bold
        row(hl).background_color = 'FFE34D'
      end
      empty_line.each do |el|
        row(el).borders=[:top, :bottom]
      end
      row(empty_line[empty_line.size-1]).borders=[:top]
      columns(3..12).align = :center
      self.width = 540
    end
  end
  
  def line_item_rows
    @sum_obj=[]
    @sum_knowledge=[]
    @sum_deliver=[]
    @sum_content=[]
    @sum_tool=[]
    @sum_topic=[]
    @sum_work=[]
    @sum_note=[]
    @sum_assessment=[]
    @eval_counts=[]
    @total_line=[]
    @acc_total_score=[]
    @avg_total_score=[]
    @evaluate_courses_g.each do |subject, all_evaluate_courses|
       if @college.code=='amsas'
        aaa=all_evaluate_courses.group_by(&:visitor_id)
      else
        aaa=all_evaluate_courses.group_by(&:staff_id)
      end
      aaa.each do |staff, evaluate_courses|   #separate by lecturer
          one=evaluate_courses.sum(&:ev_obj)
          two=evaluate_courses.sum(&:ev_knowledge)
          three=evaluate_courses.sum(&:ev_deliver)
          four=evaluate_courses.sum(&:ev_content)
          five=evaluate_courses.sum(&:ev_tool)
          six=evaluate_courses.sum(&:ev_topic)
          seven=evaluate_courses.sum(&:ev_work)
          eight=evaluate_courses.sum(&:ev_note)
          nine=evaluate_courses.sum(&:ev_assessment)
          total=one+two+three+four+five+six+seven+eight+nine
          @sum_obj << one
          @sum_knowledge << two
          @sum_deliver << three
          @sum_content << four
          @sum_tool << five
          @sum_topic << six
          @sum_work << seven
          @sum_note << eight
          @sum_assessment << nine
          @acc_total_score << total
          @avg_total_score << total.to_f / evaluate_courses.count
          @eval_counts << evaluate_courses.count
          evaluate_courses.each do |eline|
            @total_line << eline.ev_obj+eline.ev_knowledge+eline.ev_deliver+eline.ev_content+eline.ev_tool+eline.ev_topic+eline.ev_work+eline.ev_note+eline.ev_assessment
          end
      end #separate by lecturer
    end
    
    counter = counter || 0
    no=0
    eval_content = []
    
    @evaluate_courses_g.each do |subject_id, all_evaluate_courses|
        if @college.code=='amsas'
          aaa=all_evaluate_courses.group_by(&:visitor_id)
        else
          aaa=all_evaluate_courses.group_by(&:staff_id)
        end
        aaa.each do |staff_id, evaluate_courses|  #separate by lecturer
            eval_content << [{content: evaluate_courses.first.stucourse.programme_list , colspan: 5},{content: "#{subject_id.blank? ? evaluate_courses.first.invite_lec_topic : evaluate_courses.first.subjectevaluate.module_subject_list2}", colspan: 8} ]
            eval_content << [ 'No', "#{I18n.t('exam.evaluate_course.evaluate_date')}",  "#{I18n.t('exam.evaluate_course.staff_id')}", 	
                     "#{I18n.t('exam.evaluate_course.question')}1","#{I18n.t('exam.evaluate_course.question')}2","#{I18n.t('exam.evaluate_course.question')}3",
                     "#{I18n.t('exam.evaluate_course.question')}4","#{I18n.t('exam.evaluate_course.question')}5","#{I18n.t('exam.evaluate_course.question')}6",
                     "#{I18n.t('exam.evaluate_course.question')}7","#{I18n.t('exam.evaluate_course.question')}8","#{I18n.t('exam.evaluate_course.question')}9", "#{I18n.t('exam.evaluate_course.total')}"]
            evaluate_courses.each do |ec|
                if @college.code=='amsas'
                  lecturer_details=ec.visitor.visitor_with_title_rank
                else
                  lecturer_details=ec.staffevaluate.try(:staff_with_rank)  #"#{ec.staff_id.blank? ? ec.invite_lec : ec.staffevaluate.try(:staff_with_rank)}"
                end
                eval_content << ["#{counter += 1}","#{ec.evaluate_date.strftime('%d/%m/%Y')}<br><i><a href='http://#{@view.request.host}:3003/exam/evaluate_courses/#{ec.id}/courseevaluation.pdf?locale=ms_MY'> >#{I18n.t('view')}</a></i>",
                                              lecturer_details, ec.ev_obj, ec.ev_knowledge, ec.ev_deliver, ec.ev_content, ec.ev_tool, ec.ev_topic, ec.ev_work, ec.ev_note, ec.ev_assessment, @total_line[counter-1] ]
           end 
           eval_content << [{content: "#{I18n.t('exam.evaluate_course.total_scores')}", colspan: 3}, @sum_obj[no], @sum_knowledge[no],                       
                                      @sum_deliver[no], @sum_content[no], @sum_tool[no], @sum_topic[no], @sum_work[no], 
                                      @sum_note[no], @sum_assessment[no], @acc_total_score[no]]
           eval_content << [{content: "#{I18n.t('exam.evaluate_course.average_scores')}", colspan: 3},   
                                     "#{(@sum_obj[no].to_f/@eval_counts[no]).to_i if (@sum_obj[no].to_f/@eval_counts[no])%1==0} #{@view.pukka(@sum_obj[no].to_f/@eval_counts[no]) if (@sum_obj[no].to_f/@eval_counts[no]) % 1!=0}", "#{(@sum_knowledge[no].to_f/@eval_counts[no]).to_i if (@sum_knowledge[no].to_f/@eval_counts[no])%1==0} #{@view.pukka(@sum_knowledge[no].to_f/@eval_counts[no]) if (@sum_knowledge[no].to_f/@eval_counts[no]) % 1!=0}", "#{(@sum_deliver[no].to_f/@eval_counts[no]).to_i if (@sum_deliver[no].to_f/@eval_counts[no])%1==0} #{@view.pukka(@sum_deliver[no].to_f/@eval_counts[no]) if (@sum_deliver[no].to_f/@eval_counts[no]) % 1!=0}", "#{(@sum_content[no].to_f/@eval_counts[no]).to_i if (@sum_content[no].to_f/@eval_counts[no])%1==0} #{@view.pukka(@sum_content[no].to_f/@eval_counts[no]) if (@sum_content[no].to_f/@eval_counts[no]) % 1!=0}", "#{(@sum_tool[no].to_f/@eval_counts[no]).to_i if (@sum_tool[no].to_f/@eval_counts[no])%1==0} #{@view.pukka(@sum_tool[no].to_f/@eval_counts[no]) if (@sum_tool[no].to_f/@eval_counts[no]) % 1!=0}", "#{(@sum_topic[no].to_f/@eval_counts[no]).to_i if (@sum_topic[no].to_f/@eval_counts[no])%1==0} #{@view.pukka(@sum_topic[no].to_f/@eval_counts[no]) if (@sum_topic[no].to_f/@eval_counts[no]) % 1!=0}", "#{(@sum_work[no].to_f/@eval_counts[no]).to_i if (@sum_work[no].to_f/@eval_counts[no])%1==0} #{@view.pukka(@sum_work[no].to_f/@eval_counts[no]) if (@sum_work[no].to_f/@eval_counts[no]) % 1!=0}", "#{(@sum_note[no].to_f/@eval_counts[no]).to_i if (@sum_note[no].to_f/@eval_counts[no])%1==0} #{@view.pukka(@sum_note[no].to_f/@eval_counts[no]) if (@sum_note[no].to_f/@eval_counts[no]) % 1!=0}", "#{(@sum_assessment[no].to_f/@eval_counts[no]).to_i if (@sum_assessment[no].to_f/@eval_counts[no])%1==0} #{@view.pukka(@sum_assessment[no].to_f/@eval_counts[no]) if (@sum_assessment[no].to_f/@eval_counts[no]) % 1!=0}", "#{@avg_total_score[no].to_i if @avg_total_score[no]%1==0}#{@view.pukka(@avg_total_score[no]) if @avg_total_score[no] % 1!=0}"]

	   if @college.code=='amsas'
             @average_course_rec=AverageCourse.where(subject_id: subject_id, visitor_id: staff_id)
	   else
	     @average_course_rec=AverageCourse.where(subject_id: subject_id, lecturer_id: staff_id) 
	   end
           if @average_course_rec.count > 0
               if @college.code=='amsas'
                 lecturer_details2=evaluate_courses.first.visitor.visitor_with_title_rank
               else
                 lecturer_details2=evaluate_courses.first.staffevaluate.try(:staff_with_rank)
	       end
               eval_content << [{content: "<i><a href='http://#{@view.request.host}:3003/exam/average_courses/#{@average_course_rec.first.id }/evaluation_analysis.pdf?locale=ms_MY'><b>#{I18n.t('exam.average_course.view_analysis_data')}</b> #{I18n.t('for')}: <b>#{lecturer_details2}</b>, #{I18n.t('exam.average_course.of_subject')}: <b>#{evaluate_courses.first.subjectevaluate.subject_list unless evaluate_courses.first.subject_id.blank? }#{evaluate_courses.first.invite_lec_topic if evaluate_courses.first.subject_id.blank? }.</b></a><br> #{I18n.t('exam.average_course.score_rounded')}</i>", colspan: 11},"","#{}"]
           else
             if @college.code=='amsas'
               # NOTE - Analysis not yet done - go to index to analyse!
	       eval_content <<  [{content: "", colspan:11}] 
             else
               if evaluate_courses.first.invite_lec!=""
                 eval_content << [{content: "<i>(#{I18n.t('exam.evaluate_course.invite_lec')})</i>", colspan:11}] 
               else
                 eval_content <<  [{content: "", colspan:11}] 
               end
             end
           end
           no+=1
        end #separate by lecturer
      end
      eval_content
    end

    ##
#     @view.pukka(@sum_knowledge[no].to_f/@eval_counts[no]), @view.pukka(@sum_deliver[no].to_f/@eval_counts[no]),
#                                      @view.pukka(@sum_content[no].to_f/@eval_counts[no]), @view.pukka(@sum_tool[no].to_f/@eval_counts[no]), @view.pukka(@sum_topic[no].to_f/@eval_counts[no]), @view.pukka(@sum_work[no].to_f/@eval_counts[no]), @view.pukka(@sum_note[no].to_f/@eval_counts[no]), @view.pukka(@sum_assessment[no].to_f/@eval_counts[no]),
end