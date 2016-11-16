class Examanalysis_listPdf < Prawn::Document
  def initialize(examanalyses, view, college)
    super({top_margin: 40, left_margin: 40, bottom_margin: 50, page_size: 'A4', page_layout: :portrait })
    @examanalyses = examanalyses
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
    if @college.code=='amsas'
      columns_set= [30, 130, 70, 180, 50, 50]
      setfontsize=9
    else
      columns_set= [30, 60, 60, 60, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 40, 40]
      setfontsize=8
    end
    row_count=0
    programme_rows=[]
    @examanalyses.group_by{|x|x.exampaper.subject.root.programme_list}.each do |programme, examanalyses|
	  programme_rows << 2+row_count 
	  row_count+=examanalyses.count+1
    end
    table(line_item_rows, :column_widths => columns_set, :cell_style => { :size => setfontsize,  :inline_format => :true}, :header => 2) do
      row(0).borders =[]
      row(0).height=50
      row(0).style size: 11
      row(0).align = :center
      row(0..1).font_style = :bold
      row(1).background_color = 'FFE34D'
      column(2..5).align =:center

      for programme_row in programme_rows
	row(programme_row).background_color = 'FDF8A1'
	row(programme_row).align =:center
	row(programme_row).font_style=:bold
      end

    end
  end
  
  def line_item_rows
    counter=counter || 0
    if @college.code=='kskbjb'
      total_columns=17
    else
      total_columns=6
    end
    header = [[{content: "#{I18n.t('exam.examanalysis.title').upcase}<br> #{@college.name.upcase}", colspan: total_columns}]]
    header_title=['No', I18n.t('exam.examanalysis.subject_id'), I18n.t('exam.examanalysis.exam_on'), I18n.t('exam.examanalysis.examtype')]
    pass_fail=[I18n.t('exam.examresult.passed'), I18n.t('exam.examresult.failed')]
    if @college.code=='kskbjb'
      header << header_title+["A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "E"]+pass_fail
    else
       header << header_title+pass_fail
    end
    body=[]
    
    @examanalyses.group_by{|x|x.exampaper.subject.root.programme_list}.each do |programme, examanalyses|
	    body <<  [{content: "#{programme}", colspan: total_columns}] 
	    for examanalysis in examanalyses
	        if @college.code!='kskbjb'
		  ##
		  exammarks=examanalysis.exampaper.exammarks
                  subjectid=examanalysis.exampaper.subject_id
                  students=Student.where(id: exammarks.pluck(:student_id))
                  finalscores=[]
                  students.each{|x|finalscores << Grade.where(student_id: x.id).where(subject_id: subjectid).first.finalscore}
                  passed=[]
                  failed=[]
                  finalscores.each{|y|passed << y if y>=50}
                  finalscores.each{|z|failed << z if z < 50}
		  ##
		end
	        a=["#{counter += 1}", examanalysis.exampaper.subject.subject_list,  @view.l(examanalysis.exampaper.exam_on), "#{examanalysis.exampaper.render_examtype[0]} #{'<br>'+I18n.t('exam.exams.with_questions') if examanalysis.exampaper.klass_id==1}"]
		b=[ passed.count, failed.count]
		if @college.code=='kskbjb'
	          body << a+[examanalysis.gradeA , examanalysis.gradeAminus, examanalysis.gradeBplus , examanalysis.gradeB, examanalysis.gradeBminus, examanalysis.gradeCplus, examanalysis.gradeC, examanalysis.gradeCminus, examanalysis.gradeDplus, examanalysis.gradeD, examanalysis.gradeE]+b
		else
		  body << a+b
		end
		counter = counter || 0
	    end
    end

    header+body
  end
  
  def footer
    draw_text "#{page_number} / #{page_count}",  :size => 8, :at => [480,-5]
    draw_text "#{I18n.t('exam.examresult.passed2')}: #{I18n.t('exam.examresult.refer_passed2')}",  :size => 8, :at => [0,0]
    draw_text "#{I18n.t('exam.examresult.failed2')}: #{I18n.t('exam.examresult.refer_failed2')}",  :size => 8, :at => [0,-10]
  end

end