class Grade_listPdf < Prawn::Document
  def initialize(grades_all, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :landscape })
    @grades_all=grades_all
    @grades_group = @grades_all.group_by{|x|x.subject_id}
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
      columns_set=[30, 100, 100, 55, 50, 50, 70, 55, 60, 40, 60, 45, 45, 40]
    else
      columns_set=[30, 120, 120, 55, 70, 55, 60, 40, 60, 45, 45, 40]
    end
    row_count=0
    paper_rows=[]
    @grades_group.sort.each do |grades_group, grades|
      grades.sort_by{|x|x.studentgrade.name}.each_with_index do |grade, index|
	if index == 0
         paper_rows << index+2+row_count
	end
      end
      row_count+=grades.count+1
    end
    college_code=@college.code
    table(line_item_rows, :column_widths => columns_set, :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      if college_code=='kskbjb'
        columns(3).align =:right
        columns(8..10).align =:right
        columns(12).align =:right
      else
        columns(3).align =:right
        columns(6..8).align =:right
        columns(10).align =:right
      end
      for paper_row in paper_rows
        row(paper_row).background_color='FDF8A1'
        row(paper_row).align = :center
        row(paper_row).font_style=:bold
      end
    end
  end
 
  def line_item_rows
    counter = counter || 0
    a=["No", I18n.t('exam.grade.student_id'), I18n.t('exam.grade.subject_id'), I18n.t('exam.grade.total_formative')]
    b=[I18n.t('exam.grade.eligible_for_exam'), I18n.t('exam.grade.carry_paper'), I18n.t('exam.grade.examweight'), I18n.t('exam.grade.exam1marks'), I18n.t('exam.grade.summative'), I18n.t('exam.grade.resit'), I18n.t('exam.grade.finalscore'), I18n.t('exam.grade.grading_id')]
    if @college.code=='kskbjb'
      header_title=a+[{content: "#{I18n.t('exam.grade.sent_date')}", colspan: 2}]+b
      total_columns=14
    else
      header_title=a+b
      total_columns=12
    end
    header = [[{content: "#{I18n.t('exam.grade.list').upcase}<br> #{@college.name.upcase}", colspan: total_columns}]]
    header << header_title
    body=[]
    @grades_group.sort.each do |grades_group, grades|
      grades.sort_by{|x|x.studentgrade.name}.each_with_index do |grade,index|
          if index == 0
            body << [{content: "#{I18n.t('exam.grade.programme')} - #{I18n.t('exam.grade.subject_id')} : #{Programme.find(grades_group).programme_subject}", colspan: total_columns}]
          end
          if grade.finalscore && grade.summative && grade.formative && grade.finalscore==grade.summative+grade.formative
            finalscore=@view.number_with_precision(grade.finalscore, :precision => 2)
          else
            finalscore=@view.number_with_precision(grade.finalscore, :precision => 2)
          end

	  a= ["#{counter+=1}", "#{grade.college.code=='amsas' ? grade.studentgrade.student_with_rank : grade.studentgrade.matrix_name}", grade.subjectgrade.try(:subject_list), @view.number_with_precision(grade.total_formative, precision: 2)]
	  b=["#{'/' if grade.eligible_for_exam == true}", "#{'/' if grade.carry_paper ==true}", "#{grade.examweight.blank? ? '' : @view.number_with_precision(grade.examweight,:precision=>2)} %", "#{grade.exam1marks.blank? ? '' : @view.number_with_precision(grade.exam1marks,:precision=>2) }", "#{@view.number_with_precision(grade.summative,:precision=>2) if grade.examweight.blank? == false && grade.exam1marks.blank? == false}", "#{'/' if grade.resit==true}", finalscore, "#{grade.render_grading[-2,2].strip unless grade.finale.blank?}"]

	  if @college.code=='kskbjb'
	    body << a+["#{'/' if grade.sent_to_BPL == true}", grade.sent_date.try(:strftime, '%d %b %Y')]+b 
	  else
	    body << a+b
	  end
      end
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [720,-5]
  end

end