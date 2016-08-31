class Averageinstructor_evaluationPdf < Prawn::Document  
  def initialize(average_instructor, view, college)
    super({top_margin: 40, page_size: 'A4', page_layout: :portrait })
    @average_instructor  = average_instructor
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
        draw_text "#{I18n.t('average_instructor.form_title1').upcase}", :at => [10, 45], :style => :bold
	draw_text "#{I18n.t('average_instructor.form_title2').upcase}", :at => [25, 30], :style => :bold
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
    table_info
    #table_main
    move_down 70
    table_signatory
    move_down 230
    table_ending
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
    
      stroke do
	horizontal_line 135, 505, :at => 630 #kursus
	horizontal_line 135, 505, :at => 607 #jurulatih
	horizontal_line 135, 505, :at => 584 #tarikh
	horizontal_line 135, 505, :at => 561 #tajuk
	horizontal_line 135, 360, :at => 538 #objektif
	horizontal_line 135, 360, :at => 515
	horizontal_line 135, 360, :at => 492
	horizontal_line 135, 360, :at => 469
	horizontal_line 135, 360, :at => 446
	
	#time box
	horizontal_line 420, 505, :at => 538 #masa
	horizontal_line 380, 500, :at => 510
	horizontal_line 380, 500, :at => 490
	horizontal_line 380, 500, :at => 465
	horizontal_line 380, 500, :at => 445
	vertical_line 445, 511, :at => 380
	vertical_line 445, 511, :at => 455
	vertical_line 445, 511, :at => 500
	
	#delivery_type box
	horizontal_line 115, 140, :at => 440
	horizontal_line 115, 140, :at => 425
	vertical_line 425, 440, :at => 115
	vertical_line 425, 440, :at => 140
      end
   
  end
  
  def table_info
    data =[["#{I18n.t('average_instructor.programme_id')}", ": ",{ content: "#{@average_instructor.programme.programme_list}", colspan: 3}],
    ["#{I18n.t('average_instructor.instructor_id')}", ": ",{content: "#{@average_instructor.instructor.staff_with_rank}", colspan: 3}], 
    ["#{I18n.t('average_instructor.evaluate_date')}",": ", {content: "#{@average_instructor.evaluate_date.try(:strftime,'%d-%m-%Y')} ", colspan: 3}],
    ["#{I18n.t('average_instructor.title2')}",": ", {content: "#{@average_instructor.title} ", colspan: 3}],
    ["#{I18n.t('average_instructor.objective')}", ": ","#{@average_instructor.display_objective[0]}", {content: "#{I18n.t('average_instructor.time')}: ", colspan: 2}],
           ["mm",": ","#{@average_instructor.display_objective[1]}","",""],
           ["",": ","#{@average_instructor.display_objective[2]}","#{I18n.t('average_instructor.start_at')}","#{@average_instructor.start_at.try(:strftime, '%H:%M')}"],
           ["",": ","#{@average_instructor.display_objective[3]}","#{I18n.t('average_instructor.end_at')}","#{@average_instructor.end_at.try(:strftime, '%H:%M')}"],
           ["",": ","#{@average_instructor.display_objective[4]}","#{I18n.t('average_instructor.duration')}","#{@average_instructor.duration}"],
           ["#{I18n.t('average_instructor.delivery_type')}","#{@average_instructor.display_delivery} ","T : Teori     P : Praktikal     L  Lain-lain","",""]
    ]
    table(data, :column_widths => [110,20, 250, 80, 60],  :cell_style => {:size=>11, :borders => [], :inline_format => :true, :padding=>[5,0,5,5]}) do
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
  
  def table_signatory
    data=[["#{I18n.t('instructor_appraisal.date2').upcase}: <u>#{@average_instructor.evaluate_date.try(:strftime, '%d-%m-%Y')}</u>", "#{I18n.t('instructor_appraisal.signatory').upcase}: ..............................................."], ["", "#{I18n.t('instructor_appraisal.name')}: <u>#{@average_instructor.instructor.staff_with_rank}</u>"], ["", "#{I18n.t('instructor_appraisal.rank').upcase}: <u>#{@average_instructor.instructor.rank.name}</u>"]]
    table(data, :column_widths => [255, 255],  :cell_style => {:size=>11, :borders => [], :inline_format => :true})
  end
  
  def table_ending
    data=[["#{I18n.t('instructor_appraisal.prepared').upcase}: BKKM","#{I18n.t('exam.evaluate_course.date_updated')} : #{@average_instructor.updated_at.try(:strftime, '%d-%m-%Y')} "]]
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
    draw_text "#{page_number} #{I18n.t('average_instructor.from')} 3",  :size => 8, :at => [240,-5]
  end
  
end
