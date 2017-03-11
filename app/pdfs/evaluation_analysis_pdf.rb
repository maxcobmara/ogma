class Evaluation_analysisPdf < Prawn::Document  
  def initialize(average_course, view, evs_int, college, actual_scores, evaluator)
    super({top_margin: 40, left_margin: 60, page_size: 'A4', page_layout: :portrait })
    @average_course= average_course
    @view = view
    @evs_int = evs_int
    @evaluator_count=evaluator
    #topic_ids=Programme.find(@average_course.subject_id).descendants.where(course_type: ['Topic', 'Subtopic']).pluck(:id)
    #lecturer_classes=WeeklytimetableDetail.where(lecturer_id: @average_course.lecturer_id, topic: topic_ids).pluck(:id)
    #@total_student==StudentAttendance.where(weeklytimetable_details_id: lecturer_classes).pluck(:student_id).uniq.count
    font "Helvetica"
    if college.code=="kskbjb"
      move_down 10
    end
    bounding_box([0,770], :width => 400, :height => 100) do |y2|
       if college.code=="kskbjb"
          image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
       else
	 move_down 5
          image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :scale => 0.7
       end
    end
    bounding_box([120,750], :width => 350, :height => 100) do |y2|
      if college.code=="kskbjb"
        move_down 30
        text "#{college.name}"
        move_down 1
        text "#{I18n.t('exam.evaluate_course.title')}"
      else
        draw_text "PPL APMM", :at => [90, 90], :style => :bold
        draw_text "NO.DOKUMEN: BK-KKM-04-04", :at => [25, 65], :style => :bold
        draw_text "BORANG DATA ANALISA SKOR PURATA PENILAIAN PENSYARAH", :at => [-60, 40], :style => :bold
      end
    end
    
    if college.code=="kskbjb"
      bounding_box([400,750], :width => 400, :height => 100) do |y2|
        image "#{Rails.root}/app/assets/images/kskb_logo-6.png",  :width =>97.2, :height =>77.76
      end
    else
      bounding_box([430,770], :width => 400, :height => 90) do |y2|
        image "#{Rails.root}/app/assets/images/amsas_logo_small.png", :scale => 0.8
      end
    end
   move_down 20
    text "#{I18n.t('exam.evaluate_course.by_quality_dept')}", :align => :center, :size => 12
    if college.code=="kskbjb"
      move_down 20
    else
      move_down 10
    end
    text ""
    stroke_details
    table_detailing
    table_score
    move_down 2
    if actual_scores!=@evs_int
      text "#{I18n.t('exam.average_course.score_rounded_actual')} : #{actual_scores.split(',').join(', ').to_s}", :size => 8
    end
    start_new_page
    stroke_details2
    image "#{Rails.root}/app/assets/images/curly_braces.png", :scale => 0.55, :at => [270, 522]
    draw_text "#{I18n.t('exam.average_course.enter_avgscore')}", :at => [300, 490], :size => 11
    table_detailing2
    move_down 50
    table_ending
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def stroke_details
    stroke do
      horizontal_line 108, 490, :at => 603 #pensyarah
      horizontal_line 60, 180, :at => 583
      horizontal_line 273, 490, :at => 583
      horizontal_line 79, 490, :at => 563
      horizontal_line 131, 490, :at => 543
      horizontal_line 135, 490, :at => 493 #program
      horizontal_line 185, 205, :at => 487 #asas box
      horizontal_line 185, 205, :at => 472
      vertical_line 472, 487, :at => 185
      vertical_line 472, 487, :at => 205
      horizontal_line 255, 275, :at => 487 #pertengahan box
      horizontal_line 255, 275, :at => 472
      vertical_line 472, 487, :at => 255
      vertical_line 472, 487, :at => 275
      horizontal_line 365, 385, :at => 487 #lanjutan box
      horizontal_line 365, 385, :at => 472
      vertical_line 472, 487, :at => 365
      vertical_line 472, 487, :at => 385
      horizontal_line 94, 135, :at => 454 #jumlah pelatih
      horizontal_line 185, 205, :at => 447 #peg box
      horizontal_line 185, 205, :at => 432
      vertical_line 432, 447, :at => 185
      vertical_line 432, 447, :at => 205
      horizontal_line 255, 275, :at => 447 #llp box
      horizontal_line 255, 275, :at => 432
      vertical_line 432, 447, :at => 255
      vertical_line 432, 447, :at => 275
      horizontal_line 98, 490, :at => 384 # tajuk pelajaran
    end
  end
  
  def table_detailing
    data=[[{content: "<u>#{I18n.t('exam.average_course.lecturer_data').upcase}</u>", colspan: 9}],
          [{content: "1.  #{I18n.t('exam.average_course.lecturer_id')} : #{@average_course.visitor.visitor_with_title_rank }", colspan: 9}],
          [{content: "2.  #{I18n.t('exam.average_course.icno')} : #{@view.formatted_mykad(@average_course.visitor.icno)}", colspan: 3}, {content: " #{I18n.t('exam.average_course.rank_position')} : #{@average_course.visitor.rank_id.blank? ? '-' : @average_course.visitor.rank.name} / #{@average_course.visitor.position.blank? ? '-' : @average_course.visitor.position}", colspan: 6}],
          [{content: "3.  #{I18n.t('exam.average_course.organisation')} :  #{@average_course.visitor.corporate==true ? @average_course.visitor.address_book.name : @average_course.visitor.department}", colspan: 9}], 
          [{content: "4.  #{I18n.t('exam.average_course.expertise_qualification')} : #{@average_course.visitor.try(:expertise)}", colspan: 9}],[{content: "", colspan: 9}],
          [{content: "<u>#{I18n.t('exam.average_course.course_data').upcase}</u>", colspan: 9}],
          [{content: "5.  #{@average_course.college.code=='amsas' ? I18n.t('exam.evaluate_course.course_form') :  I18n.t('exam.evaluate_course.course_id')} : #{@average_course.subject.root.name}", colspan: 9}],
          ["6.  #{I18n.t('exam.average_course.course_type')} : ","","","#{@average_course.subject.root.course_type=='Asas' ? '/' : ' '}","Asas", "#{@average_course.subject.root.course_type=='Pertengahan' ? 'BBB' : ' '}","Pertengahan", "#{@average_course.subject.root.course_type=='Lanjutan' ? 'CCC' : ' '}", "Lanjutan"],
          [{content: "7.  #{I18n.t('exam.average_course.total_students')} :  #{@evaluator_count}", colspan: 9}],
          [{content: "8.  #{I18n.t('training.programme.level')} :  ", colspan: 2},"PEG","#{@average_course.subject.root.level=='peg' ? '/' : ''}","LLP","#{@average_course.subject.root.level=='llp' ? '/' : '' }", {content: "", colspan: 3}],[{content: "", colspan: 9}],
          [{content: "<u>#{I18n.t('exam.average_course.evaluation_analysis_data').upcase}</u>", colspan: 9}],
          [{content: "9.  #{I18n.t('exam.average_course.subject_id') } : #{@average_course.subject.subject_list}", colspan: 9}],
          [{content: "10.  #{I18n.t('exam.evaluate_course.average_scores')} : ", colspan: 9}], [{content: "", colspan: 9}]
          ]
          ##{@average_course.subject.root.course_type=='Asas' ? '<b>Asas</b>' : 'Asas'}  #{@average_course.subject.root.course_type=='Pertengahan' ? '<b>Pertengahan</b>' : 'Pertengahan'}  #{@average_course.subject.root.course_type=='Lanjutan' ? '<b>Lanjutan</b>' : 'Lanjutan'}
          ##{@average_course.subject.root.level=='peg' ? '<b>PEG</b>' : 'PEG'}  #{@average_course.subject.root.level=='llp' ? '<b>LLP</b>' : 'LLP'}
    #350
    table(data, :column_widths => [120, 30,30, 30, 40, 30, 80, 30, 70], :cell_style => { :size => 11, :inline_format => true, :padding => [0, 0, 0, 0]})  do 
      rows(0..2).borders=[]
      column(0..1).borders=[]
      rows(8).columns(2..8).align = :center
      rows(10).columns(2..5).align = :center
      rows(8).columns(2..8).borders=[]
      rows(10).columns(2..8).borders=[]
      rows(0..4).height=20
      row(5).height=10
      rows(6..10).height=20
      row(11).height=10
      rows(12..14).height=20
      row(15).height=3
      a = 0
      b = 1
      row(0).font_style = :bold
      row(6).font_style = :bold
      row(12).font_style = :bold
      row(0).column(1).font_style = :bold
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
     
       table(data, :column_widths => [30, 320, 15, 15,15,15,15,15,15,15,20], :cell_style=>{:size=>10, :borders=>[:left, :right, :top, :bottom], :inline_format => :true}) do
         a=0
         b=9
         rows(0).font_style = :bold
         rows(0).background_color = 'ABA9A9'
         while a < b do
           a+=1  
         end
       end
       
  end
  
  def stroke_details2
    stroke do
      horizontal_line 122, 490, :at => 754 #dissatisfaction
      horizontal_line 0, 490, :at => 741
      horizontal_line 0, 490, :at => 728
      horizontal_line 0, 490, :at => 716
      horizontal_line 0, 490, :at => 703
      horizontal_line 0, 490, :at => 690
      horizontal_line 139, 490, :at => 664 #suggestion
      horizontal_line 0, 490, :at => 651
      horizontal_line 0, 490, :at => 638
      horizontal_line 0, 490, :at => 626
      horizontal_line 0, 490, :at => 613
      horizontal_line 0, 490, :at => 600
      horizontal_line 223, 251, :at => 522#lecturer_knowledge
      horizontal_line 223, 251, :at => 507 #lecturer_knowledge
      vertical_line 507, 522, :at => 223
      vertical_line 507, 522, :at => 251
      horizontal_line 223, 251, :at => 503 #delivery_quality
      horizontal_line 223, 251, :at => 486 #delivery_quality
      vertical_line 486, 503, :at => 223
      vertical_line 486, 503, :at => 251
      horizontal_line 223, 251, :at => 482 #lesson_content
      horizontal_line 223, 251, :at => 467 #lesson_content
      vertical_line 467, 482, :at => 223
      vertical_line 467, 482, :at => 251
      horizontal_line 130, 156, :at => 442 #box layak
      horizontal_line 130, 156, :at => 427
      vertical_line 427, 442, :at => 130
      vertical_line 427, 442, :at => 156
      horizontal_line 220, 246, :at => 442 #box tak layak
      horizontal_line 220, 246, :at => 427
      vertical_line 427, 442, :at => 220
      vertical_line 427, 442, :at => 246
      horizontal_line 139, 490, :at => 398 #support_justify
      horizontal_line 0, 490, :at => 385
      horizontal_line 0, 490, :at => 373
      horizontal_line 0, 490, :at => 360
      horizontal_line 0, 490, :at => 347
      horizontal_line 0, 490, :at => 334
      horizontal_line 0, 490, :at => 321
      horizontal_line 0, 490, :at => 308
      horizontal_line 0, 490, :at => 296
      horizontal_line 72, 330, :at => 180 #signatory 
      horizontal_line 72, 330, :at => 157 #full name
      horizontal_line 49, 330, :at => 137 #rank
      horizontal_line 37, 330, :at => 117 #date
    end
  end
  
  def table_detailing2
    data=[[{content: "11.  #{I18n.t('exam.average_course.dissatisfaction')} : #{@average_course.dissatisfaction}", colspan: 2}],[{content: "", colspan: 2}], [{content: "12.  #{I18n.t('exam.average_course.recommend_for_improvement')} : #{@average_course.recommend_for_improvement}", colspan: 2}],
          [{content: "", colspan: 2}], [{content: "<b><u>#{I18n.t('exam.average_course.evaluation_summary').upcase}</u></b>", colspan: 2}], [{content: "", colspan: 2}],
          [{content: "13.  #{I18n.t('exam.average_course.criteria_notes')}", colspan: 2}], ["","a.      #{I18n.t('exam.average_course.lecturer_knowledge')}      <b>#{@average_course.lecturer_knowledge}</b>"],
         ["","b.      #{I18n.t('exam.average_course.delivery_quality')}              <b>#{@average_course.delivery_quality}</b>"], ["","c.      #{I18n.t('exam.average_course.lesson_content')}      <b>#{@average_course.lesson_content}</b>"], 
          [{content: "14.  #{I18n.t('exam.average_course.evaluation_category')} :  #{@average_course.evaluation_category==true ? '     /    ' : '          '}   #{I18n.t('exam.average_course.qualified')} #{@average_course.evaluation_category==false ? '    /    ' : '         '}    #{ I18n.t('exam.average_course.not_qualified')}", colspan: 2}], [""],
         [{content: "15.  <b>#{I18n.t('exam.average_course.support_justify')}</b> : #{@average_course.support_justify}", colspan: 2}], [{content: "", colspan: 2}], [{content: "<b>#{I18n.t('exam.average_course.principal_verification').upcase}: </b>", colspan: 2}],
         [{content: "#{I18n.t('exam.average_course.signatory')} :  ", colspan: 2}], [{content: "#{I18n.t('exam.evaluate_course.full_name')} : #{@average_course.verifier.try(:staff_with_rank)}", colspan: 2}], [{content: "#{I18n.t('exam.evaluate_course.rank_id')} : #{@average_course.verifier.try(:rank).try(:name)}", colspan: 2}], [{content: "#{I18n.t('exam.average_course.principal_date')} : #{@average_course.principal_date.try(:strftime, '%d/%m/%Y')}", colspan: 2}] ]
    table(data, :column_widths => [70,420], :cell_style => { :size => 11, :inline_format => true, :padding => [0, 0, 0, 0]})  do
      a=0
      b=1
      rows(0..2).borders=[]
      column(0..1).borders=[]
      row(3).font_style = :bold
      #rows(11..12).font_style = :bold
      rows(0).height=80
      rows(1).height=10
      rows(2).height=80
      row(3).height=10
      row(4).height=20
      row(5).height=5
      row(6).height=40
      rows(7..8).height=20
      row(9).height=40
      row(10).height=25
      row(11).height=5
      row(12).height=120
      row(13).height=20
      row(14).height=80
      rows(15..17).height=20
      
      
      while a < b do
        a=+1
      end
    end
  end
  
  def table_ending
    data=[["#{I18n.t('exam.evaluate_course.prepared_by')} : BKMM ","#{I18n.t('exam.evaluate_course.date_updated')} : 5 DISEMBER 2011"]]
    table(data, :column_widths => [260,230], :cell_style => {:size=>10, :borders => [:left, :right, :top, :bottom]}) do
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
    draw_text "#{page_number} #{I18n.t('instructor_appraisal.from')} 2",  :size => 10, :at => [220,-5]
  end
  
end
