class Instructorevaluation_reportPdf < Prawn::Document  
  def initialize(instructor_appraisals, view, college)
    super({top_margin: 40, left_margin: 60, page_size: 'A4', page_layout: :portrait })
    @appraisals  = instructor_appraisals
    @view = view
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
    bounding_box([140,750], :width => 350, :height => 100) do |y2|
      if college.code=="kskbjb"
        move_down 30
        text "#{college.name}"
        move_down 1
        text "#{I18n.t('instructor_appraisal.report').upcase}"
      else
        draw_text "PUSAT LATIHAN DAN AKADEMI MARITIM MALAYSIA", :at => [-30, 85], :style => :bold, :size => 11
        draw_text "(PLAMM)", :at => [85, 70], :style => :bold, :size => 11
        draw_text "#{I18n.t('instructor_appraisal.report').upcase}", :at => [10, 45], :style => :bold,  :size => 11
      end
    end
    
    if college.code=="kskbjb"
      bounding_box([390,750], :width => 400, :height => 100) do |y2|
        image "#{Rails.root}/app/assets/images/kskb_logo-6.png",  :width =>97.2, :height =>77.76
      end
    else
      bounding_box([420,770], :width => 400, :height => 90) do |y2|
        image "#{Rails.root}/app/assets/images/amsas_logo_small.png", :scale => 0.8
      end
    end
    move_down 30
    table_report
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def table_report
    
    header=[["No","#{I18n.t('instructor_appraisal.staff_id').upcase}", "#{I18n.t('instructor_appraisal.appraisal_date').upcase}" , "#{I18n.t('instructor_appraisal.marks').upcase}", "STATUS"] ]
    body = []
    count=0
    for appraisal in @appraisals
      body << [count+=1, appraisal.instructor.staff_with_rank, appraisal.appraisal_date.try(:strftime, '%d-%m-%Y'), appraisal.total_mark, appraisal.level]
    end
    data=header+body
    table(data, :column_widths => [30, 200, 80, 80, 100], :cell_style => {:size=>10, :borders => [:left, :right, :top, :bottom]}) do
      a = 0
      b = 1
      row(0).font_style = :bold
      row(0).style :valign => :center
      row(0).background_color = 'F0F0F0'
      columns(2..3).style :align => :center
      while a < b do
        a=+1
      end
    end
  end
  
  def footer
    draw_text "#{page_number} #{I18n.t('instructor_appraisal.from')} #{page_count}",  :size => 8, :at => [240,-5]
  end
 
end