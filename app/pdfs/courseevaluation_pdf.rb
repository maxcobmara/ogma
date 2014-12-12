class CourseevaluationPdf < Prawn::Document  
  def initialize(evaluate_course, view, evs)
    super({top_margin: 50, page_size: 'A4', page_layout: :portrait })
    @evaluate_course  = evaluate_course
    @view = view
    @evs = evs
    font "Times-Roman"
    move_down 10
    image "#{Rails.root}/app/assets/images/logo_kerajaan.png"
    move_down 5
    table_heading
    move_down 10
    text "#{I18n.t('exam.evaluate_course.by_student')}", :align => :center, :size => 12
    move_down 20
    table_detailing
    move_down 20
    table_score
    move_down 20
    text "#{I18n.t('exam.evaluate_course.comment')} : "
    move_down 10
    text "#{@evaluate_course.comment}"
    move_down 20
    table_current_date
  end
  
  def table_heading
    data=[["#{I18n.t('exam.evaluate_course.prepared_by')} : #{@evaluate_course.student_id? ? @evaluate_course.student_id.matrix_name : '' }","#{I18n.t('exam.evaluate_course.date_updated')} : #{@evaluate_course.updated_at.try(:strftime, '%d %b %Y')} "]]
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
          ["#{I18n.t('exam.evaluate_course.subject_id')} :","#{@evaluate_course.subjectevaluate.subject_list}","#{I18n.t('exam.evaluate_course.evaluate_date')} : ","#{@evaluate_course.evaluate_date}"],
          ["#{I18n.t('exam.evaluate_course.staff_id')} : ","#{@evaluate_course.staff_id? ? @evaluate_course.staffevaluate.name : @evaluate_course.invite_lec}","",""]]
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
             ["","","1","2","3","4","5","6","7","8","9"],
             ["1.","#{I18n.t('exam.evaluate_course.objective_achieved')}", "#{@evs[0]==1? @evs[0] : ""}","#{@evs[0]==2? @evs[0] : ""}", "#{@evs[0]==3? @evs[0] : ""}", "#{@evs[0]==4? @evs[0] : ""}","#{@evs[0]==5? @evs[0] : ""}", "#{@evs[0]==6? @evs[0] : ""}","#{@evs[0]==7? @evs[0] : ""}" ,"#{@evs[0]==8? @evs[0] : ""}", "#{@evs[0]==9? @evs[0] : ""}"],
             ["2.","#{I18n.t('exam.evaluate_course.lecturer_knowledge')}", "#{@evs[1]==1? @evs[1] : ""}","#{@evs[1]==2? @evs[1] : ""}", "#{@evs[1]==3? @evs[1] : ""}", "#{@evs[1]==4? @evs[1] : ""}","#{@evs[1]==5? @evs[1] : ""}", "#{@evs[1]==6? @evs[1] : ""}","#{@evs[1]==7? @evs[1] : ""}" ,"#{@evs[1]==8? @evs[1] : ""}", "#{@evs[1]==9? @evs[1] : ""}"],
             ["3.","#{I18n.t('exam.evaluate_course.lecturer_q_achievement')}", "#{@evs[2]==1? @evs[2] : ""}","#{@evs[2]==2? @evs[2] : ""}", "#{@evs[2]==3? @evs[2] : ""}", "#{@evs[2]==4? @evs[2] : ""}","#{@evs[2]==5? @evs[2] : ""}", "#{@evs[2]==6? @evs[2] : ""}","#{@evs[2]==7? @evs[2] : ""}" ,"#{@evs[2]==8? @evs[2] : ""}", "#{@evs[2]==9? @evs[2] : ""}"],
             ["4.","#{I18n.t('exam.evaluate_course.content')}", "#{@evs[3]==1? @evs[3] : ""}","#{@evs[3]==2? @evs[3] : ""}", "#{@evs[3]==3? @evs[3] : ""}", "#{@evs[3]==4? @evs[3] : ""}","#{@evs[3]==5? @evs[3] : ""}", "#{@evs[3]==6? @evs[3] : ""}","#{@evs[3]==7? @evs[3] : ""}" ,"#{@evs[3]==8? @evs[3] : ""}", "#{@evs[3]==9? @evs[3] : ""}"],
             ["5.","#{I18n.t('exam.evaluate_course.training_aids_quality')}", "#{@evs[4]==1? @evs[4] : ""}","#{@evs[4]==2? @evs[4] : ""}", "#{@evs[4]==3? @evs[4] : ""}", "#{@evs[4]==4? @evs[4] : ""}","#{@evs[4]==5? @evs[4] : ""}", "#{@evs[4]==6? @evs[4] : ""}","#{@evs[4]==7? @evs[4] : ""}" ,"#{@evs[4]==8? @evs[4] : ""}", "#{@evs[4]==9? @evs[4] : ""}"],
             ["6.","#{I18n.t('exam.evaluate_course.suitability_topic_sequence')}", "#{@evs[5]==1? @evs[5] : ""}","#{@evs[5]==2? @evs[5] : ""}", "#{@evs[5]==3? @evs[5] : ""}", "#{@evs[5]==4? @evs[5] : ""}","#{@evs[5]==5? @evs[5] : ""}", "#{@evs[5]==6? @evs[5] : ""}","#{@evs[5]==7? @evs[5] : ""}" ,"#{@evs[5]==8? @evs[5] : ""}", "#{@evs[5]==9? @evs[5] : ""}"],
             ["7.","#{I18n.t('exam.evaluate_course.effectiveness_teaching_learning')}", "#{@evs[6]==1? @evs[6] : ""}","#{@evs[6]==2? @evs[6] : ""}", "#{@evs[6]==3? @evs[6] : ""}", "#{@evs[6]==4? @evs[6] : ""}","#{@evs[6]==5? @evs[6] : ""}", "#{@evs[6]==6? @evs[6] : ""}","#{@evs[6]==7? @evs[6] : ""}" ,"#{@evs[6]==8? @evs[6] : ""}", "#{@evs[6]==9? @evs[6] : ""}"],
             ["8.","#{I18n.t('exam.evaluate_course.benefit_notes')}","#{@evs[7]==1? @evs[7] : ""}","#{@evs[7]==2? @evs[7] : ""}", "#{@evs[7]==3? @evs[7] : ""}", "#{@evs[7]==4? @evs[7] : ""}","#{@evs[7]==5? @evs[7] : ""}", "#{@evs[7]==6? @evs[7] : ""}","#{@evs[7]==7? @evs[7] : ""}" ,"#{@evs[7]==8? @evs[7] : ""}", "#{@evs[7]==9? @evs[7] : ""}"]
             ] 
     
       table(data, :column_widths => [30, 345, 15, 15,15,15,15,15,15,15,15], :cell_style=>{:size=>11, :borders=>[:left, :right, :top, :bottom]}) do
         a=0
         b=10
         rows(0).font_style = :bold
         columns(2..11).font_style = :bold
         rows(0).background_color = 'ABA9A9'
         #cells[1,8].font_style = :bold
         while a < b do
           a+=1  
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
