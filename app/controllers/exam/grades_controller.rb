class Exam::GradesController < ApplicationController
  filter_access_to :all 
  before_action :set_grade, only: [:show, :edit, :update, :destroy]
  before_action :set_data_edit_update_new_create, only: [:edit, :update, :new, :create]
  before_action :set_new_multiple_create_multiple, only: [:new_multiple, :create_multiple]

  # GET /grades
  # GET /grades.xml
  def index
    valid_exams = Exammark.get_valid_exams
    @grade_list_exist_subject=[]
    @existing_grade_subject_ids = Grade.all.pluck(:subject_id).uniq
    @position_exist = @current_user.userable.positions
    @common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
    posbasics=['Pos Basik', 'Diploma Lanjutan', 'Pengkhususan']
    ###
    if @position_exist && @position_exist.count > 0
      @lecturer_programme = @current_user.userable.positions[0].unit
      common_subject_a = Programme.where('course_type=?','Commonsubject')
      unless @lecturer_programme.nil?
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0) if posbasics.include?(@lecturer_programme)==false
      end
      unless @programme.nil? || @programme.count == 0
        @preselect_prog = @programme.first.id
        programme_id = @programme.first.id
        @subjectlist_preselec_prog = Programme.find(@preselect_prog).descendants.at_depth(2)  #.sort_by{|y|y.code}
        #subjects - only those with existing exampaper
        @subjectlist_preselec_prog2_raw = Programme.where('id IN (?) AND id IN (?) and id NOT IN(?)',@subjectlist_preselec_prog.map(&:id), Exam.where('id IN(?) and name=?', valid_exams, 'F').map(&:subject_id), common_subject_a.map(&:id))
        #subjects - ALL subject of current programme
        #@subjectlist_preselec_prog2_raw = Programme.where('id IN (?) AND id NOT IN(?)',@subjectlist_preselec_prog.map(&:id), common_subject_a.map(&:id))
      else
        tasks_main = @current_user.userable.positions[0].tasks_main
        if @common_subjects.include?(@lecturer_programme)
          programme_id ='1'
          @subjectlist_preselec_prog = common_subject_a
        elsif posbasics.include?(@lecturer_programme) && tasks_main!=nil
          allposbasic_prog = Programme.where(course_type: posbasics).pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
          for basicprog in allposbasic_prog
            lecturer_basicprog_name = basicprog if tasks_main.include?(basicprog)==true
          end
          programme_id=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
          @subjectlist_preselec_prog = Programme.where(id: programme_id).first.descendants.at_depth(2)
        else
          programme_id='0'
          @subjectlist_preselec_prog = Programme.at_depth(2) 
        end
        #subjects - only those with existing exampaper
        @subjectlist_preselec_prog2_raw = Programme.where('id IN (?) AND id IN (?)',@subjectlist_preselec_prog.map(&:id), Exam.where('id IN(?)', valid_exams).map(&:subject_id) )
        #subjects - ALL subjects
        #@subjectlist_preselec_prog2_raw = Programme.where('id IN (?)',@subjectlist_preselec_prog.map(&:id))
      end
      
      #all subjects for NEW Multiple
      @subjectlist_preselec_prog2 = []
      @subjectlist_preselec_prog2_raw.each do |x|
        @subjectlist_preselec_prog2 << [x.programme_subject, x.id]
      end
      
      #existing subject of all grades for Search
      @grade_list_exist_subject_raw= Programme.where('id IN(?) and id IN(?)', @existing_grade_subject_ids, @subjectlist_preselec_prog.pluck(:id))
      @grade_list_exist_subject = []
      @grade_list_exist_subject_raw.each do |x|
        @grade_list_exist_subject << [x.programme_subject, x.id]
      end
      
      @search = Grade.search(params[:q])
      @grades = @search.result.search2(programme_id)
      @grades = @grades.page(params[:page]||1)
      #@grades = Kaminari.paginate_array(@sdc).page(params[:page]||1) 
      @grades_group = @grades.group_by{|x|x.subject_id}
    end
    ###
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
        flash[:notice] = t('exam.grade.title')+t('actions.created')
        format.html { redirect_to exam_grade_path(@grade) }
        format.xml  { render :xml => @grade, :status => :created, :location => @grade }
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
    respond_to do |format|
      if @grade.update(grade_params)
        flash[:notice] = t('exam.grade.title')+t('actions.updated')
        format.html { redirect_to exam_grade_path(@grade) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @grade.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def new_multiple
#     @subjectid=params[:subjectid]
    unless @subjectid.nil?
      @grades = Array.new(1) { Grade.new }
      @selected_subject = Programme.where(id: @subjectid).first.subject_list
      @selected_exam = Exam.where(subject_id: @subjectid).where(name: 'F').order(exam_on: :desc).first
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
    @intakes_lt = Student.where('course_id=?',@programme_id).pluck(:intake).uniq    #required if render new_multiple
                                               
    @grade = Grade.new
    #qcount = @exammark.get_questions_count(@examid)
    #current_program = Programme.find(Exam.find(@examid).subject_id).root_id
    #selected_student = Student.where(course_id: current_program.to_i, intake: selected_intake)
    selected_student = Student.where(course_id: @programme_id, intake: selected_intake)
    rec_count = selected_student.count
    @grades = Array.new(rec_count) { Grade.new }                      
    @grades.each_with_index do |grade,ind|                                     
      grade.student_id = selected_student[ind].id
      grade.subject_id = @subjectid
      grade.examweight = 70
      #0.upto(qcount-1) do
      #  exammark.marks.build
      #end       
    end
    if @grades.all?(&:valid?) 
      @grades.each(&:save!)
      flash[:notice] = t('exam.exammark.multiple_created')
      render :action => 'edit_multiple', :grade_ids =>@grades.map(&:id)
    else                                                                      
      flash[:notice] = t('exam.exammark.marks_intakes_exist')
      render :action => 'new_multiple'
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
    @gradeids = params[:grade_ids]
    unless @gradeids.blank?
      @grades = Grade.find(@gradeids)
      @grades_obj = @grades[0]
      submit_type = params[:grade_submit_button]
      ##########################
      @caplusmse = params[:scores] #**
      @examweights = params[:examweights]  
      if @subjects_of_grades==1 || submit_type == t('exam.grade.apply_changes')
        @summative_weightage = params[:grade][:summative_weightage]    
        @scores = params[:scores_attributes]
        @scores_new_count = @scores.count 
      end
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
      @senttobpls = params[:sent_to_BPLs]                    # "sent_to_BPLs"=>{"2"=>"true"}, "sent_to_BPLs"=>{"1"=>"true","2"=>"true"}	  
      @eligibleexams = params[:eligible_for_exams]
      @carrypapers = params[:carry_papers] 
      @resits = params[:resits]
      ##########################
  
      if submit_type == t('update')
        ####
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
          if @subjects_of_grades==1 
            grade.examweight = @summative_weightage 
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
          
          grade.save
        end  #--end of @grades.each_with_index do |grade,index|--
        ####
        respond_to do |format|
          if all_scores && all_scores["0"]["marks"]
              format.html { redirect_to(exam_grades_url, :notice =>t('exam.grade.multiple_updated')+" ("+"#{@grades[0].subjectgrade.subject_list}"+" - "+"#{@grades.count}"+" "+t('records')+")") }
              format.xml  { head :ok }
          else
              flash[:notice]=(t 'exam.grade.scores_not_exist')
              format.html {render :action => 'edit_multiple'}
              format.xml  { head :ok }
          end
        end
      elsif submit_type == t('exam.grade.apply_changes')
  
        #edit & update EXISTING 'Formative Scores' items & 'Summative Weightage' accordingly (if there's any changes)
        @grades.sort_by{|x|x.studentgrade.name}.each_with_index do |grade, index| 
          scores = Score.where(grade_id: grade.id).sort_by{|y|y.created_at}
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
          grade.examweight = @summative_weightage 
          grade.save
        end

        #create & save NEW 'Formative Scores' items & 'Summative Weightage' accordingly        
        @grades.sort_by{|x|x.studentgrade.name}.each_with_index do |grade, index|  
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
          end
        end
        
        respond_to do |format|
          flash[:notice]=t('exam.grade.formative_summative_var_updated')
          format.html {render :action => 'edit_multiple'}
          format.xml  { head :ok }
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
  
  private
  
  # Use callbacks to share common setup or constraints between actions.
    def set_grade
      @grade = Grade.find(params[:id])
    end
    
    def set_data_edit_update_new_create
      valid_exams = Exammark.get_valid_exams
      @position_exist = @current_user.userable.positions
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
          @programme_list = @programme #a hash
          @student_list = Student.where('course_id=?', @preselect_prog).order(name: :asc)
          #subjects - only those with existing exampaper
          @subject_list = Programme.find(@preselect_prog).descendants.at_depth(2).where('id IN(?)', Exam.where('id IN(?)', valid_exams).map(&:subject_id))
          #subjects - ALL subjects
          #@subject_list = Programme.find(@preselect_prog).descendants.at_depth(2)
        else
        
          ####
          tasks_main = @current_user.userable.positions[0].tasks_main
          if @common_subjects.include?(@lecturer_programme)  # if @lecturer_programme == 'Commonsubject'
            @programme_list = Programme.roots 
            @student_list = Student.all.order(course_id: :asc)
            #subjects - only those with existing exampaper
            @subject_list = Programme.where('id IN(?)',common_subject_a.pluck(:id)).where('id IN(?)', Exam.where('id IN(?)', valid_exams).map(&:subject_id))
            #subjects - ALL subjects
            #@subject_list = common_subject_a
          elsif posbasics.include?(@lecturer_programme) && tasks_main!=nil
            allposbasic_prog = Programme.where(course_type: posbasics).pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
            for basicprog in allposbasic_prog
              lecturer_basicprog_name = basicprog if tasks_main.include?(basicprog)==true
            end
            @preselect_prog=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
            #@programme_list = Programme.where('id IN(?)', allbasic_prog.pluck(:id))
            @programme_list = Programme.where('id IN(?)', Array(@preselect_prog))
            @student_list = Student.where(course_id: @preselect_prog)
            #subjects - only those with existing exampaper
            @subject_list = Programme.where(id: @preselect_prog).first.descendants.at_depth(2).where('id IN(?)', Exam.where('id IN(?)', valid_exams).map(&:subject_id))
            #subjects - ALL subjects
            #@subject_list = Programme.where(id: @preselect_prog).first.descendants.at_depth(2)
          else
            @programme_list = Programme.roots
            @student_list = Student.all.order(course_id: :asc)
            #subjects - only those with existing exampaper
            @subject_list = Programme.at_depth(2).where('id IN(?)', Exam.where('id IN(?)', valid_exams).map(&:subject_id))
            #subjects - ALL subjects
            #@subject_list = Programme.at_depth(2) 
          end
          ####
        end
        @subject_list= Programme.where('id IN (?) AND id IN (?)',@subject_list.map(&:id), Exam.where('id IN(?)', valid_exams).map(&:subject_id) )
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
	@intakes_lt = @student_list.pluck(:intake).uniq.sort
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
            @intakes_lt = Student.where('course_id=?',@dept_unit.id).pluck(:intake).uniq.sort #must be among the programme of exampaper coz even common subject...
            @programme_id=@dept_unit.id
          end
      end
      #@intakes=@student_list.pluck(:intake).uniq.sort
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def grade_params
      params.require(:grade).permit(:student_id, :subject_id, :sent_to_BPL, :sent_date, :formative, :score, :eligible_for_exam, :carry_paper, :summative, :resit, :finalscore, :grading_id, :exam1name, :exam1desc, :exam1marks, :exam2name, :exam2desc, :exam2marks, :examweight, scores_attributes: [:id,:_destroy, :type_id, :description, :marks, :weightage, :score, :completion, :formative])
    end
  
end