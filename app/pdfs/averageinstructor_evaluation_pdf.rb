class Averageinstructor_evaluationPdf < Prawn::Document  
  def initialize(average_instructor, view, college)
    super({top_margin: 40, left_margin: 55, page_size: 'A4', page_layout: :portrait })
    @average_instructor  = average_instructor
    @view = view
    font "Helvetica"
    if college.code=="kskbjb"
      move_down 10
    end
    bounding_box([0,770], :width => 400, :height => 100) do |y2|
      if college.code=="kskbjb"
         move_down 5
         image "#{Rails.root}/app/assets/images/logo_kerajaan.png",  :width =>97.2, :height =>77.76
      else
        move_down 5
        image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :scale => 0.65
      end
    end
    bounding_box([150,750], :width => 350, :height => 100) do |y2|
      if college.code=="kskbjb"
        move_down 30
        text "#{college.name}"
        move_down 1
        text "#{I18n.t('exam.evaluate_course.title')}"
      else
        draw_text "PPL APMM", :at => [70, 105], :style => :bold
        draw_text "#{I18n.t('instructor_appraisal.document_no').upcase}: BK-KKM-04-02", :at => [15, 90], :style => :bold
        draw_text "#{I18n.t('average_instructor.form_title1').upcase}", :at => [0, 65], :style => :bold
	draw_text "#{I18n.t('average_instructor.form_title2').upcase}", :at => [25, 50], :style => :bold
      end
    end
    
    if college.code=="kskbjb"
      bounding_box([400,750], :width => 400, :height => 100) do |y2|
        image "#{Rails.root}/app/assets/images/kskb_logo-6.png",  :width =>97.2, :height =>77.76
      end
    else
      bounding_box([430,770], :width => 400, :height => 90) do |y2|
        image "#{Rails.root}/app/assets/images/amsas_logo_small.png", :scale => 0.75
      end
    end
    
    table_info
    stroke_details
    table_legend
    move_down 5
    table_a_heading
    move_down 10
    table_a_content
    start_new_page
    move_down 30
    table_b_heading
    move_down 10
    table_b_content
    move_down 30
    table_c_heading
    move_down 10
    table_c_content
    move_down 30
    table_d_heading
    move_down 10
    table_d_content
    start_new_page
    table_e_heading
    move_down 10
    table_e_content
    move_down 20
    table_summary
    move_down 20
    table_score_legend
    table_review
    table_signatory
    move_down 30
    table_ending
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def table_info
    data =[["#{I18n.t('average_instructor.programme_id')}", ": ",{ content: "#{@average_instructor.programme.programme_list}", colspan: 3}],
    ["#{I18n.t('average_instructor.instructor_id')}", ": ",{content: "#{@average_instructor.instructor.staff_with_rank}", colspan: 3}], 
    ["#{I18n.t('average_instructor.evaluate_date')}",": ", {content: "#{@average_instructor.evaluate_date.try(:strftime,'%d-%m-%Y')} ", colspan: 3}],
    ["#{I18n.t('average_instructor.title2')}",": ", {content: "#{@average_instructor.title} ", colspan: 3}],
    ["#{I18n.t('average_instructor.objective')}", ": ","#{@average_instructor.display_objective[0]}", {content: "#{I18n.t('average_instructor.time')}: ", colspan: 2}],
           ["",": ","#{@average_instructor.display_objective[1]}","",""],
           ["",": ","#{@average_instructor.display_objective[2]}","#{I18n.t('average_instructor.start_at')}","#{@average_instructor.start_at.try(:strftime, '%H:%M')}"],
           ["",": ","#{@average_instructor.display_objective[3]}","#{I18n.t('average_instructor.end_at')}","#{@average_instructor.end_at.try(:strftime, '%H:%M')}"],
           ["",": ","#{@average_instructor.display_objective[4]}","#{I18n.t('average_instructor.duration')}","#{@average_instructor.duration}"],
           ["#{I18n.t('average_instructor.delivery_type')}","#{@average_instructor.display_delivery} ","T : Teori     P : Praktikal     L  Lain-lain","",""]
    ]
    table(data, :column_widths => [95,20, 235, 80, 60],  :cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding=>[5,0,5,5]}) do
      row(0).columns(0..1).borders=[:top]
      row(0).column(0).borders=[:left, :top]
      row(0).column(2).borders=[:right, :top]
      row(1..8).column(0).borders=[:left]
      row(1..3).column(2).borders=[:right]
      row(4).column(3).borders=[:right] #masa row
      row(5..8).column(4).borders=[:right]
      #row(6..8).column(2).borders=[:left, :right]
      row(9).column(0).borders=[:left, :bottom]
      row(9).column(4).borders=[:right, :bottom]
      column(1).style :align => :right
      row(9).column(2).style :align => :center
      row(9).column(1..3).borders=[:bottom]
    end
  end
  
  def stroke_details
    #lines use for table_info
    stroke do
	horizontal_line 120, 475, :at => 660 #kursus #135, 505, :at => 660
	horizontal_line 120, 475, :at => 640 #637 #jurulatih
	horizontal_line 120, 475, :at => 617 #614 #tarikh
	horizontal_line 120, 475, :at => 594 #591 #tajuk
	horizontal_line 120, 330, :at => 573 #568 #objektif
	horizontal_line 120, 330, :at => 552 #545
	horizontal_line 120, 330, :at => 530 #522
	horizontal_line 120, 330, :at => 508 #499
	horizontal_line 120, 330, :at => 487 #476
	
	#time box
	horizontal_line 390, 475, :at => 573 # 420, 505, :at =>568 #masa
	horizontal_line 350, 470, :at => 552 #380, 500, :at =>540
	horizontal_line 350, 470, :at => 530 #520
	horizontal_line 350, 470, :at => 508 #495
	horizontal_line 350, 470, :at => 487 #475
	vertical_line 552, 487, :at => 350 #475, 541, :at => 380
	vertical_line 552, 487, :at => 425
	vertical_line 552, 487, :at => 470
	
	#delivery_type box
	horizontal_line 100, 125, :at => 481 #115, 140, :at => 470
	horizontal_line 100, 125, :at => 468 #115, 140, :at => 455
	vertical_line 468, 481, :at => 100 #455, 470, :at => 115
	vertical_line 468, 481, :at => 125 #455, 470, :at => 140  
    end
  end
  
  def table_legend
    move_down 5
    text "1. #{I18n.t('average_instructor.instrument')}", :size => 10
    move_down 5
    data_legend=[["","#{I18n.t('average_instructor.dimension')}", "#{I18n.t('average_instructor.weightage2')}"], ["", "A. #{I18n.t('average_instructor.preparation').upcase}", "25%"], 
          ["", "B. #{I18n.t('average_instructor.delivery.').upcase}", "30%"], ["", "C. #{I18n.t('average_instructor.usage').upcase}", "5%"], ["", "D. #{I18n.t('average_instructor.verification').upcase}", "20%"],["", "E. #{I18n.t('average_instructor.general_teaching_technique').upcase}","20%"]]
     table(data_legend, :column_widths => [30, 190, 90],  :position => :left, :cell_style => {:size=>10, :borders => [:top, :bottom, :left, :right], :inline_format => :true, :padding => [1,0,2,5]}) do
       row(0).column(2).style :align => :center
       row(1..5).column(2).style :align => :center
       row(0..5).column(0).borders=[:right]
     end
     move_down 5
     
     data_legend2=[["#{I18n.t('average_instructor.instructions')}"],["1. #{I18n.t('average_instructor.instruction1')}"],["2. #{I18n.t('average_instructor.instruction2')}"]]
     table(data_legend2, :column_widths => [500], :cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding => [0,2,1,5]}) do
       row(0).borders=[:top, :left ,:right]
       row(1).borders=[:left, :right]
       row(2).borders=[:bottom, :left, :right]
     end
     move_down 5
     
     data_legend3=[["#{I18n.t('average_instructor.scale')}", "5. #{I18n.t('average_instructor.excellent')}", "4. #{I18n.t('average_instructor.good')}", "3. #{I18n.t('average_instructor.average')}", "2. #{I18n.t('average_instructor.weak')}", "1. #{I18n.t('average_instructor.very_weak')}"]]
     table(data_legend3, :column_widths => [100, 90,60,80,80, 90],  :position => :left, :cell_style => {:size=>10, :borders => [:top, :bottom, :left, :right], :inline_format => :true, :padding => [2,2,2,5]}) do
       row(0).background_color = 'F0F0F0'
       row(0).font_style=:bold
     end
     move_down 5
  end
  
  def table_a_heading
    data=[["#{I18n.t('average_instructor.part').upcase} A :", "#{I18n.t('average_instructor.preparation').upcase}", {content: "#{I18n.t('average_instructor.score').upcase}", colspan: 5}, "#{I18n.t('average_instructor.review').upcase}"], ["","","5","4","3","2","1", ""]]
    table(data, :column_widths => [135,140,20,20,20,20,20,125],  :cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding => [0,0,0,5]}) do
      row(0..1).font_style=:bold
      row(0).column(0).borders=[:top, :left]
      row(1).column(0).borders=[:bottom, :left]
      row(0).column(1).borders=[:top]
      row(1).column(1).borders=[:bottom]
      row(0).column(2).borders=[:top, :left, :right] #skor
      row(1).column(2..6).borders=[:left, :right, :top, :bottom] #5,4,3,2,1
      row(0).column(7).borders=[:top, :right] #ulasan
      row(1).column(7).borders=[:bottom, :right]
      row(0).column(2).style :align => :center #skor
      row(1).column(2..6).style :align => :center #5,4,3,2,1
      row(0).column(7).style :align => :center
    end
  end
  
  def table_b_heading
    data=[["#{I18n.t('average_instructor.part').upcase} B :", "#{I18n.t('average_instructor.delivery').upcase}", {content: "#{I18n.t('average_instructor.score').upcase}", colspan: 5}, "#{I18n.t('average_instructor.review').upcase}"], ["","","5","4","3","2","1", ""]]
    table(data, :column_widths => [135,140,20,20,20,20,20,125],  :cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding => [0,0,0,5]}) do
      row(0..1).font_style=:bold
      row(0).column(0).borders=[:top, :left]
      row(1).column(0).borders=[:bottom, :left]
      row(0).column(1).borders=[:top]
      row(1).column(1).borders=[:bottom]
      row(0).column(2).borders=[:top, :left, :right] #skor
      row(1).column(2..6).borders=[:left, :right, :top, :bottom] #5,4,3,2,1
      row(0).column(7).borders=[:top, :right] #ulasan
      row(1).column(7).borders=[:bottom, :right]
      row(0).column(2).style :align => :center #skor
      row(1).column(2..6).style :align => :center #5,4,3,2,1
      row(0).column(7).style :align => :center
    end
  end
  
  def table_c_heading
    data=[["#{I18n.t('average_instructor.part').upcase} C :", "#{I18n.t('average_instructor.usage').upcase}", {content: "#{I18n.t('average_instructor.score').upcase}", colspan: 5}, "#{I18n.t('average_instructor.review').upcase}"], ["","","5","4","3","2","1", ""]]
    table(data, :column_widths => [135,140,20,20,20,20,20,125],  :cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding => [0,0,0,5]}) do
      row(0..1).font_style=:bold
      row(0).column(0).borders=[:top, :left]
      row(1).column(0).borders=[:bottom, :left]
      row(0).column(1).borders=[:top]
      row(1).column(1).borders=[:bottom]
      row(0).column(2).borders=[:top, :left, :right] #skor
      row(1).column(2..6).borders=[:left, :right, :top, :bottom] #5,4,3,2,1
      row(0).column(7).borders=[:top, :right] #ulasan
      row(1).column(7).borders=[:bottom, :right]
      row(0).column(2).style :align => :center #skor
      row(1).column(2..6).style :align => :center #5,4,3,2,1
      row(0).column(7).style :align => :center
    end
  end
  
  def table_d_heading
    data=[["#{I18n.t('average_instructor.part').upcase} D :", "#{I18n.t('average_instructor.verification').upcase}", {content: "#{I18n.t('average_instructor.score').upcase}", colspan: 5}, "#{I18n.t('average_instructor.review').upcase}"], ["","","5","4","3","2","1", ""]]
    table(data, :column_widths => [135,140,20,20,20,20,20,125],  :cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding => [0,0,0,5]}) do
      row(0..1).font_style=:bold
      row(0).column(0).borders=[:top, :left]
      row(1).column(0).borders=[:bottom, :left]
      row(0).column(1).borders=[:top]
      row(1).column(1).borders=[:bottom]
      row(0).column(2).borders=[:top, :left, :right] #skor
      row(1).column(2..6).borders=[:left, :right, :top, :bottom] #5,4,3,2,1
      row(0).column(7).borders=[:top, :right] #ulasan
      row(1).column(7).borders=[:bottom, :right]
      row(0).column(2).style :align => :center #skor
      row(1).column(2..6).style :align => :center #5,4,3,2,1
      row(0).column(7).style :align => :center
    end
  end
  
  def table_e_heading
    data=[["#{I18n.t('average_instructor.part').upcase} E :", "#{I18n.t('average_instructor.general_teaching_technique').upcase}", {content: "#{I18n.t('average_instructor.score').upcase}", colspan: 5}, "#{I18n.t('average_instructor.review').upcase}"], ["","","5","4","3","2","1", ""]]
    table(data, :column_widths => [135,140,20,20,20,20,20,125],  :cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding => [0,0,0,5]}) do
      row(0..1).font_style=:bold
      row(0).column(0).borders=[:top, :left]
      row(1).column(0).borders=[:bottom, :left]
      row(0).column(1).borders=[:top]
      row(1).column(1).borders=[:bottom]
      row(0).column(2).borders=[:top, :left, :right] #skor
      row(1).column(2..6).borders=[:left, :right, :top, :bottom] #5,4,3,2,1
      row(0).column(7).borders=[:top, :right] #ulasan
      row(1).column(7).borders=[:bottom, :right]
      row(0).column(2).style :align => :center #skor
      row(1).column(2..6).style :align => :center #5,4,3,2,1
      row(0).column(7).style :align => :center
    end
  end
  
  def table_a_content
    data_a1=[[{content: "#{I18n.t('average_instructor.before_session')}", colspan: 8} ],
         ["1.", "#{I18n.t('average_instructor.pbq1')}", "#{@average_instructor.pbq1==5? '/' : ''}","#{@average_instructor.pbq1==4? '  /' : ''}","#{@average_instructor.pbq1==3? '/' : ''}","#{@average_instructor.pbq1==2? '/' : ''}","#{@average_instructor.pbq1==1? '/' : ''}", @average_instructor.pbq1review],[{content: "", colspan: 8}],
         ["2.", "#{I18n.t('average_instructor.pbq2')}", "#{@average_instructor.pbq2==5? '/' : ''}","#{@average_instructor.pbq2==4? '  /' : ''}","#{@average_instructor.pbq2==3? '/' : ''}","#{@average_instructor.pbq2==2? '/' : ''}","#{@average_instructor.pbq2==1? '/' : ''}", @average_instructor.pbq2review],[{content: "", colspan: 8}],
         ["3.", "#{I18n.t('average_instructor.pbq3')}", "#{@average_instructor.pbq3==5? '/' : ''}","#{@average_instructor.pbq3==4? '  /' : ''}","#{@average_instructor.pbq3==3? '/' : ''}","#{@average_instructor.pbq3==2? '/' : ''}","#{@average_instructor.pbq3==1? '/' : ''}", @average_instructor.pbq3review],[{content: "", colspan: 8}],
         ["4.", "#{I18n.t('average_instructor.pbq4')}", "#{@average_instructor.pbq4==5? '/' : ''}","#{@average_instructor.pbq4==4? '  /' : ''}","#{@average_instructor.pbq4==3? '/' : ''}","#{@average_instructor.pbq4==2? '/' : ''}","#{@average_instructor.pbq4==1? '/' : ''}", @average_instructor.pbq4review],[{content: "", colspan: 8}]
          ]
    data_a2=[[{content: "#{I18n.t('average_instructor.during_session')}", colspan: 8} ],
         ["1.", "#{I18n.t('average_instructor.pdq1')}", "#{@average_instructor.pdq1==5? '/' : ''}","#{@average_instructor.pdq1==4? '  /' : ''}","#{@average_instructor.pdq1==3? '/' : ''}","#{@average_instructor.pdq1==2? '/' : ''}","#{@average_instructor.pdq1==1? '/' : ''}", @average_instructor.pdq1review],[{content: "", colspan: 8}],
         ["2.", "#{I18n.t('average_instructor.pdq2')}", "#{@average_instructor.pdq2==5? '/' : ''}","#{@average_instructor.pdq2==4? '  /' : ''}","#{@average_instructor.pdq2==3? '/' : ''}","#{@average_instructor.pdq2==2? '/' : ''}","#{@average_instructor.pdq2==1? '/' : ''}", @average_instructor.pdq2review],[{content: "", colspan: 8}],
         ["3.", "#{I18n.t('average_instructor.pdq3')}", "#{@average_instructor.pdq3==5? '/' : ''}","#{@average_instructor.pdq3==4? '  /' : ''}","#{@average_instructor.pdq3==3? '/' : ''}","#{@average_instructor.pdq3==2? '/' : ''}","#{@average_instructor.pdq3==1? '/' : ''}", @average_instructor.pdq3review],[{content: "", colspan: 8}],
         ["4.", "#{I18n.t('average_instructor.pdq4')}", "#{@average_instructor.pdq4==5? '/' : ''}","#{@average_instructor.pdq4==4? '  /' : ''}","#{@average_instructor.pdq4==3? '/' : ''}","#{@average_instructor.pdq4==2? '/' : ''}","#{@average_instructor.pdq4==1? '/' : ''}", @average_instructor.pdq4review],[{content: "", colspan: 8}],
         ["5.", "#{I18n.t('average_instructor.pdq5')}", "#{@average_instructor.pdq5==5? '/' : ''}","#{@average_instructor.pdq5==4? '  /' : ''}","#{@average_instructor.pdq5==3? '/' : ''}","#{@average_instructor.pdq5==2? '/' : ''}","#{@average_instructor.pdq5==1? '/' : ''}", @average_instructor.pdq5review],[{content: "", colspan: 8}],
         [{content: "#{I18n.t('average_instructor.obtained_score')}", colspan: 2}, "",{content:"#{@average_instructor.marks_a} / 45", colspan: 3},"", ""],[{content: "", colspan: 8}]
          ]
    data=data_a1+data_a2
    table(data, :column_widths => [20, 255, 20,20,20,20,20, 125],:cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding => [0,0,0,0], :padding=> [2,0,2,5]}) do
      row(1..8).column(2..6).borders=[:top,:left, :bottom, :right] #score boxes
      row(0..18).column(0).borders=[:left]
      row(0).column(0).borders=[:left,:right, :top]
      row(0).column(0).font_style=:bold #sebelum mengajar
      row(1).column(7).borders=[:right]
      row(2).column(0).borders=[:left, :right]
      row(3).column(7).borders=[:right]
      row(4).column(0).borders=[:left, :right]
      row(5).column(7).borders=[:right]
      row(6).column(0).borders=[:left, :right]
      row(7).column(7).borders=[:right]
      row(8).column(0).borders=[:left, :right]
      row(9).column(0).borders=[:left, :right]
      row(9).column(0).font_style=:bold #semasa mengajar
      row(10).column(7).borders=[:right]
      row(11).column(0).borders=[:left, :right]
      row(12).column(7).borders=[:right]
      row(13).column(0).borders=[:left, :right]
      row(14).column(7).borders=[:right]
      row(15).column(0).borders=[:left, :right]
      row(16).column(7).borders=[:right]
      row(17).column(0).borders=[:left, :right]
      row(18).column(7).borders=[:right]
      row(10..18).column(2..6).borders=[:top,:left, :bottom, :right] #score boxes
      row(19).column(0).borders=[:left, :right] #before total score line
      row(20).column(0).style :align => :right #total score line
      row(20).column(0).borders=[:left]
      row(20).column(3).borders=[:left, :right, :top, :bottom]
      row(20).column(7).borders=[:right]
      row(21).column(0).borders=[:bottom, :left, :right]
    end
  end 
 
  def table_b_content
    data_a1=[[{content: "", colspan: 8} ],
         ["1.", "#{I18n.t('average_instructor.dq1')}", "#{@average_instructor.dq1==5? '/' : ''}","#{@average_instructor.dq1==4? '  /' : ''}","#{@average_instructor.dq1==3? '/' : ''}","#{@average_instructor.dq1==2? '/' : ''}","#{@average_instructor.dq1==1? '/' : ''}", @average_instructor.dq1review],[{content: "", colspan: 8}],
         ["2.", "#{I18n.t('average_instructor.dq2')}", "#{@average_instructor.dq2==5? '/' : ''}","#{@average_instructor.dq2==4? '  /' : ''}","#{@average_instructor.dq2==3? '/' : ''}","#{@average_instructor.dq2==2? '/' : ''}","#{@average_instructor.dq2==1? '/' : ''}", @average_instructor.dq2review],[{content: "", colspan: 8}],
         ["3.", "#{I18n.t('average_instructor.dq3')}", "#{@average_instructor.dq3==5? '/' : ''}","#{@average_instructor.dq3==4? '  /' : ''}","#{@average_instructor.dq3==3? '/' : ''}","#{@average_instructor.dq3==2? '/' : ''}","#{@average_instructor.dq3==1? '/' : ''}", @average_instructor.dq3review],[{content: "", colspan: 8}],
         ["4.", "#{I18n.t('average_instructor.dq4')}", "#{@average_instructor.dq4==5? '/' : ''}","#{@average_instructor.dq4==4? '  /' : ''}","#{@average_instructor.dq4==3? '/' : ''}","#{@average_instructor.dq4==2? '/' : ''}","#{@average_instructor.dq4==1? '/' : ''}", @average_instructor.dq4review],[{content: "", colspan: 8}]
          ]
    data_a2=[
         ["5.", "#{I18n.t('average_instructor.dq5')}", "#{@average_instructor.dq5==5? '/' : ''}","#{@average_instructor.dq5==4? '  /' : ''}","#{@average_instructor.dq5==3? '/' : ''}","#{@average_instructor.dq5==2? '/' : ''}","#{@average_instructor.dq5==1? '/' : ''}", @average_instructor.dq5review],[{content: "", colspan: 8}],
         ["6.", "#{I18n.t('average_instructor.dq6')}", "#{@average_instructor.dq6==5? '/' : ''}","#{@average_instructor.dq6==4? '  /' : ''}","#{@average_instructor.dq6==3? '/' : ''}","#{@average_instructor.dq6==2? '/' : ''}","#{@average_instructor.dq6==1? '/' : ''}", @average_instructor.dq6review],[{content: "", colspan: 8}],
         ["7.", "#{I18n.t('average_instructor.dq7')}", "#{@average_instructor.dq7==5? '/' : ''}","#{@average_instructor.dq7==4? '  /' : ''}","#{@average_instructor.dq7==3? '/' : ''}","#{@average_instructor.dq7==2? '/' : ''}","#{@average_instructor.dq7==1? '/' : ''}", @average_instructor.dq7review],[{content: "", colspan: 8}],
         ["8.", "#{I18n.t('average_instructor.dq8')}", "#{@average_instructor.dq8==5? '/' : ''}","#{@average_instructor.dq8==4? '  /' : ''}","#{@average_instructor.dq8==3? '/' : ''}","#{@average_instructor.dq8==2? '/' : ''}","#{@average_instructor.dq8==1? '/' : ''}", @average_instructor.dq8review],[{content: "", colspan: 8}],
         ["9.", "#{I18n.t('average_instructor.dq9')}", "#{@average_instructor.dq9==5? '/' : ''}","#{@average_instructor.dq9==4? '  /' : ''}","#{@average_instructor.dq9==3? '/' : ''}","#{@average_instructor.dq9==2? '/' : ''}","#{@average_instructor.dq9==1? '/' : ''}", @average_instructor.dq9review],[{content: "", colspan: 8}],
         
         ["10.", "#{I18n.t('average_instructor.dq10')}", "#{@average_instructor.dq10==5? '/' : ''}","#{@average_instructor.dq10==4? '  /' : ''}","#{@average_instructor.dq10==3? '/' : ''}","#{@average_instructor.dq10==2? '/' : ''}","#{@average_instructor.dq10==1? '/' : ''}", @average_instructor.dq10review],[{content: "", colspan: 8}],
         ["11.", "#{I18n.t('average_instructor.dq11')}", "#{@average_instructor.dq11==5? '/' : ''}","#{@average_instructor.dq11==4? '  /' : ''}","#{@average_instructor.dq11==3? '/' : ''}","#{@average_instructor.dq11==2? '/' : ''}","#{@average_instructor.dq11==1? '/' : ''}", @average_instructor.dq11review],[{content: "", colspan: 8}],
         ["12.", "#{I18n.t('average_instructor.dq12')}", "#{@average_instructor.dq12==5? '/' : ''}","#{@average_instructor.dq12==4? '  /' : ''}","#{@average_instructor.dq12==3? '/' : ''}","#{@average_instructor.dq12==2? '/' : ''}","#{@average_instructor.dq12==1? '/' : ''}", @average_instructor.dq12review],[{content: "", colspan: 8}], [{content: "#{I18n.t('average_instructor.obtained_score')}", colspan: 2}, "",{content:"#{@average_instructor.marks_b} / 60", colspan: 3},"", ""],[{content: "", colspan: 8}],
          ]
    data=data_a1+data_a2
    table(data, :column_widths => [20, 255, 20,20,20,20,20, 125],:cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding => [0,0,0,0], :padding=> [2,0,2,5]}) do
      row(1..8).column(2..6).borders=[:top,:left, :bottom, :right] #score boxes
      row(0..23).column(0).borders=[:left]
      row(0).column(0).borders=[:left,:right, :top]
      row(1).column(7).borders=[:right]
      row(2).column(0).borders=[:left, :right]
      row(3).column(7).borders=[:right]
      row(4).column(0).borders=[:left, :right]
      row(5).column(7).borders=[:right]
      row(6).column(0).borders=[:left, :right]
      row(7).column(7).borders=[:right]
      row(8).column(0).borders=[:left, :right]
      row(9).column(7).borders=[:right]
      row(10).column(0).borders=[:left, :right]
      row(11).column(7).borders=[:right]
      row(12).column(0).borders=[:left, :right]
      row(13).column(7).borders=[:right]
      row(14).column(0).borders=[:left, :right]
      row(15).column(7).borders=[:right]
      row(16).column(0).borders=[:left, :right]
      row(17).column(7).borders=[:right]
      row(18).column(0).borders=[:left, :right]
      row(19).column(7).borders=[:right]
      row(20).column(0).borders=[:left, :right]
      row(21).column(7).borders=[:right]
      row(22).column(0).borders=[:left, :right]
      row(23).column(7).borders=[:right]
      row(9..23).column(2..6).borders=[:top,:left, :bottom, :right] #score boxes
      row(24).column(0).borders=[:left, :right] #before total score line
      row(25).column(0).style :align => :right #total score line
      row(25).column(0).borders=[:left]
      row(25).column(3).borders=[:left, :right, :top, :bottom]
      row(25).column(7).borders=[:right]
      row(26).column(0).borders=[:bottom, :left, :right]
    end
  end 
  
  def table_c_content
    data=[[{content: "", colspan: 8}],
         ["1.", "#{I18n.t('average_instructor.uq1')}", "#{@average_instructor.uq1==5? '/' : ''}","#{@average_instructor.uq1==4? '  /' : ''}","#{@average_instructor.uq1==3? '/' : ''}","#{@average_instructor.uq1==2? '/' : ''}","#{@average_instructor.uq1==1? '/' : ''}", @average_instructor.uq1review],[{content: "", colspan: 8}],
         ["2.", "#{I18n.t('average_instructor.uq2')}", "#{@average_instructor.uq2==5? '/' : ''}","#{@average_instructor.uq2==4? '  /' : ''}","#{@average_instructor.uq2==3? '/' : ''}","#{@average_instructor.uq2==2? '/' : ''}","#{@average_instructor.uq2==1? '/' : ''}", @average_instructor.uq2review],[{content: "", colspan: 8}],
         ["3.", "#{I18n.t('average_instructor.uq3')}", "#{@average_instructor.uq3==5? '/' : ''}","#{@average_instructor.uq3==4? '  /' : ''}","#{@average_instructor.uq3==3? '/' : ''}","#{@average_instructor.uq3==2? '/' : ''}","#{@average_instructor.uq3==1? '/' : ''}", @average_instructor.uq3review],[{content: "", colspan: 8}],
         ["4.", "#{I18n.t('average_instructor.uq4')}", "#{@average_instructor.uq4==5? '/' : ''}","#{@average_instructor.uq4==4? '  /' : ''}","#{@average_instructor.uq4==3? '/' : ''}","#{@average_instructor.uq4==2? '/' : ''}","#{@average_instructor.uq4==1? '/' : ''}", @average_instructor.uq4review],[{content: "", colspan: 8}],
         [{content: "", colspan: 8}], [{content: "#{I18n.t('average_instructor.obtained_score')}", colspan: 2}, "",{content:"#{@average_instructor.marks_c} / 20", colspan: 3},"", ""],[{content: "", colspan: 8}]
          ]
    table(data, :column_widths => [20, 255, 20,20,20,20,20, 125],:cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding => [0,0,0,0], :padding=> [2,0,2,5]}) do
      row(1..8).column(2..6).borders=[:top,:left, :bottom, :right] #score boxes
      row(0..18).column(0).borders=[:left]
      row(0).column(0).borders=[:left,:right, :top]
      row(1).column(7).borders=[:right]
      row(2).column(0).borders=[:left, :right]
      row(3).column(7).borders=[:right]
      row(4).column(0).borders=[:left, :right]
      row(5).column(7).borders=[:right]
      row(6).column(0).borders=[:left, :right]
      row(7).column(7).borders=[:right]
      row(8).column(0).borders=[:left, :right]
      row(9).column(0).borders=[:left, :right]
      row(1..8).column(2..6).borders=[:top,:left, :bottom, :right] #score boxes
      row(9).column(0).borders=[:left, :right] #before total score line
      row(10).column(0).style :align => :right #total score line
      row(10).column(0).borders=[:left]
      row(10).column(3).borders=[:left, :right, :top, :bottom]
      row(10).column(7).borders=[:right]
      row(11).column(0).borders=[:bottom, :left, :right]
    end
  end 
 
  def table_d_content
    data=[[{content: "", colspan: 8}],
         ["1.", "#{I18n.t('average_instructor.vq1')}", "#{@average_instructor.vq1==5? '/' : ''}","#{@average_instructor.vq1==4? '  /' : ''}","#{@average_instructor.vq1==3? '/' : ''}","#{@average_instructor.vq1==2? '/' : ''}","#{@average_instructor.vq1==1? '/' : ''}", @average_instructor.vq1review],[{content: "", colspan: 8}],
         ["2.", "#{I18n.t('average_instructor.vq2')}", "#{@average_instructor.vq2==5? '/' : ''}","#{@average_instructor.vq2==4? '  /' : ''}","#{@average_instructor.vq2==3? '/' : ''}","#{@average_instructor.vq2==2? '/' : ''}","#{@average_instructor.vq2==1? '/' : ''}", @average_instructor.vq2review],[{content: "", colspan: 8}],
         ["3.", "#{I18n.t('average_instructor.vq3')}", "#{@average_instructor.vq3==5? '/' : ''}","#{@average_instructor.vq3==4? '  /' : ''}","#{@average_instructor.vq3==3? '/' : ''}","#{@average_instructor.vq3==2? '/' : ''}","#{@average_instructor.vq3==1? '/' : ''}", @average_instructor.vq3review],[{content: "", colspan: 8}],
         ["4.", "#{I18n.t('average_instructor.vq4')}", "#{@average_instructor.vq4==5? '/' : ''}","#{@average_instructor.vq4==4? '  /' : ''}","#{@average_instructor.vq4==3? '/' : ''}","#{@average_instructor.vq4==2? '/' : ''}","#{@average_instructor.vq4==1? '/' : ''}", @average_instructor.vq4review],[{content: "", colspan: 8}],
          ["5.", "#{I18n.t('average_instructor.vq5')}", "#{@average_instructor.vq5==5? '/' : ''}","#{@average_instructor.vq5==4? '  /' : ''}","#{@average_instructor.vq5==3? '/' : ''}","#{@average_instructor.vq5==2? '/' : ''}","#{@average_instructor.vq5==1? '/' : ''}", @average_instructor.vq5review],[{content: "", colspan: 8}],
         [{content: "", colspan: 8}], [{content: "#{I18n.t('average_instructor.obtained_score')}", colspan: 2}, "",{content:"#{@average_instructor.marks_d} / 20", colspan: 3},"", ""],[{content: "", colspan: 8}]
          ]
    table(data, :column_widths => [20, 255, 20,20,20,20,20, 125],:cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding => [0,0,0,0], :padding=> [2,0,2,5]}) do
      row(1..8).column(2..6).borders=[:top,:left, :bottom, :right] #score boxes
      row(0..20).column(0).borders=[:left]
      row(0).column(0).borders=[:left,:right, :top]
      row(1).column(7).borders=[:right]
      row(2).column(0).borders=[:left, :right]
      row(3).column(7).borders=[:right]
      row(4).column(0).borders=[:left, :right]
      row(5).column(7).borders=[:right]
      row(6).column(0).borders=[:left, :right]
      row(7).column(7).borders=[:right]
      row(8).column(0).borders=[:left, :right]
      row(9).column(0).borders=[:left]
      row(9).column(7).borders=[:right]
      row(10).column(0).borders=[:left, :right]
      row(11).column(0).borders=[:left, :right]
      row(1..10).column(2..6).borders=[:top,:left, :bottom, :right] #score boxes
      row(11).column(0).borders=[:left, :right] #before total score line
      row(12).column(0).style :align => :right #total score line
      row(12).column(0).borders=[:left]
      row(12).column(3).borders=[:left, :right, :top, :bottom]
      row(12).column(7).borders=[:right]
      row(13).column(0).borders=[:bottom, :left, :right]
    end
  end
  
  def table_e_content
    data=[[{content: "", colspan: 8} ],
         ["1.", "#{I18n.t('average_instructor.gttq1')}", "#{@average_instructor.gttq1==5? '/' : ''}","#{@average_instructor.gttq1==4? '  /' : ''}","#{@average_instructor.gttq1==3? '/' : ''}","#{@average_instructor.gttq1==2? '/' : ''}","#{@average_instructor.gttq1==1? '/' : ''}", @average_instructor.gttq1review],[{content: "", colspan: 8}],
         ["2.", "#{I18n.t('average_instructor.gttq2')}", "#{@average_instructor.gttq2==5? '/' : ''}","#{@average_instructor.gttq2==4? '  /' : ''}","#{@average_instructor.gttq2==3? '/' : ''}","#{@average_instructor.gttq2==2? '/' : ''}","#{@average_instructor.gttq2==1? '/' : ''}", @average_instructor.gttq2review],[{content: "", colspan: 8}],
         ["3.", "#{I18n.t('average_instructor.gttq3')}", "#{@average_instructor.gttq3==5? '/' : ''}","#{@average_instructor.gttq3==4? '  /' : ''}","#{@average_instructor.gttq3==3? '/' : ''}","#{@average_instructor.gttq3==2? '/' : ''}","#{@average_instructor.gttq3==1? '/' : ''}", @average_instructor.gttq3review],[{content: "", colspan: 8}],
         ["4.", "#{I18n.t('average_instructor.gttq4')}", "#{@average_instructor.gttq4==5? '/' : ''}","#{@average_instructor.gttq4==4? '  /' : ''}","#{@average_instructor.gttq4==3? '/' : ''}","#{@average_instructor.gttq4==2? '/' : ''}","#{@average_instructor.gttq4==1? '/' : ''}", @average_instructor.gttq4review],[{content: "", colspan: 8}],
         ["5.", "#{I18n.t('average_instructor.gttq5')}", "#{@average_instructor.gttq5==5? '/' : ''}","#{@average_instructor.gttq5==4? '  /' : ''}","#{@average_instructor.gttq5==3? '/' : ''}","#{@average_instructor.gttq5==2? '/' : ''}","#{@average_instructor.gttq5==1? '/' : ''}", @average_instructor.gttq5review],[{content: "", colspan: 8}],
         ["6.", "#{I18n.t('average_instructor.gttq6')}", "#{@average_instructor.gttq6==5? '/' : ''}","#{@average_instructor.gttq6==4? '  /' : ''}","#{@average_instructor.gttq6==3? '/' : ''}","#{@average_instructor.gttq6==2? '/' : ''}","#{@average_instructor.gttq6==1? '/' : ''}", @average_instructor.gttq6review],[{content: "", colspan: 8}],
         ["7.", "#{I18n.t('average_instructor.dq7')}", "#{@average_instructor.gttq7==5? '/' : ''}","#{@average_instructor.gttq7==4? '  /' : ''}","#{@average_instructor.gttq7==3? '/' : ''}","#{@average_instructor.gttq7==2? '/' : ''}","#{@average_instructor.gttq7==1? '/' : ''}", @average_instructor.gttq7review],[{content: "", colspan: 8}],
         ["8.", "#{I18n.t('average_instructor.gttq8')}", "#{@average_instructor.gttq8==5? '/' : ''}","#{@average_instructor.gttq8==4? '  /' : ''}","#{@average_instructor.gttq8==3? '/' : ''}","#{@average_instructor.gttq8==2? '/' : ''}","#{@average_instructor.gttq8==1? '/' : ''}", @average_instructor.gttq8review],[{content: "", colspan: 8}],
         ["9.", "#{I18n.t('average_instructor.gttq9')}", "#{@average_instructor.gttq9==5? '/' : ''}","#{@average_instructor.gttq9==4? '  /' : ''}","#{@average_instructor.gttq9==3? '/' : ''}","#{@average_instructor.gttq9==2? '/' : ''}","#{@average_instructor.gttq9==1? '/' : ''}", @average_instructor.gttq9review],[{content: "", colspan: 8}],
          [{content: "#{I18n.t('average_instructor.obtained_score')}", colspan: 2}, "",{content:"#{@average_instructor.marks_e} / 45", colspan: 3},"", ""],[{content: "", colspan: 8}]]
  
    table(data, :column_widths => [20, 255, 20,20,20,20,20, 125],:cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding => [0,0,0,0], :padding=> [2,0,2,5]}) do
      row(1..8).column(2..6).borders=[:top,:left, :bottom, :right] #score boxes
      row(0..23).column(0).borders=[:left]
      row(0).column(0).borders=[:left,:right, :top]
      row(1).column(7).borders=[:right]
      row(2).column(0).borders=[:left, :right]
      row(3).column(7).borders=[:right]
      row(4).column(0).borders=[:left, :right]
      row(5).column(7).borders=[:right]
      row(6).column(0).borders=[:left, :right]
      row(7).column(7).borders=[:right]
      row(8).column(0).borders=[:left, :right]
      row(9).column(7).borders=[:right]
      row(10).column(0).borders=[:left, :right]
      row(11).column(7).borders=[:right]
      row(12).column(0).borders=[:left, :right]
      row(13).column(7).borders=[:right]
      row(14).column(0).borders=[:left, :right]
      row(15).column(7).borders=[:right]
      row(16).column(0).borders=[:left, :right]
      row(17).column(7).borders=[:right]    
      row(9..17).column(2..6).borders=[:top,:left, :bottom, :right] #score boxes
      row(18).column(0).borders=[:left, :right] #before total score line
      row(19).column(0).style :align => :right #total score line
      row(19).column(0).borders=[:left]
      row(19).column(3).borders=[:left, :right, :top, :bottom]
      row(19).column(7).borders=[:right]
      row(20).column(0).borders=[:bottom, :left, :right]
    end
  end 
  
  def table_summary
    text "#{I18n.t('average_instructor.evaluation_summary').upcase}", :size => 10, :style => :bold
    move_down 5
    data=[[{content: "#{I18n.t('average_instructor.performance_component')}", colspan: 2}, "#{I18n.t('average_instructor.max_score')}<br>(x)","#{I18n.t('average_instructor.obtained_score')}<br>(y)", "#{I18n.t('average_instructor.weightage')}<br>(w)", "#{I18n.t('average_instructor.percent')}<br> (y/x) X w"], 
          ["A", "#{I18n.t('average_instructor.preparation').upcase}", "45", @average_instructor.marks_a, "25", @view.number_with_precision(@average_instructor.percent_a, precision: 2)],
          ["B", "#{I18n.t('average_instructor.delivery').upcase}","60",@average_instructor.marks_b,"30", @view.number_with_precision(@average_instructor.percent_b, precision: 2)],
          ["C", "#{I18n.t('average_instructor.usage').upcase}","20",@average_instructor.marks_c,"5",@view.number_with_precision(@average_instructor.percent_c, precision: 2)],
          ["D", "#{I18n.t('average_instructor.verification').upcase}","25",@average_instructor.marks_d,"20",@view.number_with_precision(@average_instructor.percent_d, precision: 2)],
          ["E", "#{I18n.t('average_instructor.general_teaching_technique').upcase}","45",@average_instructor.marks_e,"20", @view.number_with_precision(@average_instructor.percent_e, precision: 2)]]
    table(data, :column_widths => [30, 180, 40, 80, 60, 80],  :cell_style => {:size=>10,:borders => [:left, :right, :top, :bottom], :inline_format => :true, :padding => [0,2,2,5]}) do
       row(0).font_style=:bold
       column(0).font_style=:bold
       column(0).style :align => :center
       row(0).column(0).style :align => :center
       row(0).column(0).style :valign => :center
       column(2..5).style :align => :center
    end
  end
  
  def table_score_legend
    data=[["#{I18n.t('average_instructor.score_range')}", "#{I18n.t('average_instructor.grade')}", "#{I18n.t('average_instructor.performance')}"], 
          ["85 - 100", "A", "#{I18n.t('average_instructor.very_good')}"],
          ["70 - 84", "B", "#{I18n.t('average_instructor.good')}"], 
          ["50 - 69", "C", "#{I18n.t('average_instructor.average')}"], 
          ["40 - 49", "D", "#{I18n.t('average_instructor.weak')}"], 
          ["&lt; 40", "E", "#{I18n.t('average_instructor.very_weak')}"], ]
    table(data, :column_widths => [100,100,100],  :cell_style => {:size=>10,:borders => [:left, :right, :top, :bottom], :inline_format => :true, :padding => [0,2,2,2]}, :position => :center) do
       row(0).font_style=:bold
       row(0).column(0..1).style :align => :center
       column(0..1).style :align => :center
    end
  end
  
  def table_review
    data_review=[["#{I18n.t('average_instructor.review')} :",""], 
                        ["", "<u>#{@average_instructor.review}</u>"]]
    table(data_review, :column_widths => [60, 430],  :cell_style => {:size=>10,:borders => [], :inline_format => :true, :padding => [0,0,0,0]}) do
       row(0).column(0).font_style=:bold
       row(1).height=100
    end
  end
  
  def table_signatory
    data=[["#{I18n.t('instructor_appraisal.signatory')}<br>(#{I18n.t('average_instructor.evaluated_instructor')})", "", "#{I18n.t('instructor_appraisal.signatory')}<br>(#{I18n.t('average_instructor.quality_division')})"],[ "(#{I18n.t('instructor_appraisal.name')}: #{@average_instructor.instructor.staff_with_rank})", "", "(#{I18n.t('instructor_appraisal.name')}: #{@average_instructor.evaluator.staff_with_rank})"], [ "#{I18n.t('instructor_appraisal.date2')}: #{@average_instructor.evaluate_date.try(:strftime, '%d-%m-%Y')}", "", "#{I18n.t('instructor_appraisal.date2')}: #{@average_instructor.evaluate_date.try(:strftime, '%d-%m-%Y')}"]]
    table(data, :column_widths => [195, 30, 265],  :cell_style => {:size=>10, :borders => [], :inline_format => :true, :padding =>[0,0,0,0]}) do
      row(0).height=70
      row(0).column(0).style :align => :center
      row(0).column(2).style :align => :center
      row(0).column(0).borders=[:bottom]
      row(0).column(2).borders=[:bottom]
    end
  end
  
  def table_ending
    data=[["#{I18n.t('instructor_appraisal.prepared').upcase}: BKKM","#{I18n.t('exam.evaluate_course.date_updated')} : 5 DISEMBER 2011"]]
    table(data, :column_widths => [270,220], :cell_style => {:size=>10, :borders => [:left, :right, :top, :bottom]}) do
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
    draw_text "#{page_number} #{I18n.t('instructor_appraisal.from')} 3",  :size => 10, :at => [220,-5]
  end
  
end
