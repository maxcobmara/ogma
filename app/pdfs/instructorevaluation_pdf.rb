class InstructorevaluationPdf < Prawn::Document  
  def initialize(instructor_appraisal, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @appraisal  = instructor_appraisal
    @view = view
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
        draw_text "PPL APMM", :at => [80, 85], :style => :bold
        draw_text "#{I18n.t('instructor_appraisal.document_no').upcase}: BK-KKM-04-01", :at => [15, 70], :style => :bold
        draw_text "#{I18n.t('instructor_appraisal.form_title').upcase}", :at => [-25, 45], :style => :bold
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
    move_down 30
    table_main
    move_down 70
    table_signatory
    move_down 230
    table_ending
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def table_main
    ab=@appraisal
    arr_marks=[]
    arr_marks << ab.q1 << ab.q2 << ab.q3 << ab.q4 << ab.q5 << ab.q6 << ab.q7 << ab.q8 << ab.q9 << ab.q10 << ab.q11 << "" << ab.q12 << ab.q13 << ab.q14 << ab.q15 << ab.q16 << ab.q17 << ab.q18 << ab.q19 << ab.q20 << ab.q21 << ab.q22 << ab.q23 << ab.q24 << ab.q25 << ab.q26 << ab.q27 << ab.q28 << ab.q29 << ab.q30 << ab.q31 << ab.q32 << ab.q33 << ab.q34 << ab.q35 << ab.q36 << ab.q37 << ab.q38 << ab.q39 << ab.q40 << ab.q41 << ab.q42 << ab.q43 << ab.q44 << ab.q45 << ab.q46 << ab.q47 << ab.q48
    total_two=total_one=0
    for mark in arr_marks
      total_two+= mark.to_i if mark.to_i==2
      total_one+=mark.to_i if mark.to_i==1
    end
    
    @general_notes1="#{I18n.t('instructor_appraisal.general_notes1')}"
    @notes2="#{I18n.t('instructor_appraisal.notes2')}"
    @notes3="#{I18n.t('instructor_appraisal.notes3')}"
    @notes3a="#{I18n.t('instructor_appraisal.always_practice')} <br>#{I18n.t('instructor_appraisal.frequently_practice')}<br> #{I18n.t('instructor_appraisal.rarely_practice')}"
    @notes3b="- 2<br>- 1<br>- 0"
    @notes4="#{I18n.t('instructor_appraisal.notes4')}"
    @notes4a="90 #{I18n.t('instructor_appraisal.and_above')}                       <b>#{I18n.t('instructor_appraisal.good').upcase}</b><br>89-65                                     <b>#{I18n.t('instructor_appraisal.satisfactory').upcase}</b><br>64 #{I18n.t('instructor_appraisal.or_below')}                      <b>#{I18n.t('instructor_appraisal.unsatisfactory').upcase}</b>"
    @notes5="#{I18n.t('instructor_appraisal.notes5')}"
    @notes6="#{I18n.t('instructor_appraisal.notes6')}"
    
    data2=[[{content: "<u>#{I18n.t('instructor_appraisal.purpose').upcase}</u>", colspan: 7}],
          ["*", {content: @general_notes1, colspan: 6}], 
          ["*", {content: @notes2, colspan: 6}],
          ["*", {content: @notes3, colspan: 6}],
          ["", "*<br>*<br>*", @notes3a, {content: @notes3b, colspan: 4}],
          ["*", {content: @notes4, colspan: 6}],
          ["", "*<br>*<br>*", {content: @notes4a, colspan: 5}],
          ["*", {content: @notes5, colspan: 6}],
           ["*", {content: @notes6, colspan: 6}],["","","","","","",""]]
    table(data2, :column_widths => [25,15, 185,175, 40, 40, 40], :cell_style => {:size=>11, :borders => [:left, :right, :top, :bottom],  :inline_format => :true, :padding=>[2,5,3,5]}) do
      a = 0
      b = 1
      row(0).font_style=:bold
      row(0).borders=[:left, :top, :right]
      row(1..3).column(0).borders=[:left]
      row(1..3).column(1).borders=[:right]
      row(4).column(0).borders=[:left]
      row(4).column(1..2).borders=[]
      row(4).column(3).borders=[:right]
      row(5).column(0).borders=[:left]
      row(5).column(1).borders=[:right]
      row(6).column(0).borders=[:left]
      row(6).column(1..2).borders=[]
      row(6).column(2).borders=[:right]
      row(7..8).column(0).borders=[:left]
      row(7..8).column(1).borders=[:right]
      row(9).height=8
      row(9).column(1..5).borders=[]
      row(9).column(0).borders=[:left]
      row(9).column(6).borders=[:right]
      while a < b do
        a=+1
      end
    end
    
    data=[[{content: "SIRI", colspan: 2},{content: "#{I18n.t('instructor_appraisal.question').upcase}", colspan: 2},"2","1","0"]]
    
    cnt=0  
    @appraisal.data.each do |k, v|
      if cnt==11
        data << [{content: "", colspan: 7}]
      end
      question=I18n.t('instructor_appraisal'+".q#{cnt+=1}")
      vi=v.to_i
      data <<  [{content: "#{cnt}", colspan: 2},{content: question, colspan: 2},"#{vi==2 ? '<b>2</b>' : '2'}","#{vi==1 ? '<b>1</b>' : '1'}","#{vi==0 ? '<b>0</b>' : 0}"]
    end
    
    
    #data << [{content: "1", colspan: 2},{content: I18n.t('instructor_appraisal'+".q#{cnt}"), colspan: 2},"#{@appraisal.q1.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q1.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q1.to_i==0 ? '<b>0</b>' : 0}"]
    #data << [{content: "2", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q2')}", colspan: 2},"#{@appraisal.q2.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q2.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q2.to_i==0 ? '<b>0</b>' : 0}"]
    #data << [{content: "3", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q3')}", colspan: 2},"#{@appraisal.q3.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q3.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q3.to_i==0 ? '<b>0</b>' : 0}"]
    #data << [{content: "4", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q4')}", colspan: 2},"#{@appraisal.q4.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q4.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q4.to_i==0 ? '<b>0</b>' : 0}"]
    #data << [{content: "5", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q5')}", colspan: 2},"#{@appraisal.q5.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q5.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q5.to_i==0 ? '<b>0</b>' : 0}"]
    #data << [{content: "6", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q6')}", colspan: 2},"#{@appraisal.q6.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q6.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q6.to_i==0 ? '<b>0</b>' : 0}"]
    #data << [{content: "7", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q7')}", colspan: 2},"#{@appraisal.q7.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q7.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q7.to_i==0 ? '<b>0</b>' : 0}"]
    #data << [{content: "8", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q8')}", colspan: 2},"#{@appraisal.q8.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q8.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q8.to_i==0 ? '<b>0</b>' : 0}"]
    #data << [{content: "9", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q9')}", colspan: 2},"#{@appraisal.q9.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q9.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q9.to_i==0 ? '<b>0</b>' : 0}"]
    #data << [{content: "10", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q10')}", colspan: 2},"#{@appraisal.q10.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q10.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q10.to_i==0 ? '<b>0</b>' : 0}"]
    ###
    #data << [{content: "11", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q11')}", colspan: 2},"#{@appraisal.q11.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q11.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q11.to_i==0 ? '<b>0</b>' : 0}"]
    
#     data << [{content: "", colspan: 7}]
#     data << [{content: "12", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q12')}", colspan: 2},"#{@appraisal.q12.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q12.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q12.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "13", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q13')}", colspan: 2},"#{@appraisal.q13.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q13.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q13.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "14", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q14')}", colspan: 2},"#{@appraisal.q14.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q14.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q14.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "15", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q15')}", colspan: 2},"#{@appraisal.q15.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q15.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q15.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "16", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q16')}", colspan: 2},"#{@appraisal.q16.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q16.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q16.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "17", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q17')}", colspan: 2},"#{@appraisal.q17.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q17.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q17.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "18", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q18')}", colspan: 2},"#{@appraisal.q18.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q18.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q18.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "19", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q19')}", colspan: 2},"#{@appraisal.q19.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q19.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q19.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "20", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q20')}", colspan: 2},"#{@appraisal.q20.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q20.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q20.to_i==0 ? '<b>0</b>' : 0}"]
#     
#     
#     data << [{content: "21", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q21')}", colspan: 2},"#{@appraisal.q21.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q21.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q21.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "22", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q22')}", colspan: 2},"#{@appraisal.q22.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q22.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q22.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "23", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q23')}", colspan: 2},"#{@appraisal.q23.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q23.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q23.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "24", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q24')}", colspan: 2},"#{@appraisal.q24.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q24.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q24.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "25", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q25')}", colspan: 2},"#{@appraisal.q25.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q25.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q25.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "26", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q26')}", colspan: 2},"#{@appraisal.q26.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q26.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q26.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "27", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q27')}", colspan: 2},"#{@appraisal.q27.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q27.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q27.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "28", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q28')}", colspan: 2},"#{@appraisal.q28.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q28.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q28.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "29", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q29')}", colspan: 2},"#{@appraisal.q29.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q29.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q29.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "30", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q30')}", colspan: 2},"#{@appraisal.q30.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q30.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q30.to_i==0 ? '<b>0</b>' : 0}"]
#     
#     data << [{content: "31", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q31')}", colspan: 2},"#{@appraisal.q31.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q31.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q31.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "32", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q32')}", colspan: 2},"#{@appraisal.q32.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q32.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q32.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "33", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q33')}", colspan: 2},"#{@appraisal.q33.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q33.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q33.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "34", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q34')}", colspan: 2},"#{@appraisal.q34.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q34.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q34.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "35", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q35')}", colspan: 2},"#{@appraisal.q35.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q35.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q35.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "36", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q36')}", colspan: 2},"#{@appraisal.q36.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q36.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q36.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "37", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q37')}", colspan: 2},"#{@appraisal.q37.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q37.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q37.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "38", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q38')}", colspan: 2},"#{@appraisal.q38.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q38.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q38.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "39", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q39')}", colspan: 2},"#{@appraisal.q39.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q39.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q39.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "40", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q40')}", colspan: 2},"#{@appraisal.q40.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q40.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q40.to_i==0 ? '<b>0</b>' : 0}"]
#     
#     data << [{content: "41", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q41')}", colspan: 2},"#{@appraisal.q41.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q41.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q41.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "42", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q42')}", colspan: 2},"#{@appraisal.q42.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q42.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q42.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "43", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q43')}", colspan: 2},"#{@appraisal.q43.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q43.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q43.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "44", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q44')}", colspan: 2},"#{@appraisal.q44.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q44.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q44.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "45", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q45')}", colspan: 2},"#{@appraisal.q45.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q45.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q45.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "46", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q46')}", colspan: 2},"#{@appraisal.q46.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q46.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q46.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "47", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q47')}", colspan: 2},"#{@appraisal.q47.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q47.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q47.to_i==0 ? '<b>0</b>' : 0}"]
#     data << [{content: "48", colspan: 2},{content: "#{I18n.t('instructor_appraisal.q48')}", colspan: 2},"#{@appraisal.q48.to_i==2 ? '<b>2</b>' : '2'}","#{@appraisal.q48.to_i==1 ? '<b>1</b>' : '1'}","#{@appraisal.q48.to_i==0 ? '<b>0</b>' : 0}"]
    
    data << ["","","","#{I18n.t('instructor_appraisal.total').upcase}", total_two, total_one, "0"]
    
    table(data, :header => true, :column_widths => [25,15, 190,185, 35, 35, 35], :cell_style => {:size=>11, :borders => [:left, :right, :top, :bottom],  :inline_format => :true, :padding=>[2,5,3,5]}) do
      a = 0
      b = 1
      row(12).height=30
      row(12).borders=[]
      row(50).column(0..2).borders=[]
      row(50).column(3).borders=[:right]
      row(50).column(4..6).borders=[:left, :right, :bottom]
      row(50).column(3).style :align => :right
      row(50).column(3..6).font_style=:bold
       
      row(0).font_style=:bold
      rows(0).background_color = 'F0F0F0'
      row(0).style :align => :center
      column(0).rows(1..49).style :align => :center
      column(4..6).rows(1..50).style :align => :center
      column(0).rows(1..49).style :valign => :center
      column(4..6).rows(1..50).style :valign => :center
      row(1..4).height=30
      row(6..7).height=30
      row(11).height=30
      row(13..15).height=30
      row(17..18).height=30
      row(20..22).height=30
      row(25).height=30
      row(28).height=30
      row(30).height=30
      row(32).height=30
      row(34).height=30
      row(38).height=30
      row(40).height=30
      row(44..48).height=30
      
      rowno=1
      0.upto(48).each do |cnt|
        if arr_marks[cnt]==2
          row(rowno+cnt).column(5..6).text_color = 'E5E5E5'
        elsif arr_marks[cnt]==1
          row(rowno+cnt).column(4).text_color = 'E5E5E5'
          row(rowno+cnt).column(6).text_color = 'E5E5E5'
        elsif arr_marks[cnt]==0
          row(rowno+cnt).column(4..5).text_color = 'E5E5E5'
        end
      end
      
      while a < b do
        a=+1
      end
    end
    
    move_down 30
    totalmarks=@appraisal.total_mark#(arr_marks-[""]).sum
    data3=[["", ">= 90", "89 - 65", "&lt; 64"], 
          ["#{I18n.t('instructor_appraisal.total_score1').upcase}<br>#{I18n.t('instructor_appraisal.total_score2').upcase}", "#{totalmarks if totalmarks >= 90}", "#{totalmarks if totalmarks > 64 && totalmarks <90 }", "#{totalmarks if totalmarks < 65}"]]
    table(data3, :column_widths => [100, 50, 50, 50], :cell_style => {:size=>11, :borders => [], :inline_format => :true}, :position => :center) do
      a=0
      b=1
      row(0).column(0).borders=[]
      row(0).column(1..3).borders=[:left, :right, :top]
      row(1).borders=[:left, :right, :top, :bottom]
      rows(0..1).style :align => :center
      rows(0..1).font_style = :bold
      row(1).style :valign => :center
      row(1).column(0).background_color = 'F0F0F0'
      while a < b do
        a=+1
      end
    end
    
  end
  
  def table_signatory
    data=[["#{I18n.t('instructor_appraisal.date2').upcase}: <u>#{@appraisal.appraisal_date.try(:strftime, '%d-%m-%Y')}</u>", "#{I18n.t('instructor_appraisal.signatory').upcase}: ..............................................."], ["", "#{I18n.t('instructor_appraisal.name')}: <u>#{@appraisal.instructor.name}</u>"], ["", "#{I18n.t('instructor_appraisal.rank').upcase}: <u>#{@appraisal.instructor.rank.try(:name)}</u>"]]
    table(data, :column_widths => [255, 255],  :cell_style => {:size=>11, :borders => [], :inline_format => :true})
  end
  
  def table_ending
    data=[["#{I18n.t('instructor_appraisal.prepared').upcase}: BKKM","#{I18n.t('exam.evaluate_course.date_updated')} : #{@appraisal.updated_at.try(:strftime, '%d-%m-%Y')} "]]
    table(data, :column_widths => [310,200], :cell_style => {:size=>11, :borders => [:left, :right, :top, :bottom]}) do
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
    draw_text "#{page_number} #{I18n.t('instructor_appraisal.from')} 3",  :size => 8, :at => [240,-5]
  end
  
end
