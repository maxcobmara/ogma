class Evaluation_analysisPdf < Prawn::Document  
  def initialize(average_course, view, evs_int, college, actual_scores, evaluator)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @average_course= average_course
    @view = view
    @evs_int = evs_int
    @evaluator_count=evaluator
    topic_ids=Programme.find(@average_course.subject_id).descendants.where(course_type: ['Topic', 'Subtopic']).pluck(:id)
    lecturer_classes=WeeklytimetableDetail.where(lecturer_id: @average_course.lecturer_id, topic: topic_ids).pluck(:id)
    @total_student==StudentAttendance.where(weeklytimetable_details_id: lecturer_classes).pluck(:student_id).uniq.count
    font "Helvetica"
    if college.code=="kskbjb"
      move_down 10
    end
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
        draw_text "PPL APMM", :at => [80, 100], :style => :bold
        draw_text "NO.DOKUMEN: BK-KKM-04-04", :at => [15, 85], :style => :bold
        draw_text "BORANG DATA ANALISA SKOR PURATA PENILAIAN", :at => [-30, 65], :style => :bold
        draw_text "PENSYARAH", :at => [75, 50], :style => :bold
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
   
    text "#{I18n.t('exam.evaluate_course.by_quality_dept')}", :align => :center, :size => 12
    if college.code=="kskbjb"
      move_down 20
    end
    text ""
    table_detailing
    table_score
    move_down 2
    if actual_scores!=@evs_int
      text "#{I18n.t('exam.average_course.score_rounded_actual')} : #{actual_scores.split(',').join(', ').to_s}", :size => 8
    end
    start_new_page
    table_detailing2
    move_down 50
    table_footer
  end
  
  def table_detailing
    data=[["<u>DATA PENSYARAH</u>"],
          ["1.  #{I18n.t('exam.average_course.lecturer_id')} : #{@average_course.lecturer.try(:staff_with_rank) }"],
          ["2. #{I18n.t('exam.average_course.icno')} : #{@average_course.lecturer.try(:formatted_mykad) }    #{I18n.t('staff.rank_id')}/Jawatan : #{@average_course.lecturer.try(:rank).try(:name)}/#{@average_course.lecturer.try(:positions).try(:first).name}"],
          ["3.  #{I18n.t('exam.average_course.organisation')} : #{@average_course.organisation}"], 
          ["4.  #{I18n.t('exam.average_course.expertise_qualification')} : #{@average_course.expertise_qualification}"],[""],
          ["<u>DATA KURSUS</u>"],
          ["5.  #{I18n.t('exam.evaluate_course.course_id')} : #{@average_course.subject.root.name}"],
          ["6.  #{I18n.t('training.programme.course_type')} : #{@average_course.subject.root.course_type=='Asas' ? '<b>Asas</b>' : 'Asas'}  #{@average_course.subject.root.course_type=='Pertengahan' ? '<b>Pertengahan</b>' : 'Pertengahan'}  #{@average_course.subject.root.course_type=='Lanjutan' ? '<b>Lanjutan</b>' : 'Asas'}"],
          ["7.  #{I18n.t('exam.average_course.total_students')} : #{@evaluator_count} / #{@total_student}"],
          ["8.  #{I18n.t('training.programme.level')} : #{@average_course.subject.root.level=='peg' ? '<b>PEG</b>' : 'PEG'}  #{@average_course.subject.root.level=='llp' ? '<b>LLP</b>' : 'LLP'} "],[""],
          ["<u>DATA ANALISIS PENILAIAN</u>"],
          ["9.  #{I18n.t('exam.average_course.subject_id') } : #{@average_course.subject.subject_list}"],
          ["10.  #{I18n.t('exam.evaluate_course.average_scores')} : "], [""]
          ]
    table(data, :column_widths => [510], :cell_style => { :size => 11, :inline_format => true, :padding => [0, 0, 0, 0]})  do
      rows(0..2).borders=[]
      column(0).borders=[]
      rows(0..4).height=20
      row(5).height=5
      rows(6..10).height=20
      row(11).height=5
      rows(12..14).height=20
      row(15).height=3
      a = 0
      b = 1
      row(0).font_style = :bold
      row(6).font_style = :bold
      row(12).font_style = :bold
      column(1).font_style = :bold
      while a < b do
        a=+1
      end
    end
  end
  
   def table_score
       data=[["No","#{I18n.t('exam.evaluate_course.description')}",{content: "#{I18n.t('exam.evaluate_course.score')}", colspan: 9}],
             ["1.","#{I18n.t('exam.evaluate_course.objective_achieved')}", "#{@evs_int[0]==1? '<b>'+@evs_int[0].to_s+'</b>' : ""}","#{@evs_int[0]==2? '<b>'+@evs_int[0].to_s+'</b>' : ""}", "#{@evs_int[0]==3? '<b>'+@evs_int[0].to_s+'</b>' : ""}", "#{@evs_int[0]==4? '<b>'+@evs_int[0].to_s+'</b>' : ""}","#{@evs_int[0]==5? '<b>'+@evs_int[0].to_s+'</b>' : ""}", "#{@evs_int[0]==6? '<b>'+@evs_int[0].to_s+'</b>' : ""}","#{@evs_int[0]==7? '<b>'+@evs_int[0].to_s+'</b>' : ""}" ,"#{@evs_int[0]==8? '<b>'+@evs_int[0].to_s+'</b>' : ""}", "#{@evs_int[0]==9? '<b>'+@evs_int[0].to_s+'</b>' : ""}"],
             ["2.","#{I18n.t('exam.evaluate_course.lecturer_knowledge')}", "#{@evs_int[1]==1? '<b>'+@evs_int[1].to_s+'</b>' : ""}","#{@evs_int[1]==2? '<b>'+@evs_int[1].to_s+'</b>' : ""}", "#{@evs_int[1]==3? '<b>'+@evs_int[1].to_s+'</b>' : ""}", "#{@evs_int[1]==4? '<b>'+@evs_int[1].to_s+'</b>' : ""}","#{@evs_int[1]==5? '<b>'+@evs_int[1].to_s+'</b>' : ""}", "#{@evs_int[1]==6? '<b>'+@evs_int[1].to_s+'</b>' : ""}","#{@evs_int[1]==7? '<b>'+@evs_int[1].to_s+'</b>' : ""}" ,"#{@evs_int[1]==8? '<b>'+@evs_int[1].to_s+'</b>' : ""}", "#{@evs_int[1]==9? '<b>'+@evs_int[1].to_s+'</b>' : ""}"],
             ["3.","#{I18n.t('exam.evaluate_course.lecturer_q_achievement')}", "#{@evs_int[2]==1?  '<b>'+@evs_int[2].to_s+'</b>' : ""}","#{@evs_int[2]==2? '<b>'+@evs_int[2].to_s+'</b>' : ""}", "#{@evs_int[2]==3? '<b>'+@evs_int[2].to_s+'</b>' : ""}", "#{@evs_int[2]==4? '<b>'+@evs_int[2].to_s+'</b>' : ""}","#{@evs_int[2]==5? '<b>'+@evs_int[2].to_s+'</b>' : ""}", "#{@evs_int[2]==6? '<b>'+@evs_int[2].to_s+'</b>' : ""}","#{@evs_int[2]==7? '<b>'+@evs_int[2].to_s+'</b>' : ""}" ,"#{@evs_int[2]==8? '<b>'+@evs_int[2].to_s+'</b>' : ""}", "#{@evs_int[2]==9? '<b>'+@evs_int[2].to_s+'</b>' : ""}"],
             ["4.","#{I18n.t('exam.evaluate_course.content')}", "#{@evs_int[3]==1? '<b>'+@evs_int[3].to_s+'</b>' : ""}","#{@evs_int[3]==2? '<b>'+@evs_int[3].to_s+'</b>' : ""}", "#{@evs_int[3]==3? '<b>'+@evs_int[3].to_s+'</b>' : ""}", "#{@evs_int[3]==4? '<b>'+@evs_int[3].to_s+'</b>' : ""}","#{@evs_int[3]==5? '<b>'+@evs_int[3].to_s+'</b>' : ""}", "#{@evs_int[3]==6? '<b>'+@evs_int[3].to_s+'</b>' : ""}","#{@evs_int[3]==7? '<b>'+@evs_int[3].to_s+'</b>' : ""}" ,"#{@evs_int[3]==8? '<b>'+@evs_int[3].to_s+'</b>' : ""}", "#{@evs_int[3]==9? '<b>'+@evs_int[3].to_s+'</b>' : ""}"],
             ["5.","#{I18n.t('exam.evaluate_course.training_aids_quality')}", "#{@evs_int[4]==1? '<b>'+@evs_int[4].to_s+'</b>' : ""}","#{@evs_int[4]==2? '<b>'+@evs_int[4].to_s+'</b>' : ""}", "#{@evs_int[4]==3? '<b>'+@evs_int[4].to_s+'</b>' : ""}", "#{@evs_int[4]==4? '<b>'+@evs_int[4].to_s+'</b>' : ""}","#{@evs_int[4]==5? '<b>'+@evs_int[4].to_s+'</b>' : ""}", "#{@evs_int[4]==6? '<b>'+@evs_int[4].to_s+'</b>' : ""}","#{@evs_int[4]==7? '<b>'+@evs_int[4].to_s+'</b>' : ""}" ,"#{@evs_int[4]==8? '<b>'+@evs_int[4].to_s+'</b>' : ""}", "#{@evs_int[4]==9? '<b>'+@evs_int[4].to_s+'</b>' : ""}"],
             ["6.","#{I18n.t('exam.evaluate_course.suitability_topic_sequence')}", "#{@evs_int[5]==1? '<b>'+@evs_int[5].to_s+'</b>' : ""}","#{@evs_int[5]==2? '<b>'+@evs_int[5].to_s+'</b>' : ""}", "#{@evs_int[5]==3? '<b>'+@evs_int[5].to_s+'</b>' : ""}", "#{@evs_int[5]==4? '<b>'+@evs_int[5].to_s+'</b>' : ""}","#{@evs_int[5]==5? '<b>'+@evs_int[5].to_s+'</b>' : ""}", "#{@evs_int[5]==6? '<b>'+@evs_int[5].to_s+'</b>' : ""}","#{@evs_int[5]==7? '<b>'+@evs_int[5].to_s+'</b>' : ""}" ,"#{@evs_int[5]==8? '<b>'+@evs_int[5].to_s+'</b>' : ""}", "#{@evs_int[5]==9? '<b>'+@evs_int[5].to_s+'</b>' : ""}"],
             ["7.","#{I18n.t('exam.evaluate_course.effectiveness_teaching_learning')}", "#{@evs_int[6]==1? '<b>'+@evs_int[6].to_s+'</b>' : ""}","#{@evs_int[6]==2? '<b>'+@evs_int[6].to_s+'</b>' : ""}", "#{@evs_int[6]==3? '<b>'+@evs_int[6].to_s+'</b>' : ""}", "#{@evs_int[6]==4? '<b>'+@evs_int[6].to_s+'</b>' : ""}","#{@evs_int[6]==5? '<b>'+@evs_int[6].to_s+'</b>' : ""}", "#{@evs_int[6]==6? '<b>'+@evs_int[6].to_s+'</b>' : ""}","#{@evs_int[6]==7? '<b>'+@evs_int[6].to_s+'</b>' : ""}" ,"#{@evs_int[6]==8? '<b>'+@evs_int[6].to_s+'</b>' : ""}", "#{@evs_int[6]==9? '<b>'+@evs_int[6].to_s+'</b>' : ""}"],
             ["8.","#{I18n.t('exam.evaluate_course.benefit_notes')}","#{@evs_int[7]==1? '<b>'+@evs_int[7].to_s+'</b>' : ""}","#{@evs_int[7]==2? '<b>'+@evs_int[7].to_s+'</b>' : ""}", "#{@evs_int[7]==3? '<b>'+@evs_int[7].to_s+'</b>' : ""}", "#{@evs_int[7]==4? '<b>'+@evs_int[7].to_s+'</b>' : ""}","#{@evs_int[7]==5? '<b>'+@evs_int[7].to_s+'</b>' : ""}", "#{@evs_int[7]==6? '<b>'+@evs_int[7].to_s+'</b>' : ""}","#{@evs_int[7]==7? '<b>'+@evs_int[7].to_s+'</b>' : ""}" ,"#{@evs_int[7]==8? '<b>'+@evs_int[7].to_s+'</b>' : ""}", "#{@evs_int[7]==9? '<b>'+@evs_int[7].to_s+'</b>' : ""}"],
             ["9.","#{I18n.t('exam.evaluate_course.suitable_assessment')}","#{@evs_int[8]==1? '<b>'+@evs_int[8].to_s+'</b>' : ""}","#{@evs_int[8]==2? '<b>'+@evs_int[8].to_s+'</b>' : ""}", "#{@evs_int[8]==3? '<b>'+@evs_int[8].to_s+'</b>' : ""}", "#{@evs_int[8]==4? '<b>'+@evs_int[8].to_s+'</b>' : ""}","#{@evs_int[8]==5? '<b>'+@evs_int[8].to_s+'</b>' : ""}", "#{@evs_int[8]==6? '<b>'+@evs_int[8].to_s+'</b>' : ""}","#{@evs_int[8]==7? '<b>'+@evs_int[8].to_s+'</b>' : ""}" ,"#{@evs_int[8]==8? '<b>'+@evs_int[8].to_s+'</b>' : ""}", "#{@evs_int[8]==9? '<b>'+@evs_int[8].to_s+'</b>' : ""}"]
             ] 
     
       table(data, :column_widths => [30, 340, 15, 15,15,15,15,15,15,15,20], :cell_style=>{:size=>10, :borders=>[:left, :right, :top, :bottom], :inline_format => :true}) do
         a=0
         b=9
         rows(0).font_style = :bold
         rows(0).background_color = 'ABA9A9'
         while a < b do
           a+=1  
         end
       end
       
  end
  
  def table_detailing2
    data=[[{content: "11.  #{I18n.t('exam.average_course.dissatisfaction')} : #{@average_course.dissatisfaction}", colspan: 2}], [{content: "12.  #{I18n.t('exam.average_course.recommend_for_improvement')} : #{@average_course.recommend_for_improvement}", colspan: 2}],
          [{content: "", colspan: 2}], [{content: "<u>RUMUSAN PENILAIAN</u>", colspan: 2}], [{content: "", colspan: 2}],
          [{content: "13.  #{I18n.t('exam.average_course.criteria_notes')}", colspan: 2}], ["","a.      #{I18n.t('exam.average_course.lecturer_knowledge')}   #{@average_course.lecturer_knowledge}"],
         ["","b.      #{I18n.t('exam.average_course.delivery_quality')}             #{@average_course.delivery_quality}"], ["","c.      #{I18n.t('exam.average_course.lesson_content')}    #{@average_course.lesson_content}"], 
          [{content: "14.  #{I18n.t('exam.average_course.evaluation_category')} :  #{@average_course.evaluation_category==true ? '<b>'+I18n.t('exam.average_course.qualified')+'</b>' : I18n.t('exam.average_course.qualified')} #{@average_course.evaluation_category==false ? '<b>'+I18n.t('exam.average_course.not_qualified')+'</b>' : I18n.t('exam.average_course.not_qualified')}", colspan: 2}], [""],
         [{content: "15.  <b>#{I18n.t('exam.average_course.support_justify')}</b> : #{@average_course.support_justify}", colspan: 2}],[{content: "PENGESAHAN KETUA SEKOLAH", colspan: 2}],
         [{content: "#{I18n.t('exam.average_course.signatory')} : ", colspan: 2}], [{content: "#{I18n.t('exam.average_course.principal_id')} : #{@average_course.verifier.try(:staff_with_rank)}", colspan: 2}], [{content: "#{I18n.t('staff.rank_id')} : #{@average_course.verifier.try(:rank).try(:name)}", colspan: 2}], [{content: "#{I18n.t('exam.average_course.principal_date')} : #{@average_course.principal_date.try(:strftime, '%d-%m-%Y')}", colspan: 2}] ]
    table(data, :column_widths => [70,440], :cell_style => { :size => 11, :inline_format => true, :padding => [0, 0, 0, 0]})  do
      a=0
      b=1
      rows(0..2).borders=[]
      column(0..1).borders=[]
      row(3).font_style = :bold
      rows(11..12).font_style = :bold
      rows(0..1).height=40
      row(2).height=5
      row(3).height=20
      row(4).height=5
      row(5).height=40
      rows(6..8).height=20
      row(9).height=25
      row(10).height=5
      rows(11..12).height=40
      rows(13..16).height=20
      
      
      while a < b do
        a=+1
      end
    end
  end
  
  def table_footer
    data=[["#{I18n.t('exam.evaluate_course.prepared_by')} : BKMM ","#{I18n.t('exam.evaluate_course.date_updated')} : #{@average_course.updated_at.try(:strftime, '%d-%m- %Y')} "]]
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
  
end
