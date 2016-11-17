class Exam::GradesController < ApplicationController
  filter_access_to :index, :new, :create, :new_multiple, :create_multiple, :edit_multiple, :update_multiple, :grade_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  before_action :set_grade, only: [:show, :edit, :update, :destroy]
  before_action :set_index_data, only: [:index, :grade_list]
  before_action :set_data_edit_update_new_create, only: [:edit, :update, :new, :create]
  before_action :set_new_multiple_create_multiple, only: [:new_multiple, :create_multiple]

  # GET /grades
  # GET /grades.xml
  def index
    respond_to do |format|
      if @grades && @grades_group
        format.html # index.html.erb
        format.xml  { render :xml => @grades }
      else
        format.html { redirect_to(dashboard_url, :notice =>t('positions_required')+(t 'exam.title')+" - "+(t 'exam.grade.title')) }
      end
    end
  end
  
  def new
    @grade = Grade.new
    @grade.scores.build
  end
  
  def create
    @grade = Grade.new(grade_params) 
    respond_to do |format|
      if @grade.save
        if Programme.roots.where(course_type: 'Diploma').pluck(:id).include?(@grade.subjectgrade.root_id) && (@grade.scores && @grade.scores.count > 0) && (@grade.scores.map(&:weightage).sum > 30 || @grade.scores.map(&:marks).sum > 30)
#           if @grade.scores && @grade.scores.count > 0
#             if @grade.scores.map(&:weightage).sum > 30 || @grade.scores.map(&:marks).sum > 30
              flash[:notice]= t('exam.grade.max_weightage_marks_30')
              format.html { render :action => "edit" }
              format.xml  { head :ok }
              flash.discard
#             else
#               #as formative scores entered are VALID, path to show
#               format.html { redirect_to exam_grade_path(@grade) , :notice =>  t('exam.grade.title')+t('actions.created') }
#               format.xml  { render :xml => @grade, :status => :created, :location => @grade } 
#             end
#           else
#             #no need to check if formative scores not exist at all, path to show
#             format.html { redirect_to exam_grade_path(@grade) , :notice =>  t('exam.grade.title')+t('actions.created') }
#             format.xml  { render :xml => @grade, :status => :created, :location => @grade } 
#           end
        else
          #no need to check at all if not Diploma, path to show
          format.html { redirect_to exam_grade_path(@grade) , :notice =>  t('exam.grade.title')+t('actions.created') }
          format.xml  { render :xml => @grade, :status => :created, :location => @grade } 
        end
      else
        format.html { render :new }                                      
        format.xml  { render :xml => @grade.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /grades/1/edit
  def edit
    @grade = Grade.find(params[:id])
  end
  
  def update
    @grade = Grade.find(params[:id])
    submit_type = params[:grade_submit_button]
    respond_to do |format|
      if @grade.update(grade_params)
        if  submit_type == t('update')
          flash[:notice] = t('exam.grade.title')+t('actions.updated')
          format.html { redirect_to exam_grade_path(@grade) }
          format.xml  { head :ok }
        elsif submit_type == t('exam.grade.apply_changes')
          flash[:notice]=t('exam.grade.formative_summative_var_updated2')
          format.html { render :action => "edit" }
          format.xml  { head :ok }
        end
        flash.discard
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @grade.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def new_multiple
#     @subjectid=params[:subjectid]
    #@intakes_lt = @student_list.pluck(:intake).uniq.sort
    unless @subjectid.nil?
      @grades = Array.new(1) { Grade.new }
      @selected_subject = Programme.where(id: @subjectid).first.subject_list
      @selected_exam = Exam.where(subject_id: @subjectid).where(name: 'F').order(exam_on: :desc).first
      existing_grade_students=Grade.where(subject_id: @subjectid).pluck(:student_id)
      programme_id=Programme.where(id: @subjectid).first.root_id
      #existing_grade_intakes=Student.where(course_id: programme_id).where(id: existing_grade_students).pluck(:intake).uniq
      exist_intake_ids=Student.where(course_id: programme_id).where(id: existing_grade_students).pluck(:intake_id).uniq
      existing_grade_intakes=Intake.where(id: exist_intake_ids).pluck(:monthyear_intake).sort
      #@intakes_lt=Student.where(course_id: programme_id).where.not(intake: existing_grade_intakes).pluck(:intake).uniq.sort
      nonexist_intake_ids=Student.where(course_id: programme_id).where.not(intake_id: exist_intake_ids).pluck(:intake_id).uniq
      @intakes_lt=Intake.where(id: nonexist_intake_ids).pluck(:monthyear_intake).sort
      @exist=existing_grade_intakes
    else
      flash[:notice] ='Select subject'
      redirect_to exam_grades_path
    end
  end
  
  def create_multiple
    ##sample from Exammarks 
    selected_intake = params[:grades]["0"][:intake_id]
    @subjectid = params[:grades]["0"][:subject_id]                                                       #required if render new_multiple
    #@programme_id = params[:exammarks]["0"][:programme_id]                                  #required if render new_multiple
    #@selected_exam = Exam.find(@examid)                                                                   #required if render new_multiple
    @programme_id=Programme.where(id: @subjectid).first.root_id
    existing_grade_students=Grade.where(subject_id: @subjectid).pluck(:student_id)
    #existing_grade_intakes=Student.where(course_id: @programme_id).where(id: existing_grade_students).pluck(:intake).uniq
      #@intakes_lt=Student.where(course_id: @programme_id).where.not(intake: existing_grade_intakes).pluck(:intake).uniq.sort
    nonexist_intake_ids=Student.where(course_id: @programme_id).where.not(id: existing_grade_students).pluck(:intake_id).uniq
    @intakes_lt=Intake.where(id: nonexist_intake_ids).order(monthyear_intake: :desc).pluck(:monthyear_intake)
    #@intakes_lt = Student.where('course_id=?',@programme_id).pluck(:intake).uniq    #required if render new_multiple
                                               
    @grade = Grade.new
    #qcount = @exammark.get_questions_count(@examid)
    #current_program = Programme.find(Exam.find(@examid).subject_id).root_id
    #selected_student = Student.where(course_id: current_program.to_i, intake: selected_intake)
    
    #selected_student = Student.where(course_id: @programme_id, intake: selected_intake)
    #above - before include previous intake(repeat semester) students
    # NOTE - 22Feb2016 - include Repeat Semester students (previous Intake) 
    #related files: 1) views/examresults/_form_results.html.haml, 2)model/examresult.rb 3)exammarks_controllers.rb 4)model/grade.rb - redundants allowed only for student with sstatus=='Repeat' (Repeat Semester)
    
    # TODO - kskbjb - all student records must use 'intake_id' field - 17Nov2016
    #previous_intake = Student.where(course_id: @programme_id).where('intake < ?', selected_intake).order(intake: :desc).first.try(:intake)
    #selected_student = Student.where(course_id: @programme_id).where('intake=? or (intake=? and sstatus=?)', selected_intake, previous_intake, 'Repeat')
    previous_intakes=Intake.where(programme_id: @programme_id).where('monthyear_intake <?', selected_intake).order(monthyear_intake: :desc)
    if previous_intakes.count > 0 
      previous_intake=previous_intakes.first.id
    else
      previous_intake=[]
    end
    selected_intake_id=Intake.where(programme_id: @programme_id).where(monthyear_intake: selected_intake).first.id
    selected_student = Student.where(course_id: @programme_id).where('intake_id=? or (intake_id=? and sstatus=?)', selected_intake_id, previous_intake, 'Repeat')
    
    rec_count = selected_student.count
    @grades = Array.new(rec_count) { Grade.new }                      
    @grades.each_with_index do |grade,ind|                                     
      grade.student_id = selected_student[ind].id
      grade.subject_id = @subjectid
      if Programme.where(course_type: 'Diploma').pluck(:id).include?(@programme_id)
        grade.examweight = 70 
      else
        grade.examweight = 0
      end
      grade.exam1marks=0
      grade.finalscore=0
      #0.upto(qcount-1) do
      #  exammark.marks.build
      #end       
    end
    if @grades.all?(&:valid?) 
      @grades.each(&:save!)
      flash[:notice] = t('exam.exammark.multiple_created')
      render :action => 'edit_multiple', :grade_ids =>@grades.map(&:id)
    else                                                                      
      flash[:notice] = t('exam.grade.grades_intakes_exist')
      render :action => 'new_multiple', params[:grades]["0"][:intake_id] => selected_intake, params[:grades]["0"][:subject_id] => @subjectid
    end
    ##end sample from Exammarks
  end
  
  def edit_multiple
    @gradeids = params[:grade_ids]
    unless @gradeids.blank? 
      @grades = Grade.where(id: @gradeids).sort_by{|x|x.studentgrade.name} #@grades = Grade.find(@gradeids)
      @grades_obj = @grades[0]
      @edit_type = params[:grade_submit_button]
      if @edit_type ==  t('edit_checked') 
        ## continue multiple edit (including subject edit here) --> refer view
      end 
    else  
      flash[:notice] = t 'exam.exammark.select_one'
      redirect_to exam_grades_path
    end
  end
  
  def update_multiple
    #raise params.inspect
    @gradeids = params[:grade_ids]
    unless @gradeids.blank?
      @grades = Grade.find(@gradeids)
      @grades_obj = @grades[0]
      submit_type = params[:grade_submit_button]
      ##########################
      @caplusmse = params[:scores] #**
      @examweights = params[:examweights]  
      #if @subjects_of_grades==1 || submit_type == t('exam.grade.apply_changes')
        @summative_weightage = (params[:grade][:summative_weightage]).to_f
        @scores = params[:scores_attributes]
        @scores_new_count = @scores.count if @scores
      #end
      if submit_type == t('update')
        
        #start-scores (marks) only exist for EXISTing formative_scores (not yet exist if just ADDED - apply_changes)
        #@formatives = params[:formatives]
        @formatives=[]
        all_scores = params[:scores_attributes]   #all_scores["0"]["marks"].first.to_f - gives 90.00
        if all_scores && all_scores["0"]["marks"]
          grade_qty = all_scores["0"]["marks"].count  #@grades.count
          scoretype_qty = all_scores.count
          0.upto(grade_qty-1) do |bil|
            mks = 0
            0.upto(scoretype_qty-1) do |no|
              if all_scores[no.to_s]["marks"]
                aa = all_scores[no.to_s]["marks"][bil]
                mks+=all_scores[no.to_s]["marks"][bil].to_f
              end
            end
            @formatives << mks
          end
        else
          #refer below for notice
        end
        #end-scores (marks) only exist for EXISTing formative_scores (not yet exist if just ADDED - apply_changes)
        
      end
      #@scores1 = params[:scores] #caplusmse
      @exam1markss = params[:exam1markss]
      @summatives = params[:summatives]
      @finalscores = params[:finalscores]
      @grading_ids = params[:grading_ids]
      @senttobpls = params[:sent_to_BPLs]                    # "sent_to_BPLs"=>{"2"=>"true"}, "sent_to_BPLs"=>{"1"=>"true","2"=>"true"}	  
      @eligibleexams = params[:eligible_for_exams]
      @carrypapers = params[:carry_papers] 
      @resits = params[:resits]
      ##########################
  
      if submit_type == t('update')
        ####
        @exceed_maximum=[]
        @exceed_maximum2=[]
        #below (add-in sort_by) in order to get data match accordingly to form values (sorted by student name)
        @grades.sort_by{|x|x.studentgrade.name}.each_with_index do |grade, index| 

          grade.formative = @formatives[index]# - save Total Formative = Sum of formative scores.  ####total_formative2-refer model##
          grade.score = @caplusmse[index]
          if @examweights
            grade.examweight = @examweights[0] if @examweights.count==1       #for selected grades with different subject
            grade.examweight = @examweights[index] if @examweights.count>1
          end
          
          #---BIG PROBLEM-SAVE SCORE TABLE SEPARATELY - RESOLVE..TEMPORARY-10JUN2013-AM-START-replace grades.score... with y.marks...
          scores_of_grades = Score.where('grade_id=?',grade.id)
          scores_of_grades.sort_by{|x|x.created_at}.each_with_index do |y,no| #tak boleh by created_at?
             y.marks = params[:scores_attributes][no.to_s][:marks][index]
             y.save
          end
          #---BIG PROBLEM-SAVE SCORE TABLE SEPARATELY - RESOLVE..TEMPORARY-10JUN2013-AM-END------------------------------------------
       
          grade.exam1marks=@exam1markss[index]
          grade.summative=@summatives[index]
          grade.finalscore=@finalscores[index]
          grade.grading_id=@grading_ids[index]
          if @subjects_of_grades==1 
           
            #--BIG PROBLEM-remove to line 331 but yet replace with direct SAVING DATA INTO SCORES table instead of grades.scores...
            #0.upto(grade.scores.count-1) do |score_count|
              #grade.scores[score_count].marks = params[:scores_attributes][score_count.to_s][:marks][index]
            #end
            #--end of BIG PROBLEM
          end 

          #checkboxes values - note : hashes, only exist if value is TRUE
          if @senttobpls && @senttobpls[index.to_s]!=nil
            grade.sent_to_BPL = true
            grade.sent_date = Date.today
          else
            grade.sent_to_BPL = false
          end 
          if @eligibleexams && @eligibleexams[index.to_s]!=nil
            grade.eligible_for_exam = true
          else
            grade.eligible_for_exam = false
          end
          if @carrypapers &&@carrypapers[index.to_s]!=nil
            grade.carry_paper = true
          else
            grade.carry_paper = false
          end
          if @resits && @resits[index.to_s]!=nil
            grade.resit = true
          else
            grade.resit = false
          end
          @exceed_maximum << grade.studentgrade.matrix_name if grade.formative > grade.scores.sum(:weightage) || grade.summative > grade.examweight
          @exceed_maximum2 << grade.id if (grade.scores.sum(:weightage)+grade.examweight).to_f > 100.0
          grade.save
        end  #--end of @grades.each_with_index do |grade,index|--
        ####
        respond_to do |format|
          if all_scores && all_scores["0"]["marks"]
              if @exceed_maximum.count==0 && @exceed_maximum2.count==0
                  format.html { redirect_to(exam_grades_url, :notice =>t('exam.grade.multiple_updated')+" ("+"#{@grades[0].subjectgrade.subject_list}"+" - "+"#{@grades.count}"+" "+t('records')+")") }
                  format.xml  { head :ok }
              else
                  if @exceed_maximum.count > 0
                    students=""
                    @exceed_maximum.each{|x|students+=x+", "}
                    flash[:notice]=(t 'exam.grade.exceed_maximum')+" ("+@exceed_maximum.count.to_s+" "+(t 'records')+") : " +students.gsub(/, $/,"") #students.gsub(students[-2,2],"")
                  end
                  if @exceed_maximum2.count > 0
                    flash[:notice]=t('exam.grade.total_weight')+"("+(t 'exam.grade.formative')+" : "+@grades[0].scores.sum(:weightage).to_i.to_s+"%, "+(t 'exam.grade.summative2')+" : "+@grades[0].examweight.to_i.to_s+"%)"
                  end
                  format.html {render :action => 'edit_multiple'}
                  format.xml  { head :ok }
              end
          else
              flash[:notice]=(t 'exam.grade.scores_not_exist')
              format.html {render :action => 'edit_multiple'}
              format.xml  { head :ok }
          end
        end
      elsif submit_type == t('exam.grade.apply_changes')
  
        #edit & update EXISTING 'Formative Scores' items & 'Summative Weightage' accordingly (if there's any changes)
        @grades.sort_by{|x|x.studentgrade.name}.each_with_index do |grade, index| 
          scores = Score.where(grade_id: grade.id).order(created_at: :asc)#sort_by{|y|y.created_at}
          0.upto(grade.scores.count-1) do |score_count|
            #Please note : use this : params[:scores_attributes][score_count.to_s][:type_id] INSTEAD OF this:params[:scores_attributes][score_count.to_s][:type_id][index]
            #grade.scores[score_count].type_id = params[:scores_attributes][score_count.to_s][:type_id]
            #grade.scores[score_count].description = params[:scores_attributes][score_count.to_s][:description]# "AAA"
            #grade.scores[score_count].weightage = params[:scores_attributes][score_count.to_s][:weightage]
            #rails 4 : above FAILS, the other way
            scores[score_count].type_id = params[:scores_attributes][score_count.to_s][:type_id]
            scores[score_count].description = params[:scores_attributes][score_count.to_s][:description]
            scores[score_count].weightage = params[:scores_attributes][score_count.to_s][:weightage]
            scores[score_count].save
          end
          grade.examweight = @summative_weightage #this shall replace prev saved value
          grade.save
        end

        #create & save NEW 'Formative Scores' items & 'Summative Weightage' accordingly        
        @grades.sort_by{|x|x.studentgrade.name}.each_with_index do |grade, index|  
          if @scores_new_count
            if @scores_new_count >= @grades[index].scores.count
              (grade.scores.count).upto(@scores_new_count-1) do |c|
                #grade.scores.build
                #grade.scores[c].type_id = params[:scores_attributes][c.to_s][:type_id]#@grade_scores[2].type_id         
                #grade.scores[c].description = params[:scores_attributes][c.to_s][:description]#@grade_scores[2].description 
                #grade.scores[c].weightage = params[:scores_attributes][c.to_s][:weightage]#@grade_scores[2].weightage
                #grade.scores[c].marks = 0
                #grade.examweight = @summative_weightage 
                #grade.save
                #rails 4 : above FAILS, the other way
                score = Score.new
                score.type_id = params[:scores_attributes][c.to_s][:type_id]
                score.description = params[:scores_attributes][c.to_s][:description]
                score.weightage = params[:scores_attributes][c.to_s][:weightage]
                score.marks = 0
                score.grade_id = grade.id
                score.save
              end
            end #ending - scores_new_count
          end
        end
        
        respond_to do |format|
          if @scores_new_count
            flash[:notice]=t('exam.grade.formative_summative_var_updated')
          else
            flash[:notice]=(t 'exam.grade.scores_not_exist')
          end
          format.html {render :action => 'edit_multiple'}
          format.xml  { head :ok }
          flash.discard
        end

      end
    end #end for unless
    
  end
  
  # DELETE /grades/1
  # DELETE /grades/1.xml
  def destroy
    @grade = Grade.find(params[:id])
    @grade.destroy

    respond_to do |format|
      format.html { redirect_to(exam_grades_url) }
      format.xml  { head :ok }
    end
  end
  
  def add_formative
    @data="yaya"
     respond_to do |format|
      format.js 
     end
  end

  def grade_list
    respond_to do |format|
      format.pdf do
        pdf =Grade_listPdf.new(@grades_all, view_context, current_user.college)
        send_data pdf.render, filename: "grade_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  private
  
  # Use callbacks to share common setup or constraints between actions.
    def set_grade
      @grade = Grade.find(params[:id])
    end
    
    def set_index_data
      ############
      valid_exams = Exammark.get_valid_exams
      @grade_list_exist_subject=[]
      @existing_grade_subject_ids = Grade.all.pluck(:subject_id).uniq
      @position_exist = @current_user.userable.positions
      @common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
      posbasics=['Pos Basik', 'Diploma Lanjutan', 'Pengkhususan']
      roles=@current_user.roles.pluck(:authname)
      ###
      if @position_exist && @position_exist.count > 0 
        @lecturer_programme = @current_user.userable.positions[0].unit
        common_subject_a = Programme.where('course_type=?','Commonsubject')
        unless @lecturer_programme.nil?
          @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0) if posbasics.include?(@lecturer_programme)==false
        end
        unless @programme.nil? || @programme.count == 0
          programme_id = @programme.first.id
          if current_user.college.code=="kskbjb"
            @subjectlist_preselec_prog = Programme.find(programme_id).descendants.at_depth(2)  #.sort_by{|y|y.code}
          else 
            @subjectlist_preselec_prog = Programme.find(programme_id).descendants.where(course_type: 'Subject')
          end
          #subjects - only those with existing exampaper
          @subjectlist_preselec_prog2_raw = Programme.where('id IN (?) AND id IN (?)',@subjectlist_preselec_prog.map(&:id), Exam.where('id IN(?) and name=?', valid_exams, 'F').map(&:subject_id))
          #@subjectlist_preselec_prog2_raw = Programme.where('id IN (?) AND id IN (?) and id NOT IN(?)',@subjectlist_preselec_prog.map(&:id), Exam.where('id IN(?) and name=?', valid_exams, 'F').map(&:subject_id), common_subject_a.map(&:id))
          #subjects - ALL subject of current programme
          #@subjectlist_preselec_prog2_raw = Programme.where('id IN (?) AND id NOT IN(?)',@subjectlist_preselec_prog.map(&:id), common_subject_a.map(&:id))
        else
          tasks_main = @current_user.userable.positions[0].tasks_main
          if @common_subjects.include?(@lecturer_programme)
            programme_id ='1'
            @subjectlist_preselec_prog = common_subject_a
          elsif posbasics.include?(@lecturer_programme) && tasks_main!=nil
            ###
            # NOTE - posbasic SUP has access to all posbasic programmes
            #if @current_user.roles.pluck(:authname).include?("programme_manager")
                #@subjectlist_preselec_prog = Programme.where(course_type: posbasics).first.descendants.at_depth(2)
                post_prog=Programme.where(course_type: posbasics)
                subject_ids=[]
                post_prog.each do |postb|
                  postb.descendants.each{|des|subject_ids << des.id if des.course_type=="Subject" || des.course_type=="Commonsubject"}
                end
                @subjectlist_preselec_prog=Programme.where(id: subject_ids)
                programme_id='2'
                subjects_valid_exam= Exam.where(id: valid_exams).where(name: 'F').pluck(:subject_id)
                @subjectlist_preselec_prog2_raw = Programme.where(id: @subjectlist_preselec_prog.map(&:id)).where(id: subjects_valid_exam)
            #else
            #    allposbasic_prog = Programme.where(course_type: posbasics).pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
            #    for basicprog in allposbasic_prog
            #      lecturer_basicprog_name = basicprog if tasks_main.include?(basicprog)==true
            #    end
            #    programme_id=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
            #    @subjectlist_preselec_prog = Programme.where(id: programme_id).first.descendants.at_depth(2)
            #end
            ###
          elsif roles.include?("developer") || roles.include?("administration") || roles.include?("exam_grade_module_admin") || roles.include?("exam_grade_module_viewer") ||  roles.include?("exam_grade_module_user")
            programme_id='0'
            if current_user.college.code=="kskbjb"
              @subjectlist_preselec_prog = Programme.at_depth(2) 
            else
              @subjectlist_preselec_prog = Programme.where(course_type: 'Subject')
            end
          else
            leader_unit=tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if tasks_main!="" && tasks_main.include?('Program')
            if leader_unit
              @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0) 
              programme_id = @programme.first.id
              @subjectlist_preselec_prog = Programme.find(programme_id).descendants.at_depth(2) 
              @subjectlist_preselec_prog2_raw = Programme.where('id IN (?) AND id IN (?) and id NOT IN(?)',@subjectlist_preselec_prog.map(&:id), Exam.where('id IN(?) and name=?', valid_exams, 'F').map(&:subject_id), common_subject_a.map(&:id))
            end
          end

          #subject no longer available for NEW multiple when ALL available Intakes already have at least ONE grade entry
          @ssubject_grade_exist=[]
          Grade.where(subject_id: @subjectlist_preselec_prog.map(&:id)).group_by(&:subject_id).each do |subjectid, grades|
            progid=Programme.where(id: subjectid).first.root_id
            exist_students=grades.map(&:student_id)
            exist_intakes=Student.where(id: exist_students).pluck(:intake)
            available_students=Student.where(course_id: progid).pluck(:id)
            available_intakes=Student.where(id: available_students).pluck(:intake)
            #when all intakes already hv at least ONE grade entry
            if exist_intakes.count == available_intakes.count 
              @ssubject_grade_exist << subjectid
            end
          end

          #subjects - only those with existing exampaper & not even 1 grade exist
          @subjectlist_preselec_prog2_raw = Programme.where('id IN (?) AND id IN (?)',@subjectlist_preselec_prog.map(&:id), Exam.where('id IN(?)',   valid_exams).map(&:subject_id)).where.not(id: @ssubject_grade_exist)
          #subjects - ALL subjects
          #@subjectlist_preselec_prog2_raw = Programme.where('id IN (?)',@subjectlist_preselec_prog.map(&:id))
        end
      
        #all subjects for NEW Multiple
        @subjectlist_preselec_prog2 = []
        @subjectlist_preselec_prog2_raw.each do |x|
          @subjectlist_preselec_prog2 << [x.programme_subject, x.id]
        end
      
        #existing subject of all grades for Search
        @grade_list_exist_subject_raw= Programme.where('id IN(?) and id IN(?)', @existing_grade_subject_ids, @subjectlist_preselec_prog.pluck(:id)).order(id: :asc)
        @grade_list_exist_subject = []
        @grade_list_exist_subject_raw.each do |x|
          @grade_list_exist_subject << [x.programme_subject, x.id]
        end
      
        @search = Grade.search(params[:q])
        @grades_all = @search.result.search2(programme_id)
        @grades = @grades_all.page(params[:page]||1)
        #@grades = Kaminari.paginate_array(@sdc).page(params[:page]||1) 
        @grades_group = @grades.group_by{|x|x.subject_id}
      end
      ###
      ############
    end
    
    def set_data_edit_update_new_create
      valid_exams = Exammark.get_valid_exams
      @position_exist = @current_user.userable.positions
      roles=@current_user.roles.pluck(:authname)
      ##
      if @position_exist     
        @lecturer_programme = @current_user.userable.positions[0].unit
        common_subject_a = Programme.where('course_type=?','Commonsubject')
        @common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
        posbasics=['Pos Basik', 'Diploma Lanjutan', 'Pengkhususan']
        unless @lecturer_programme.nil?
          @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0) if posbasics.include?(@lecturer_programme)==false
        end
        unless @programme.nil? || @programme.count == 0
          @preselect_prog = @programme.first.id
          @programme_names=Programme.where(id: @preselect_prog).map(&:programme_list)
          @programme_detail=@programme.first.programme_list
          @subjects=Programme.subject_groupbyoneprogramme2_grade(@preselect_prog)
          @students=Student.groupby_oneprogramme(@preselect_prog)
        else
          ####
          tasks_main = @current_user.userable.positions[0].tasks_main
          if @common_subjects.include?(@lecturer_programme)  # if @lecturer_programme == 'Commonsubject'
            prog_ids=[]
            Programme.where(id: common_subject_a).each{|x| prog_ids << x.root_id}
            @programme_names=Programme.where(id: prog_ids.uniq).order('course_type, name ASC').map(&:programme_list)
            @subjects=Programme.subject_groupbycommonsubjects2_grade #new only
            @students=Student.groupby_programme
          elsif posbasics.include?(@lecturer_programme) && tasks_main!=nil
            # NOTE - Posbasic SUP has access to all Postbasic programme
            #if @current_user.roles.pluck(:authname).include?("programme_manager")
              @programme_names=Programme.where(course_type: posbasics).map(&:programme_list)
              @subjects=Programme.subject_groupbyposbasiks2_grade #new only
              @students=Student.groupby_posbasics
            #else#all posbasic lecturer EXCEPT Ketua Program Pengkhususan
            #  @preselect_prog=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
            #  @programme_names=Programme.where(id: @preselect_prog).map(&:programme_list)
            #  @subjects=Programme.subject_groupbyoneprogramme2_grade(@preselect_prog) #new only
            #  @students=Student.groupby_oneprogramme(@preselect_prog)
            #end
          elsif roles.include?("developer") || roles.include?("administration") || roles.include?("exam_grade_module_admin")  || roles.include?("exam_grade_module_viewer") || roles.include?("exam_grade_module_user")
            @programme_names=Programme.programme_names
            @subjects=Programme.all_subjects_groupbyprogramme_grade #new only
            @students=Student.groupby_programme
          else
            leader_unit=tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if tasks_main!="" && tasks_main.include?('Program')
            if leader_unit
              @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0) 
              @preselect_prog = @programme.first.id
              @programme_names=Programme.where(id: @preselect_prog).map(&:programme_list)
              @programme_detail=@programme.first.programme_list
              @subjects=Programme.subject_groupbyoneprogramme2_grade(@preselect_prog)
              @students=Student.groupby_oneprogramme(@preselect_prog)
            end
          end 
	  ## ----------------------------- 
          ####
        end
      end
      ##
    end
    
    def set_new_multiple_create_multiple
      valid_exams = Exammark.get_valid_exams
      @subjectid=params[:subjectid]
      @lecturer_programme = @current_user.userable.positions.first.unit
      common_subject_a = Programme.where(course_type: 'Commonsubject')
      posbasics=["Pos Basik", "Diploma Lanjutan", "Pengkhususan"]
      common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
      unless @lecturer_programme.nil?
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0) if posbasics.include?(@lecturer_programme)==false
      end
      unless @programme.nil? || @programme.count == 0
        @preselect_prog = @programme.first.id
        @student_list = Student.where(course_id: @preselect_prog).order(name: :asc)
        @subject_list = Programme.where(id: @preselect_prog).first.descendants.at_depth(2)
        #@intake_list = @student_list.group_by{|l|l.intake}
      else
        if common_subjects.include?(@lecturer_programme)
           #@student_list = Student.all 
           @subject_list = common_subject_a
        else
           #@student_list = Student.all 
           @subject_list = Programme.at_depth(2) 
        end
        #for administrator & Commonsubject lecturer : to assign programme, based on selected exampaper 
        #@subjectid2 = params[:subjectid]  #force - Retrieve this params value TWICE
        #@dept_unit = Programme.where(id: @subjectid2).first.root  
        #@student_list = Student.where(course_id: @dept_unit.id)#.group_by{|l|l.intake}
	 if @subjectid
            @dept_unit = Programme.where(id: @subjectid).first.root
            @dept_unit_prog = @dept_unit.programme_list
            @programme_id=@dept_unit.id
          end
      end
      #@intakes=@student_list.pluck(:intake).uniq.sort
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def grade_params
      params.require(:grade).permit(:student_id, :subject_id, :sent_to_BPL, :sent_date, :formative, :score, :eligible_for_exam, :carry_paper, :summative, :resit, :finalscore, :grading_id, :exam1name, :exam1desc, :exam1marks, :exam2name, :exam2desc, :exam2marks, :examweight, :summative_weightage, :college_id, {:data => []}, scores_attributes: [:id,:_destroy, :type_id, :description, :marks, :weightage, :score, :completion, :formative])
    end
  
end