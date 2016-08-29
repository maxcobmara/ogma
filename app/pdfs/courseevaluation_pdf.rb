class CourseevaluationPdf < Prawn::Document  
  def initialize(evaluate_course, view, evs, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @evaluate_course  = evaluate_course
    @view = view
    @evs = evs
    font "Times-Roman"
    if college.code=="kskbjb"
      move_down 10
    end
    #image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
    bounding_box([10,770], :width => 400, :height => 100) do |y2|
       image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
    end
    bounding_box([150,750], :width => 350, :height => 100) do |y2|
      if college.code=="kskbjb"
        move_down 30
        text "#{college.name}"
        move_down 1
        text "#{I18n.t('exam.evaluate_course.title')}"
      else
        draw_text "PPL APMM", :at => [80, 85], :style => :bold
        draw_text "NO.DOKUMEN: BK-KKM-KS-04-04", :at => [15, 60], :style => :bold
        draw_text "BORANG PENILAIAN PENSYARAH", :at => [20, 45], :style => :bold
      end
    end
    
    if college.code=="kskbjb"
      bounding_box([400,750], :width => 400, :height => 100) do |y2|
        image "#{Rails.root}/app/assets/images/kskb_logo-6.png",  :width =>97.2, :height =>77.76
      end
    else
      bounding_box([430,770], :width => 400, :height => 90) do |y2|
        image "#{Rails.root}/app/assets/images/amsas_logo_small.png"
      end
    end
    
    #move_down 5
    if college.code=="amsas"
      table_heading
      move_down 20
    end
    text "#{I18n.t('exam.evaluate_course.by_student')}", :align => :center, :size => 12
    if college.code=="kskbjb"
      move_down 20
    end
    table_detailing
    if college.code=="kskbjb"
      move_down 20
    else
      bounding_box([50,530], :width => 410, :height => 80) do |y2|
        image "#{Rails.root}/app/assets/images/skala.png", :width => 400
      end
    end
    table_score
    move_down 20
    text "#{I18n.t('exam.evaluate_course.comment')}"
    move_down 10
    table_comment
    move_down 20
    table_current_date
  end
  
  def table_heading
    data=[["#{I18n.t('exam.evaluate_course.prepared_by')} : #{@evaluate_course.student_id? ? @evaluate_course.studentevaluate.student_with_rank : '' }","#{I18n.t('exam.evaluate_course.date_updated')} : #{@evaluate_course.updated_at.try(:strftime, '%d %b %Y')} "]]
    table(data, :column_widths => [255,255], :cell_style => {:size=>11, :borders => [:left, :right, :top, :bottom]}) do
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
    data=[["#{I18n.t('exam.evaluate_course.course_id')} :","#{@evaluate_course.stucourse.programme_list}","",""],
          ["#{I18n.t('exam.evaluate_course.subject_id') unless @evaluate_course.subject_id.blank? } #{I18n.t('exam.evaluate_course.invite_lec_topic') unless @evaluate_course.invite_lec.blank?} :","#{@evaluate_course.subjectevaluate.subject_list unless @evaluate_course.subject_id.blank?} #{@evaluate_course.invite_lec_topic unless @evaluate_course.invite_lec.blank?}","#{I18n.t('exam.evaluate_course.evaluate_date')} : ","#{@evaluate_course.evaluate_date.try(:strftime, '%d %b %Y')}"],
          ["#{I18n.t('exam.evaluate_course.staff_id') unless @evaluate_course.staff_id.blank?} #{I18n.t('exam.evaluate_course.invite_lec') unless @evaluate_course.invite_lec.blank?} : ","#{@evaluate_course.staff_id? ? @evaluate_course.staffevaluate.try(:staff_with_rank) : @evaluate_course.invite_lec}","",""]]
    table(data, :column_widths => [100, 190, 110, 110], :cell_style => { :size => 11})  do
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
     
       table(data, :column_widths => [30, 340, 15, 15,15,15,15,15,15,15,20], :cell_style=>{:size=>11, :borders=>[:left, :right, :top, :bottom], :inline_format => :true}) do
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
    data=[["#{@evaluate_course.comment}"]]
    table(data, :column_widths => [500],:cell_style => {:size=>11, :borders => []}) do
      a = 0
      b = 1
      column(0).font_style = :bold
      row(0).height = 130
      self.width = 500
      while a < b do
        a=+1
      end
    end
  end
  
  def table_current_date
    data=[["Tarikh : ","#{Date.today.try(:strftime, '%d %b %Y')}"]]
    table(data, :column_widths => [430,70], :cell_style => {:size=>11, :borders => []}) do
      a = 0
      b = 1
      column(0).font_style = :bold
      column(0).align = :right
      while a < b do
        a=+1
      end
    end
  end
  
end
