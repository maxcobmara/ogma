class Exammark_listPdf < Prawn::Document
  def initialize(exammarks_all, view, college)
    super({top_margin: 40, left_margin: 40, page_size: 'A4', page_layout: :portrait })
    @exammarks_all= exammarks_all
    @exammarks_group=@exammarks_all.group_by{|x|x.exam_id}
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
    row_count=0
    paper_rows=[]
    @exammarks_group.sort.each do |exammarks_group, exammarks|
      exammarks.sort_by{|x|x.studentmark.name}.each_with_index do |exammark,index|
	if index == 0
         paper_rows << index+2+row_count
	end
      end
      row_count+=exammarks.count+1
    end
    table(line_item_rows, :column_widths => [30, 180, 100, 100, 100], :cell_style => { :size => 9,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      column(3..4).align = :right
      for paper_row in paper_rows
        row(paper_row).background_color='FDF8A1'
        row(paper_row).align = :center
        row(paper_row).font_style=:bold
      end
    end
  end
  
  def line_item_rows
    counter = counter || 0
    index2 = index2 || 0
    header = [[{content: "#{I18n.t('exam.exammark.title').upcase}<br> #{@college.name.upcase}", colspan: 5}]]
    row1=[ 'No', I18n.t('exam.exammark.student_id'), I18n.t('exam.exammark.icno'), I18n.t('exam.exammark.marks')]
    exam_ids=[]
    @exammarks_group.each{|k,v|exam_ids << k}
    final_exist=Exam.where(id: exam_ids).where(name: "F")
    if final_exist.count > 0
      row1+=[I18n.t('exam.exammark.summative')]
    else
      row1=[]
    end
    header << row1
    body=[]
    @exammarks_group.sort.each do |exammarks_group, exammarks|
      exammarks.sort_by{|x|x.studentmark.name}.each_with_index do |exammark,index|
	if index == 0
         body << [{content: "#{I18n.t('exam.exammark.exam_id')} : #{Exam.find(exammarks_group).full_exam_name2} #{I18n.t('exam.exams.with_questions') if exammark.exampaper.klass_id == 1}", colspan: 5}]
	end
	if exammark.exampaper.name!="M" 
          if exammark.total_mcq
            summative="#{@view.number_with_precision(exammark.totalsummative, precision: 2)} / "
            if exammark.exampaper.exam_template.total_in_weight==0
              summative+= "#{@view.number_with_precision(exammark.total_weightage, precision: 2)} %"
            else
              summative+= "#{exammark.exampaper.exam_template.total_in_weight} %"
	    end
	  end
        else
          summative="-"
	end
        body << ["#{counter+=1}", "#{exammark.college.code=='amsas' ? exammark.studentmark.student_with_rank : exammark.studentmark.matrix_name}", exammark.studentmark.icno, "#{@view.number_with_precision(exammark.total_marks, precision: 2)} / #{@view.number_with_precision(exammark.exampaper.exam_template.template_full_marks, precision: 2) if exammark.total_mcq}", summative]
      end
    end
    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [470,-5]
  end

end