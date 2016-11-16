class ResultsPdf < Prawn::Document 
  def initialize(examresult, view, college)
    super({top_margin: 30, left_margin: 20, page_size: 'A4', page_layout: :landscape })
    @examresult = examresult
    @view = view
    font "Helvetica"
    if college.code=="amsas"
      student_intake=@examresult.intake.monthyear_intake.try(:strftime, '%b %Y')
      prog_id=Intake.find(@examresult.intake_id).programme_id
      bounding_box([30,530], :width => 400, :height => 90) do |y2|
        image "#{Rails.root}/app/assets/images/logo_kerajaan.png", :scale => 0.80
      end
      bounding_box([680,530], :width => 400, :height => 90) do |y2|
        image "#{Rails.root}/app/assets/images/amsas_logo_small.png"
      end
      @subjects=Programme.find(prog_id).descendants.where(course_type: 'Subject')
      bounding_box([140, 520], :width => 500, :height => 80) do |y2|
        text "PUSAT LATIHAN DAN AKADEMI MARITIM MALAYSIA (PLAMM)", :align => :center, :size => 11, :style => :bold
	text "LAPORAN PEMARKAHAN PEPERIKSAAN",  :align => :center, :size => 11, :style => :bold
	text "#{@examresult.programmestudent.programme_list.upcase}", :align => :center, :size => 11, :style => :bold
	text "SEHINGGA #{Date.today.strftime('%d-%m-%Y')}", :align => :center, :size => 11, :style => :bold
      end
      text "#{I18n.t 'exam.examresult.examdts'} : #{@examresult.examdts.try(:strftime, '%d-%m-%Y')}", :align => :left, :size => 10
      text "#{I18n.t 'exam.examresult.examdte'} : #{@examresult.examdte.try(:strftime, '%d-%m- %Y')}", :align => :left, :size => 10
      result_table2
    elsif college.code=="kskbjb"
      text "#{I18n.t 'exam.examresult.programme_id'} : #{@examresult.programmestudent.programme_list}", :align => :left, :size => 10, :style => :bold
      text "Semester : #{@examresult.render_semester}", :align => :left, :size => 10, :style => :bold
      text "#{I18n.t 'exam.examresult.examdts'} : #{@examresult.examdts.try(:strftime, '%d %b %Y')}", :align => :left, :size => 10, :style => :bold
      text "#{I18n.t 'exam.examresult.examdte'} : #{@examresult.examdte.try(:strftime, '%d %b %Y')}", :align => :left, :size => 10, :style => :bold
      intake=@examresult.intake_group
      iyear=intake[0,4].to_i
      imonth=intake[5,2].to_i
      iday=intake[8,2].to_i
      student_intake=Date.new(iyear, imonth, iday).try(:strftime, '%b %Y')
      text "#{I18n.t 'exam.examresult.intake'} : #{student_intake}", :align => :left, :size => 10, :style => :bold
      @subjects = @examresult.retrieve_subject
      move_down 20
      result_table
    end
  end
  
  def result_table
    aa=[25, 80, 40, 60 ]
    bb=0
    for subject in @subjects
      aa << 10
      aa << 30
      bb+=40
    end
    aa+=[30, 30, 30, 30, 40]
     table(line_item_rows, :column_widths =>aa, :cell_style => { :size => 8,  :inline_format => :true}) do
      row(0).font_style = :bold
      row(0..1).background_color = 'FFE34D'
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.header = true
      self.width=(365+bb)
      #header = true
     end
  end
  
  def line_item_rows
    aa=[{content: "No", rowspan:2}, {content:  I18n.t('student.name'), rowspan:2}, {content: I18n.t('student.students.matrixno'), rowspan:2},  {content: I18n.t('student.icno'), rowspan:2}]
    bb=[]
    0.upto(@subjects.count-1).each do |cnt|
      aa << {content: @subjects[cnt].code.gsub(" ",""), colspan:2}
      bb << "G"#I18n.t('exam.grade.grading_id')
      bb << "NG"
    end
    counter = counter || 0
    header=[aa+ [{content: I18n.t('exam.examresult.total_grade_point2') , rowspan:2}, {content: I18n.t('exam.examresult.gpa2'), rowspan:2}, {content: I18n.t('exam.examresult.cgpa2'), rowspan:2}, {content: "Status", rowspan:2},{content: I18n.t('exam.examresult.remark'), rowspan:2}]]
    
    data=[]
    count=count || 0
    
    english_subjects=['PTEN', 'NELA', 'NELB', 'NELC', 'MAPE', 'XBRE', 'OTEL'] 
    posbasiks = Programme.roots.where(course_type: ['Pos Basik', 'Diploma Lanjutan', 'Pengkhususan']).pluck(:id)
    kejururawatan = Programme.roots.where('name ILIKE(?)', '%Kejururawatan%').first.id
    for examresultline in @examresult.resultlines.sort_by{|x|x.status}
      subject_part=[]
      subject_part2=[]
      credit2_all=[]
      final2_all=[]
      repeated_subjects=[]
      final2b_all=[]
      @non_ng=0
      @value_state=[]
      ng=[]
      ng2=[]
      final_marks=[]
      repeat_marks=[]
      for subject in @subjects
        @grade_student=Grade.where(subject_id: subject.id).where(student_id: examresultline.student_id)
        @student_finale=Grade.where('student_id=? and subject_id=?', examresultline.student_id,subject.id).first
        
        #Non English
        unless english_subjects.include?(subject.code[0,4]) || (subject.code.strip.size < 10 && (subject.code.strip[-2,1].to_i==2 || subject.code.strip[-2,1].to_i==3))
          credit2_all << subject.code[-1,1].to_i
          unless @student_finale.nil? || @student_finale.blank? 
            unless (@grade_student.first.exam2marks.nil? || @grade_student.first.exam2marks.blank?) 
              if @grade_student.first.resit==true
                final2b_all << @student_finale.set_NG2.to_f
                repeated_subjects << subject.id
              end
            else
                final2_all << @student_finale.set_NG.to_f
                final2b_all << @student_finale.set_NG.to_f
            end
          else
            final2_all << 0.00
          end  
        end

        if @grade_student.count > 0
          if english_subjects.include?(subject.code[0,4]) || (subject.code.strip.size < 10 && (subject.code.strip[-2,1].to_i==2 || subject.code.strip[-2,1].to_i==3))
            #English subjects column-start
            @gradeit=@grade_student.first.render_grading[-2,2]
            @non_ng+=1
            if ["C-", "D+", "D", "E"].include?(@gradeit.strip)==true
               ab=I18n.t('exam.examresult.failed')
               @value_state << '4'
            else 
               ab=I18n.t('exam.examresult.passed')
               @value_state << '3'
            end
            #repeat for english papers
            unless (@grade_student.first.exam2marks.nil? || @grade_student.first.exam2marks.blank?)
              if @grade_student.first.resit==true
                @gradeit2=@grade_student.first.render_grading2[-2,2]
                if ["C-", "D+", "D", "E"].include?(@gradeit2.strip)==true
                   cd=I18n.t('exam.examresult.failed')
                else 
                   cd=I18n.t('exam.examresult.passed') 
                end
              end
            end
            subject_part << {content: ab, colspan:2}
            subject_part2 << {content: cd, colspan:2}
            #English subject column-end
          else 
            ####
            #Other than English subjects 2 columns-start
            #Column 1: GRADE
            grade_it=@grade_student.first.render_grading[-2,2]
            #repeat for non english subject
            unless (@grade_student.first.exam2marks.nil? || @grade_student.first.exam2marks.blank?) 
              if @grade_student.first.resit==true
                grade_it2=@grade_student.first.render_grading2[-2,2] 
                subject_part2 << grade_it2
              end
            else
              subject_part2 << ""
            end
            #Column 2: NG    
            ng_it=@grade_student.first.set_NG.to_f
            ng << ng_it 
            unless (@grade_student.first.exam2marks.nil? || @grade_student.first.exam2marks.blank?) 
              if @grade_student.first.resit==true
                ng_it2=@grade_student.first.set_NG2.to_f
                ng2 << ng_it2
                subject_part2 << ng_it2
                #Retrieve final & repeat marks
                final_marks << @grade_student.first.exam1marks.to_f
                repeat_marks << @grade_student.first.exam2marks.to_f
              end
            else
              subject_part2 << ""
            end
            subject_part << grade_it
            subject_part << ng_it
            ####
          end
          @value_state << '4' if (posbasiks+[kejururawatan]).include?(@examresult.programme_id) && ["C-", "D+", "D", "E"].include?(grade_it.strip)==true
          @value_state << '3' if (posbasiks+[kejururawatan]).include?(@examresult.programme_id) && ["C-", "D+", "D", "E"].include?(grade_it.strip)==false
        else
          #Grade not exist
          @value_state << '4'
          if english_subjects.include?(subject.code[0,4]) || (subject.code.strip.size < 10 && (subject.code.strip[-2,1].to_i==2 || subject.code.strip[-2,1].to_i==3))
            subject_part << {content: I18n.t('exam.examresult.failed'), colspan:2}
          else
            subject_part << ""
            subject_part << "0.00"
          end
        end 

        #Calculate (i)NGK (Total Grade Points) - Final & Repeat
        #Calculate (ii)PNGS (GPA) - Final & Repeat
        total_point=@view.number_with_precision(Examresult.total(ng, credit2_all), precision: 2)
        repeated_total_point=@view.number_with_precision(Examresult.total(final2b_all, credit2_all), precision: 2) if @value_state.count('4') > 0 && final2b_all.count > 0 
        if final2_all.count > 0 && credit2_all.count > 0
          gpa=@view.number_with_precision((Examresult.total(ng, credit2_all) / credit2_all.sum), precision: 2)
        else
          gpa=0.00
        end
        #Repeat : step3 
        #For Repeat - final2b_all != final2_all
        if final2b_all.count > 0 && credit2_all.count > 0 && final2b_all!=final2_all
          gpa_repeat=@view.number_with_precision((Examresult.total(final2b_all, credit2_all) / credit2_all.sum), precision: 2)
        end
          
        #Calculate (iii)PNGK (CGPA)
        semno=@examresult.semester.to_i-1
        programmeid=@examresult.programme_id
        examresult_ids=Examresult.where(programme_id: programmeid).pluck(:id)
        @resultlines = Resultline.where(examresult_id: examresult_ids, student_id: examresultline.student_id).order(created_at: :asc)
        cgpa=@view.number_with_precision(Examresult.cgpa_per_sem(@resultlines, semno), precision: 2) if @resultlines.count-1>=semno
        cgpa_be4_repeat= @view.number_with_precision(Examresult.total(ng, credit2_all) / credit2_all.sum, precision: 2)  
      
        #Retrieve STATUS
        fisioterapi=Programme.where(course_type: 'Diploma').where('name ILIKE (?)', '%Fisioterapi%').first.id
        perubatan=Programme.where(course_type: 'Diploma').where('name ILIKE (?)', 'Penolong Pegawai Perubatan').first.id
        if [fisioterapi, perubatan].include?(examresultline.examresult.programme_id)
          status_viewing=examresultline.render_status_contra
        else
          status_viewing=examresultline.render_status   
        end
        #2-when FAIL final exam
        #For Repeat - final2b_all != final2_all
        if @value_state.include?('4') && final2b_all!=final2_all
          #display previous (FAIL) Final exam status as failed
          previous_status=I18n.t('exam.examresult.failed')
        end
      
        #Retrieve REMARK-----
        rem=""
        #1-Display Ulang Subjek...when NG2 exist (repeat marks exist)
        if @value_state.uniq.include?('4') && repeated_subjects.count > 0
          rem2=(DropDown::RESULT_REMARK.find_all{|disp, value| value == "1"}).map {|disp, value| disp}[0]+" "
          cnt=0
          Programme.where(id: repeated_subjects).each do |subject|
            rem2+="<br>" if cnt < repeated_subjects.count
            rem2+=subject.code.gsub(" ", "")
            cnt+=1
          end
        end
        #2-Display LATEST REMARK accordingly
        #NOTE - examresultline.remark & examresultline.render_remark - refers to LATEST saved remark in DB   
        if examresultline.remark=='1' 
          #display 'Ulang Subjek' je if remarked as one (repeat marks not exist yet)
          rem= examresultline.render_remark        
        elsif examresultline.remark=='2'
          #Display VIVA - NOTE - definitely status for REPEAT paper 
          rem=examresultline.render_remark
          #display repeated subject (still fail) for VIVA - but Repeat marks > Final marks
          ng2.each_with_index do |nn, ind|
            if nn < 2.0
               if repeat_marks[ind] > final_marks[ind]
                 rem+=Programme.where(id: repeated_subjects)[ind].code.gsub(" ", "")
               end
	    end
	  end
        else
         rem=examresultline.render_remark
         #Display Remark other than 'Ulang Subjek' & 'VIVA'
        end
      
      end
      if repeated_total_point
        data << [{content: "#{count+=1}", rowspan:2} , {content: examresultline.student.name, rowspan:2}, {content: examresultline.student.matrixno, rowspan:2}, {content: examresultline.student.icno, rowspan: 2}]+subject_part+[total_point, gpa ,cgpa_be4_repeat, status_viewing, rem2]
        data << subject_part2+[repeated_total_point, gpa_repeat, cgpa, previous_status,rem]
      else
        data << [count+=1, examresultline.student.name, examresultline.student.matrixno, examresultline.student.icno]+subject_part+[total_point, gpa ,cgpa,   status_viewing, rem]
      end
      
    end
    header+[bb]+data
  end
  
  def result_table2
    aa=[25, 150, 70]
    bb=0
    subject_count=@subjects.count
    if subject_count > 6
      for subject in @subjects
         bb+=30#40
         aa << 30#40
      end
    else
      for subject in @subjects
         bb+=80
         aa << 80
      end
    end
    aa << 35
    bb+=35
    table(line_item_rows2, :column_widths =>aa, :cell_style => { :size => 8,  :inline_format => :true, :padding => [5,0,5,2]}) do
      row(0).font_style = :bold
      row(0).background_color = 'FFE34D'
      row(0).columns(0..2).valign=:center
      row(0).columns(subject_count+3).valign=:center
      if subject_count > 6
        row(0).columns(3..subject_count+3-1).rotate = 90 #http://stackoverflow.com/questions/40139848/bottom-to-top-text-in-column-of-prawn-table
        row(0).height=70
      else
        row(0).columns(3..subject_count+3-1).valign=:center
        row(0).height=35
      end
      
      self.row_colors = ["FEFEFE", "FFFFFF"]
      self.width=(245+bb)
    end
  end
  
  def line_item_rows2
    aa=["No", "#{I18n.t('exam.examresult.student')}", "#{ I18n.t('student.icno')}"]
    0.upto(@subjects.count-1).each do |cnt|
       aa << "#{@subjects[cnt].code}"
    end
    counter = counter || 0
    header=[aa+["Status"]]
    data=[]
    count=count || 0
    
    for examresultline in @examresult.resultlines.sort_by{|x|x.status}
      details= [count+=1, examresultline.student.student_with_rank, examresultline.student.icno]
      subjectscol=[]
      for subject in @subjects
        grades=Grade.where(subject_id: subject.id).where(student_id: examresultline.student_id)
        if grades.count > 0
          finalscore=@view.pukka(grades.first.finalscore).to_s+" %"
        else
          finalscore=""
        end
        subjectscol << finalscore
      end
      data << details+subjectscol+[examresultline.render_status_contra]
    end
    header+data
  end
 
end