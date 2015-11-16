class Examination_transcriptPdf < Prawn::Document
  def initialize(resultlines, view)
    super({top_margin: 30, left_margin:20, right_margin:10, page_size: 'A4', page_layout: :portrait })
    @resultlines = resultlines
    @view = view
    font "Helvetica"
    move_down 10
    if Programme.where(course_type: 'Diploma').pluck(:id).include?(@resultlines.first.examresult.programme_id)
      student_details
      @result=@resultlines.first
      @result2=@resultlines[1]
      diploma_result
      @result=@resultlines[2]
      @result2=@resultlines[3]
      diploma_result
      start_new_page
      student_details
      move_down 10
      @result=@resultlines[4]
      @result2=@resultlines[5]
      diploma_result
      total_diploma
    else
      move_down 10
      student_details
      @result=@resultlines.first
      @result2=@resultlines[1]
      posbasic_result
    end
  end
  
  def student_details
    data = [["Student ID : #{@resultlines.first.student.matrixno}","Name : #{@resultlines.first.student.name }", "No IC : #{@resultlines.first.student.icno}"],
                 ["Course : #{@resultlines.first.examresult.programmestudent.programme_list}", "Intake : #{@resultlines.first.examresult.intake_group}", "Academic Status : Completed"],
                 ["College : Kolej Sains Kesihatan Bersekutu Johor Bahru","Discipline : #{@resultlines.first.examresult.programmestudent.name}", ""]]
    table(data, :column_widths => [230 , 196, 130], :cell_style => { :size => 9, :inline_format => true}) do
      self.width = 556
      rows(0).columns(0).borders=[:top, :left]
      rows(0).columns(1).borders=[:top]
      rows(0).columns(2).borders=[:top, :right]
      rows(1).columns(0).borders=[:left]
      rows(1).columns(1).borders=[]
      rows(1).columns(2).borders=[:right]
      rows(2).columns(0).borders=[:bottom, :left]
      rows(2).columns(1).borders=[:bottom]
      rows(2).columns(2).borders=[:bottom, :right]
    end
  end
  
  def diploma_result
    @subjects=@result.examresult.retrieve_subject
    @subjects2=@result2.examresult.retrieve_subject
    
    @cara_kerja=Programme.where(course_type: 'Diploma').where('name ILIKE (?)', 'Jurupulih Perubatan Cara Kerja').first.id
    @perubatan=Programme.where(course_type: 'Diploma').where('name ILIKE (?)', 'Penolong Pegawai Perubatan').first.id
    @detailing=[]
    @final_all=[]
    @credit_all=[]
    if @subjects.count > @subjects2.count
      @subject_count=@subjects.count
    else
      @subject_count=@subjects2.count
    end
    credit_hours=0
    credit_hours2=0
    0.upto(@subject_count-1).each do |cnt|
      if cnt < @subjects.count
        student_grade=Grade.where('student_id=? and subject_id=?',@result.student.id, @subjects[cnt].id).first 
        student_finale = Grade.where('student_id=? and subject_id=?',@result.student.id, @subjects[cnt].id).first
        english_subjects=['PTEN', 'NELA', 'NELB', 'NELC', 'MAPE', 'XBRE', 'OTEL'] 
        if english_subjects.include?(@subjects[cnt].code[0,4])
          @grading="-"
          @finale="-"
        else
          unless student_grade.nil? || student_grade.blank?
            @grading=student_grade.render_grading[-1,2] #= student_grade.set_gred
          else
            @grading=""
          end
          unless student_finale.nil? || student_finale.blank? 
            @finale=sprintf('%.2f', student_finale.set_NG.to_f)
            @final_all << student_finale.set_NG.to_f
          else
            @finale=sprintf('%.2f', 0.00)
            @final_all << 0.00
          end
        end
        credit=@subjects[cnt].code[10,1] if @subjects[cnt].code.size >9
        credit=@subjects[cnt].code[-1,1] if @subjects[cnt].code.size < 10
        credit_hours+=credit.to_i
        @credit_all << credit.to_i
      end
      if cnt < @subjects2.count
        student_grade=Grade.where('student_id=? and subject_id=?',@result2.student.id, @subjects2[cnt].id).first 
        student_finale = Grade.where('student_id=? and subject_id=?',@result2.student.id, @subjects2[cnt].id).first
        english_subjects=['PTEN', 'NELA', 'NELB', 'NELC', 'MAPE', 'XBRE', 'OTEL'] 
        if english_subjects.include?(@subjects2[cnt].code[0,4])==true
          @grading2="-"
          @finale2="-"
        else
          unless student_grade.nil? || student_grade.blank?
           @grading2=student_grade.render_grading[-1,2] #= student_grade.set_gred
          else
           @grading2=""
          end
          unless student_finale.nil? || student_finale.blank? 
            @finale2=sprintf('%.2f', student_finale.set_NG.to_f)
            @final_all << student_finale.set_NG.to_f
          else
            @finale2=sprintf('%.2f', 0.00)
            @final_all << 0.00
          end
        end
        credit=@subjects2[cnt].code[10,1] if @subjects2[cnt].code.size >9
        credit=@subjects2[cnt].code[-1,1] if @subjects2[cnt].code.size < 10
        credit_hours2+=credit.to_i
        @credit_all << credit.to_i
      end
      @detailing << ["#{@subjects[cnt].nil? ? "" : @subjects[cnt].subject_list}", "#{@subjects[cnt].nil? ? "" : @finale}", "#{@subjects[cnt].nil? ? "" : @grading}"  ,  "#{@subjects[cnt].nil? ? "" : @result.examresult.examdts.try(:strftime, '%b %Y')}", "", "#{@subjects2[cnt].nil? ? "" : @subjects2[cnt].subject_list}", "#{@subjects2[cnt].nil? ? "" : @finale2}","#{@subjects2[cnt].nil? ? "" : @grading2}", "#{@subjects2[cnt].nil? ? "" : @result2.examresult.examdts.try(:strftime, '%b %Y')}"]
    end
    total_point=@view.number_with_precision(Examresult.total(@final_all, @credit_all), precision: 2)
    data = [[{content: "<b>#{@result.examresult.render_semester.split("/").join(" ")}</b>", colspan: 4},"", 
             {content: "<b>#{@result2.examresult.render_semester.split("/").join(" ")}</b>", colspan: 4}],
            ["<b>#{I18n.t('exam.examresult.subject_code_name')}</b>", "<b>#{I18n.t('exam.examresult.grade_point')}</b>", 
             "<b>#{I18n.t('exam.examresult.grade')}</b>", "<b>#{I18n.t( 'exam.examresult.term')}</b>", "",
             "<b>#{I18n.t('exam.examresult.subject_code_name')}</b>", "<b>#{I18n.t('exam.examresult.grade_point')}</b>", 
             "<b>#{I18n.t('exam.examresult.grade')}</b>", "<b>#{I18n.t( 'exam.examresult.term')}</b>" ]]
    data += @detailing
    data+= [["<b>#{I18n.t('exam.examresult.completed_credit')} = #{credit_hours}</b>", "<b>#{I18n.t('exam.examresult.total_point')}</b>", "<b>#{I18n.t('exam.examresult.gpa')}</b>", "<b>#{I18n.t( 'exam.examresult.cgpa')}</b>", "", "<b>#{I18n.t('exam.examresult.completed_credit')} = #{credit_hours2}</b>", "<b>#{I18n.t('exam.examresult.total_point')}</b>", "<b>#{I18n.t('exam.examresult.gpa')}</b>", "<b>#{I18n.t( 'exam.examresult.cgpa')}</b>",], ["","<b>#{total_point}</b>", "<b>#{@result.pngs17.nil? ? "" : sprintf('%.2f',@result.pngs17)}</b>", "<b>#{@result.pngk.nil? ? "0.00" : sprintf('%.2f',@result.pngk)}", "", "","<b>#{@result2.total.nil? ? "" : sprintf('%.2f',@result2.total)}</b>", "<b>#{@result2.pngs17.nil? ? "" : sprintf('%.2f',@result2.pngs17)}</b>", "<b>#{@result2.pngk.nil? ? "0.00" : sprintf('%.2f',@result2.pngk) }</b>"]]
  
   last_row=@subject_count+3
  
    table(data, :column_widths => [145, 41, 40, 50, 4, 145, 41, 40, 50], :cell_style => { :size => 9, :inline_format => :true}) do
      self.width = 556
      rows(0).columns(0..5).borders=[]
      rows(1..last_row).columns(4).borders=[:left]
      columns(1..3).align=:center
      columns(6..8).align=:center
    end
  end
  
  def total_diploma
    total_credit_hours=@resultlines.first.examresult.total_credit+@resultlines[1].examresult.total_credit+@resultlines[2].examresult.total_credit+@resultlines[3].examresult.total_credit+@resultlines[4].examresult.total_credit+@resultlines[5].examresult.total_credit
    total_grade_points=Examresult.total_grade_points(@resultlines)
    final_cgpa=total_grade_points/total_credit_hours
    data=[["<b>#{I18n.t('exam.examresult.completed_credit_hours')} = #{total_credit_hours}</b>", "<b>#{I18n.t('exam.examresult.total_grade_point')} : </b>", "<b>#{I18n.t('exam.examresult.cgpa')}</b>"],
              ["", "<b>#{@view.number_with_precision(total_grade_points, :precision => 2)}</b>", "<b>#{@view.number_with_precision(final_cgpa, :precision => 2)}</b>"]]
    table(data, :column_widths => [145, 81, 50], :cell_style => { :size => 9, :inline_format => :true}) do
      self.width = 276
      rows(0).columns(0).borders=[:left, :right, :top]
      rows(1).columns(0).borders=[:left, :right, :bottom]
      columns(1..2).align=:center
    end
  end

  def posbasic_result
    subjects=@result.examresult.retrieve_subject
    subjects2=@result2.examresult.retrieve_subject
    english_subjects=['PTEN', 'NELA', 'NELB', 'NELC', 'MAPE', 'XBRE', 'OTEL'] 
    @detailing1=[]
    @detailing2=[]
    credit_hours=0
    for subject in subjects
      student_grade=Grade.where('student_id=? and subject_id=?',@result.student.id, subject.id).first 
      student_finale = Grade.where('student_id=? and subject_id=?',@result.student.id, subject.id).first
      if english_subjects.include?(subject.code[0,4])
        @grading="-"
        @finale="-"
      else
        unless student_grade.nil? || student_grade.blank?
          @grading=student_grade.render_grading[-1,2] #= student_grade.set_gred
        else
          @grading=""
        end
        unless student_finale.nil? || student_finale.blank? 
          @finale=sprintf('%.2f', student_finale.set_NG.to_f)
        else
          @finale=sprintf('%.2f', 0.00)
        end
      end
      credit=subject.code[10,1] if subject.code.size >9
      credit=subject.code[-1,1] if subject.code.size < 10
      credit_hours+=credit.to_i
      @detailing1 << [subject.subject_list, credit, @finale, @grading, @result.examresult.examdts.try(:strftime, '%b %Y')]
    end
 
    data = [[{content: "<b>#{@result.examresult.render_semester.split("/").join(" ")}</b>", colspan: 5}],
            ["<b>#{I18n.t('exam.examresult.subject_code_name')}</b>",  "<b>#{I18n.t('exam.examresult.credit')}</b>","<b>#{I18n.t('exam.examresult.grade_point')}</b>", 
             "<b>#{I18n.t('exam.examresult.grade')}</b>", "<b>#{I18n.t( 'exam.examresult.term')}</b>"]]
    data += @detailing1
    data+= [["<b>#{I18n.t('exam.examresult.completed_credit')}</b>", credit_hours, "<b>#{I18n.t('exam.examresult.total_point')}</b>", "<b>#{I18n.t('exam.examresult.gpa')}</b>", "<b>#{I18n.t( 'exam.examresult.cgpa')}</b>"], ["", "","<b>#{@result.total.nil? ? "" : sprintf('%.2f',@result.total)}</b>", "<b>#{@result.pngs17.nil? ? "" : sprintf('%.2f',@result.pngs17)}</b>", "<b>#{@result.pngk.nil? ? "0.00" : sprintf('%.2f',@result.pngk)}"]]
    
    last_row=subjects.count+3
    move_down 10
    table(data, :column_widths => [260,40, 80, 80, 80], :cell_style => { :size => 9, :inline_format => :true}) do
      self.width = 540
      rows(0).columns(0..6).borders=[]
      rows(1..last_row).columns(5).borders=[:left]
      columns(1..4).align=:center
    end
    credit_hours2=0
    for subject in subjects2
      student_grade=Grade.where('student_id=? and subject_id=?',@result2.student.id, subject.id).first 
      student_finale = Grade.where('student_id=? and subject_id=?',@result2.student.id,subject.id).first
      if english_subjects.include?(subject.code[0,4])
        @grading2="-"
        @finale2="-"
      else
        unless student_grade.nil? || student_grade.blank?
         @grading2=student_grade.render_grading[-1,2] #= student_grade.set_gred 
        else
         @grading2=""
        end
        unless student_finale.nil? || student_finale.blank? 
          @finale2=sprintf('%.2f', student_finale.set_NG.to_f)
        else
          @finale2=sprintf('%.2f', 0.00)
        end
      end
      credit=subject.code[10,1] if subject.code.size >9
      credit=subject.code[-1,1] if subject.code.size < 10
      credit_hours2+=credit.to_i
      @detailing2 << [subject.subject_list, credit, @finale, @grading, @result2.examresult.examdts.try(:strftime, '%b %Y')]
    end
    
    data2 = [[{content: "<b>#{@result2.examresult.render_semester.split("/").join(" ")}</b>", colspan: 4}],
            ["<b>#{I18n.t('exam.examresult.subject_code_name')}</b>", "<b>#{I18n.t('exam.examresult.credit')}</b>","<b>#{I18n.t('exam.examresult.grade_point')}</b>", 
             "<b>#{I18n.t('exam.examresult.grade')}</b>", "<b>#{I18n.t( 'exam.examresult.term')}</b>"]]
    data2 += @detailing2
    data2+= [["<b>#{I18n.t('exam.examresult.completed_credit')}</b>", credit_hours2, "<b>#{I18n.t('exam.examresult.total_point')}</b>", "<b>#{I18n.t('exam.examresult.gpa')}</b>", "<b>#{I18n.t( 'exam.examresult.cgpa')}</b>"], ["","","<b>#{@result.total.nil? ? "" : sprintf('%.2f',@result.total)}</b>", "<b>#{@result.pngs17.nil? ? "" : sprintf('%.2f',@result.pngs17)}</b>", "<b>#{@result.pngk.nil? ? "0.00" : sprintf('%.2f',@result.pngk)}"]]
    
    
    #assign & add-in gradnd total value
    total_credit_hours=credit_hours+credit_hours2
    total_grade_points=Examresult.total_grade_points(@resultlines)
    final_cgpa=total_grade_points/total_credit_hours
    data2+=[["<b>#{I18n.t('exam.examresult.total_completed_credit')}<b>", total_credit_hours, {content: "<b>#{I18n.t('exam.examresult.total_grade_point')} : #{@view.number_with_precision(total_grade_points, precision: 2)}<b> ", colspan: 2}, "<b>#{I18n.t('exam.examresult.cgpa')} : #{@view.number_with_precision(final_cgpa, precision: 2)}</b>"]]
    
    last_row=subjects2.count+3
    move_down 10
    table(data2, :column_widths => [260,40, 80, 80, 80], :cell_style => { :size => 9, :inline_format => :true}) do
      self.width = 540
      rows(0).columns(0..6).borders=[]
      rows(1..last_row).columns(5).borders=[:left]
      columns(1..4).align=:center
    end
  end

end