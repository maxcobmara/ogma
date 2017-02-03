class CourseevaluationPdf < Prawn::Document  
  def initialize(evaluate_course, view, evs, college)
    super({top_margin: 30, page_size: 'A4', page_layout: :portrait })
    @evaluate_course  = evaluate_course
    @view = view
    @evs = evs
    @college=college
    font "Helvetica"
    if college.code=="kskbjb"
      move_down 10
    end
    bounding_box([10,770], :width => 400, :height => 100) do |y2|
       if college.code=="kskbjb"
         image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
       else
         image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :scale => 0.7
       end
    end
    bounding_box([150,770], :width => 350, :height => 100) do |y2|
      if college.code=="kskbjb"
        move_down 30
        text "#{college.name}"
        move_down 1
        text "#{I18n.t('exam.evaluate_course.title')}"
      else
        draw_text "PPL APMM", :at => [80, 85], :style => :bold
        #draw_text "NO.DOKUMEN: BK-KKM-KS-04-04", :at => [15, 60], :style => :bold
	draw_text "NO.DOKUMEN: BK-KKM-04-03", :at => [35, 60], :style => :bold
        draw_text "BORANG PENILAIAN PENSYARAH", :at => [20, 45], :style => :bold
      end
    end
    
    if college.code=="kskbjb"
      bounding_box([400,770], :width => 400, :height => 100) do |y2|
        image "#{Rails.root}/app/assets/images/kskb_logo-6.png",  :width =>97.2, :height =>77.76
      end
    else
      bounding_box([430,770], :width => 400, :height => 90) do |y2|
        image "#{Rails.root}/app/assets/images/amsas_logo_small.png", :scale => 0.8
      end
    end
    
    #move_down 5
#     if college.code=="amsas"
#       table_heading
#       move_down 10
#     end
    text "#{I18n.t('exam.evaluate_course.by_student')}", :align => :center, :size => 10
    if college.code=="kskbjb"
      move_down 20
    else
      move_down 5
    end
    table_detailing
    if college.code=="kskbjb"
      move_down 20
    else
      bounding_box([50,570], :width => 410, :height => 80) do |y2|
        image "#{Rails.root}/app/assets/images/skala.png", :width => 430
      end
    end
    table_score
    #move_down 10
    #text " #{I18n.t('exam.evaluate_course.comment')}", :size => 10, :style => :bold
    #move_down 10
    table_comment
    #move_down 20
    table_current_date
    if college.code=='amsas'
      move_down 20
      table_ending
    end
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def table_heading
    data=[["#{I18n.t('exam.evaluate_course.prepared_by')} : #{@evaluate_course.student_id? ? @evaluate_course.studentevaluate.student_with_rank : '' }","#{I18n.t('exam.evaluate_course.date_updated')} : #{@evaluate_course.updated_at.try(:strftime, '%d %b %Y')} "]]
    table(data, :column_widths => [255,255], :cell_style => {:size=>10, :borders => [:left, :right, :top, :bottom]}) do
      a = 0
      b = 1
      column(0).font_style = :bold
      column(1).font_style = :bold
      while a < b do
        a=+1
      end
    end
  end
  
  def table_detailing
    if @college.code=='amsas' 
      a=I18n.t('exam.evaluate_course.subject_id2')
      b=I18n.t('exam.evaluate_course.staff_id2')
    else
      a=I18n.t('exam.evaluate_course.subject_id')
      b=I18n.t('exam.evaluate_course.staff_id2')
    end
    data=[["#{@college.code=='amsas' ? I18n.t('exam.evaluate_course.course_id2') : I18n.t('exam.evaluate_course.course_id')} :","#{@evaluate_course.stucourse.programme_list}","",""],
          ["#{a unless @evaluate_course.subject_id.blank? } #{I18n.t('exam.evaluate_course.invite_lec_topic') unless @evaluate_course.invite_lec.blank?} :","#{@evaluate_course.subjectevaluate.subject_list unless @evaluate_course.subject_id.blank?} #{@evaluate_course.invite_lec_topic unless @evaluate_course.invite_lec.blank?}","#{I18n.t('exam.evaluate_course.evaluate_date2')} : ","#{@evaluate_course.evaluate_date.try(:strftime, '%d/%m/%Y')}"],
          ["#{b unless @evaluate_course.staff_id.blank?} #{I18n.t('exam.evaluate_course.invite_lec') unless @evaluate_course.invite_lec.blank?} : ","#{@evaluate_course.staff_id? ? @evaluate_course.staffevaluate.try(:staff_with_rank) : @evaluate_course.invite_lec}","",""]]
    table(data, :column_widths => [150, 210, 70, 90], :cell_style => { :size => 10})  do
              a = 0
              b = 3
	      row(0).column(0).borders = [:top, :left]
	      row(0).column(1).borders = [:top]
	      row(0).column(2).borders = [:top]
	      row(0).column(3).borders = [:top, :right]
	      row(1).column(0).borders = [:left]
	      row(1).column(1).borders = []
	      row(1).column(2).borders = []
	      row(1).column(3).borders = [:right]
	      row(2).column(0).borders = [:bottom, :left]
	      row(2).column(1).borders = [:bottom]
	      row(2).column(2).borders = [:bottom]
	      row(2).column(3).borders = [:bottom, :right]
	      row(1).column(2).align = :right
              column(0).font_style = :bold
              column(2).font_style = :bold
              while a < b do
                a += 1
            end
    end
  end
  
   def table_score
       data=[["No","#{I18n.t('exam.evaluate_course.description')}",{content: "#{I18n.t('exam.evaluate_course.score')}", colspan: 9}],
             ["1.","#{I18n.t('exam.evaluate_course.objective_achieved')}", "#{@evs[0]==1? '<b>'+@evs[0].to_s+'</b>' : ""}","#{@evs[0]==2? '<b>'+@evs[0].to_s+'</b>' : ""}", "#{@evs[0]==3? '<b>'+@evs[0].to_s+'</b>' : ""}", "#{@evs[0]==4? '<b>'+@evs[0].to_s+'</b>' : ""}","#{@evs[0]==5? '<b>'+@evs[0].to_s+'</b>' : ""}", "#{@evs[0]==6? '<b>'+@evs[0].to_s+'</b>' : ""}","#{@evs[0]==7? '<b>'+@evs[0].to_s+'</b>' : ""}" ,"#{@evs[0]==8? '<b>'+@evs[0].to_s+'</b>' : ""}", "#{@evs[0]==9? '<b>'+@evs[0].to_s+'</b>' : ""}"],
             ["2.","#{I18n.t('exam.evaluate_course.lecturer_knowledge')}", "#{@evs[1]==1? '<b>'+@evs[1].to_s+'</b>' : ""}","#{@evs[1]==2? '<b>'+@evs[1].to_s+'</b>' : ""}", "#{@evs[1]==3? '<b>'+@evs[1].to_s+'</b>' : ""}", "#{@evs[1]==4? '<b>'+@evs[1].to_s+'</b>' : ""}","#{@evs[1]==5? '<b>'+@evs[1].to_s+'</b>' : ""}", "#{@evs[1]==6? '<b>'+@evs[1].to_s+'</b>' : ""}","#{@evs[1]==7? '<b>'+@evs[1].to_s+'</b>' : ""}" ,"#{@evs[1]==8? '<b>'+@evs[1].to_s+'</b>' : ""}", "#{@evs[1]==9? '<b>'+@evs[1].to_s+'</b>' : ""}"],
             ["3.","#{I18n.t('exam.evaluate_course.lecturer_q_achievement')}", "#{@evs[2]==1?  '<b>'+@evs[2].to_s+'</b>' : ""}","#{@evs[2]==2? '<b>'+@evs[2].to_s+'</b>' : ""}", "#{@evs[2]==3? '<b>'+@evs[2].to_s+'</b>' : ""}", "#{@evs[2]==4? '<b>'+@evs[2].to_s+'</b>' : ""}","#{@evs[2]==5? '<b>'+@evs[2].to_s+'</b>' : ""}", "#{@evs[2]==6? '<b>'+@evs[2].to_s+'</b>' : ""}","#{@evs[2]==7? '<b>'+@evs[2].to_s+'</b>' : ""}" ,"#{@evs[2]==8? '<b>'+@evs[2].to_s+'</b>' : ""}", "#{@evs[2]==9? '<b>'+@evs[2].to_s+'</b>' : ""}"],
             ["4.","#{I18n.t('exam.evaluate_course.content')}", "#{@evs[3]==1? '<b>'+@evs[3].to_s+'</b>' : ""}","#{@evs[3]==2? '<b>'+@evs[3].to_s+'</b>' : ""}", "#{@evs[3]==3? '<b>'+@evs[3].to_s+'</b>' : ""}", "#{@evs[3]==4? '<b>'+@evs[3].to_s+'</b>' : ""}","#{@evs[3]==5? '<b>'+@evs[3].to_s+'</b>' : ""}", "#{@evs[3]==6? '<b>'+@evs[3].to_s+'</b>' : ""}","#{@evs[3]==7? '<b>'+@evs[3].to_s+'</b>' : ""}" ,"#{@evs[3]==8? '<b>'+@evs[3].to_s+'</b>' : ""}", "#{@evs[3]==9? '<b>'+@evs[3].to_s+'</b>' : ""}"],
             ["5.","#{I18n.t('exam.evaluate_course.training_aids_quality')}", "#{@evs[4]==1? '<b>'+@evs[4].to_s+'</b>' : ""}","#{@evs[4]==2? '<b>'+@evs[4].to_s+'</b>' : ""}", "#{@evs[4]==3? '<b>'+@evs[4].to_s+'</b>' : ""}", "#{@evs[4]==4? '<b>'+@evs[4].to_s+'</b>' : ""}","#{@evs[4]==5? '<b>'+@evs[4].to_s+'</b>' : ""}", "#{@evs[4]==6? '<b>'+@evs[4].to_s+'</b>' : ""}","#{@evs[4]==7? '<b>'+@evs[4].to_s+'</b>' : ""}" ,"#{@evs[4]==8? '<b>'+@evs[4].to_s+'</b>' : ""}", "#{@evs[4]==9? '<b>'+@evs[4].to_s+'</b>' : ""}"],
             ["6.","#{I18n.t('exam.evaluate_course.suitability_topic_sequence')}", "#{@evs[5]==1? '<b>'+@evs[5].to_s+'</b>' : ""}","#{@evs[5]==2? '<b>'+@evs[5].to_s+'</b>' : ""}", "#{@evs[5]==3? '<b>'+@evs[5].to_s+'</b>' : ""}", "#{@evs[5]==4? '<b>'+@evs[5].to_s+'</b>' : ""}","#{@evs[5]==5? '<b>'+@evs[5].to_s+'</b>' : ""}", "#{@evs[5]==6? '<b>'+@evs[5].to_s+'</b>' : ""}","#{@evs[5]==7? '<b>'+@evs[5].to_s+'</b>' : ""}" ,"#{@evs[5]==8? '<b>'+@evs[5].to_s+'</b>' : ""}", "#{@evs[5]==9? '<b>'+@evs[5].to_s+'</b>' : ""}"],
             ["7.","#{I18n.t('exam.evaluate_course.effectiveness_teaching_learning')}", "#{@evs[6]==1? '<b>'+@evs[6].to_s+'</b>' : ""}","#{@evs[6]==2? '<b>'+@evs[6].to_s+'</b>' : ""}", "#{@evs[6]==3? '<b>'+@evs[6].to_s+'</b>' : ""}", "#{@evs[6]==4? '<b>'+@evs[6].to_s+'</b>' : ""}","#{@evs[6]==5? '<b>'+@evs[6].to_s+'</b>' : ""}", "#{@evs[6]==6? '<b>'+@evs[6].to_s+'</b>' : ""}","#{@evs[6]==7? '<b>'+@evs[6].to_s+'</b>' : ""}" ,"#{@evs[6]==8? '<b>'+@evs[6].to_s+'</b>' : ""}", "#{@evs[6]==9? '<b>'+@evs[6].to_s+'</b>' : ""}"],
             ["8.","#{I18n.t('exam.evaluate_course.benefit_notes')}","#{@evs[7]==1? '<b>'+@evs[7].to_s+'</b>' : ""}","#{@evs[7]==2? '<b>'+@evs[7].to_s+'</b>' : ""}", "#{@evs[7]==3? '<b>'+@evs[7].to_s+'</b>' : ""}", "#{@evs[7]==4? '<b>'+@evs[7].to_s+'</b>' : ""}","#{@evs[7]==5? '<b>'+@evs[7].to_s+'</b>' : ""}", "#{@evs[7]==6? '<b>'+@evs[7].to_s+'</b>' : ""}","#{@evs[7]==7? '<b>'+@evs[7].to_s+'</b>' : ""}" ,"#{@evs[7]==8? '<b>'+@evs[7].to_s+'</b>' : ""}", "#{@evs[7]==9? '<b>'+@evs[7].to_s+'</b>' : ""}"],
             ["9.","#{I18n.t('exam.evaluate_course.suitable_assessment')}","#{@evs[8]==1? '<b>'+@evs[8].to_s+'</b>' : ""}","#{@evs[8]==2? '<b>'+@evs[8].to_s+'</b>' : ""}", "#{@evs[8]==3? '<b>'+@evs[8].to_s+'</b>' : ""}", "#{@evs[8]==4? '<b>'+@evs[8].to_s+'</b>' : ""}","#{@evs[8]==5? '<b>'+@evs[8].to_s+'</b>' : ""}", "#{@evs[8]==6? '<b>'+@evs[8].to_s+'</b>' : ""}","#{@evs[8]==7? '<b>'+@evs[8].to_s+'</b>' : ""}" ,"#{@evs[8]==8? '<b>'+@evs[8].to_s+'</b>' : ""}", "#{@evs[8]==9? '<b>'+@evs[8].to_s+'</b>' : ""}"]
             ] 
     
       table(data, :column_widths => [30, 340, 15, 15,15,15,15,15,15,15,20], :cell_style=>{:size=>10, :borders=>[:left, :right, :top, :bottom], :inline_format => :true}) do
         a=0
         b=9
         rows(0).font_style = :bold
         #columns(2..11).font_style = :bold
         rows(0).background_color = 'ABA9A9'
         #cells[1,10].font_style = :bold
         while a < b do
           a+=1  
         end
       end
       
  end
  
  def table_comment
    data=[["#{I18n.t('exam.evaluate_course.comment').upcase}"],["#{@evaluate_course.comment.blank? ? '_______________________________________________________________________________________<br> _______________________________________________________________________________________<br> _______________________________________________________________________________________' : '<u>'+@evaluate_course.comment+'</u>'}"]]
    table(data, :column_widths => [510],:cell_style => {:inline_format => :true, :size=>10, :borders => [], :padding => [7,0,0,20]}) do
      a = 0
      b = 1
      column(0).font_style = :bold
      row(1).height = 90
      while a < b do
        a=+1
      end
    end
  end
  
  def table_current_date
    data=[ ["#{I18n.t('exam.evaluate_course.student_verification').upcase}:", ""],
           ["#{I18n.t('exam.evaluate_course.signatory')}: ____________________________________________", ""],
           ["#{I18n.t('exam.evaluate_course.full_name')}: #{@evaluate_course.student_id? ? '<u>'+@evaluate_course.studentevaluate.student_with_rank+'</u>' : '____________________________________________'}", ""],
           ["#{I18n.t('exam.evaluate_course.mykad_no')}: ________________________________________", "#{I18n.t('exam.evaluate_course.evaluate_date2')} : <u>#{Date.today.try(:strftime, '%d %b %Y')}</u>"]]
    table(data, :column_widths => [350,150], :cell_style => {:inline_format => :true, :size=>10, :borders => [], :padding=>[7,0,0,20]}) do
      a = 0
      b = 1
      row(0).height=30
      column(0..1).font_style = :bold
      column(0).align = :left
      column(1).align =:right
      while a < b do
        a=+1
      end
    end
  end
  
  def table_ending
    data=[["#{I18n.t('instructor_appraisal.prepared').upcase}: BKKM","#{I18n.t('exam.evaluate_course.date_updated')} : #{@evaluate_course.updated_at.try(:strftime, '%d-%m-%Y')} "]]
    table(data, :column_widths => [310,200], :cell_style => {:size=>10, :borders => [:left, :right, :top, :bottom]}) do
      a = 0
      b = 1
      column(0).font_style = :bold
      column(1).font_style = :bold
      while a < b do
        a=+1
      end
    end
  end

  def footer
    draw_text "#{page_number} #{I18n.t('instructor_appraisal.from')} 1",  :size => 8, :at => [240,-5]
  end
  
end
