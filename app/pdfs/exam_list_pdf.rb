class Exam_listPdf < Prawn::Document
  def initialize(programme_exams, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :landscape })
    @programme_exams = programme_exams
    @view = view
    @college=college
    font "Helvetica"
    record
    page_count.times do |i|
      go_to_page(i+1)
      footer
    end
  end
  
  def record
    if @college.code=='kskbjb'
      colwidths=[30, 20, 90, 70, 90, 90, 60, 70, 80, 50, 70, 50]
    else
      colwidths=[30, 20, 130, 120, 120, 60, 70, 90, 70, 50]
    end
    row_count=2                 #rows for document header / title
    col_redmark=[]
    @programme_exams.each do |programme, exams|
        exams.each_with_index do |exam, cnt|
          if exam.complete_paper==false
              col_redmark << cnt+row_count 
          end
        end
	row_count+=exams.count
    end
    table(line_item_rows, :column_widths => colwidths, :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      row(2..3).column(0).borders=[:top, :left, :bottom]
      row(2..3).column(1).borders=[:top, :bottom, :right]
      for redmark in col_redmark
        row(redmark).column(1).text_color ='EC0C16'
      end
    end
  end
  
  def line_item_rows
    if @college.code=='kskbjb'
      total_columns=12
      header_title=[{content: 'No', colspan: 2}, I18n.t('exam.exams.name'),  I18n.t('exam.exams.year_semester'), I18n.t('exam.exams.course_id'),  I18n.t('exam.exams.subject_id'),  I18n.t('exam.exams.exam_on'),  I18n.t('exam.exams.time'),  I18n.t('exam.exams.created_by'),  I18n.t('exam.exams.duration'),  I18n.t('exam.exams.full_marks'), I18n.t('exam.exams.separate_combine')]
    else
      total_columns=10
      header_title=[ {content: 'No', colspan: 2}, I18n.t('exam.exams.name'),  I18n.t('exam.exams.course_id'),  I18n.t('exam.exams.subject_id'),  I18n.t('exam.exams.exam_on'),  I18n.t('exam.exams.time'),  I18n.t('exam.exams.created_by'),  I18n.t('exam.exams.duration'),  I18n.t('exam.exams.full_marks')]
    end
    counter = counter || 0
    header = [[{content: "#{I18n.t('exam.exams.list').upcase}<br> #{@college.name.upcase}", colspan: total_columns}],
              header_title]
    body=[]
    @programme_exams.each do |programme, exams|
        for exam in exams
          a=["#{counter += 1}", "#{exam.complete_paper==false ? '*' : ''}",  "#{exam.render_examtype.first}<br>#{I18n.t('exam.exams.with_questions') if exam.klass_id == 1}"]
          b=[exam.subject.try(:root).try(:programme_list), exam.subject.try(:subject_list), exam.exam_on.try(:strftime, '%d-%m-%Y'), exam.timing, exam.creator_details, "#{exam.duration!=nil ? (exam.duration/60).to_i.to_s+' '+I18n.t('time.hours')+' '+(exam.duration%60).to_i.to_s+' '+I18n.t('time.minutes') : (((exam.endtime - exam.starttime)/60) / 60).to_i.to_s+' '+I18n.t('time.hours')+' '+ (((exam.endtime - exam.starttime)/60) % 60).to_i.to_s+' '+I18n.t('time.minutes')}", exam.total_marks]
          if @college.code=="kskbjb" 
            semno= exam.subject.parent.code.to_i%2 == 0 ? '2' : '1'
            if exam.sequ!=nil
              sequ = exam.sequ.split(",")
              if sequ!=nil && sequ.uniq.length == sequ.length && exam.separate_cover.include?(exam.subject.root.id)
                c=["S"]
              end
              if sequ!=nil && sequ.uniq.length == sequ.length && exam.combine_cover.include?(exam.subject.root.id)
                c=["C"]
              end
            end
            body << a+["#{exam.subject_id? ? exam.syear+semno : ''}"]+b+c
          else
            body << a+b
          end
        end
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [720,-5]
    fill_color "ECOC16"
    draw_text "* ", :size => 8, :at => [0, -5]
    fill_color "000000"
    draw_text "#{I18n.t('exam.exams.remarks_bottom')}", :size => 8, :at => [5, -5]
  end

end