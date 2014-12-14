class Exam::GradesController < ApplicationController
  filter_access_to :all 
  before_action :set_grade, only: [:show, :edit, :update, :destroy]
  before_action :set_data_edit_update_new_create, only: [:edit, :update, :new, :create]

  # GET /grades
  # GET /grades.xml
  def index
    valid_exams = Exammark.get_valid_exams
    @grade_list_exist_subject=[]
    @existing_grade_subject_ids = Grade.all.pluck(:subject_id).uniq
    @position_exist = @current_user.userable.positions
    ###
    if @position_exist     
      @lecturer_programme = @current_user.userable.positions[0].unit
      common_subject_a = Programme.where('course_type=?','Commonsubject')
      unless @lecturer_programme.nil?
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0) if !(@lecturer_programme=="Pos Basik" || @lecturer_programme=="Diploma Lanjutan")
      end
      unless @programme.nil? || @programme.count == 0
        @preselect_prog = @programme.first.id
        programme_id = @programme.first.id
        @subjectlist_preselec_prog = Programme.find(@preselect_prog).descendants.at_depth(2)  #.sort_by{|y|y.code}
        #subjects - only those with existing exampaper
        @subjectlist_preselec_prog2_raw = Programme.where('id IN (?) AND id IN (?) and id NOT IN(?)',@subjectlist_preselec_prog.map(&:id), Exam.where('id IN(?)', valid_exams).map(&:subject_id), common_subject_a.map(&:id))
        #subjects - ALL subject of current programme
        #@subjectlist_preselec_prog2_raw = Programme.where('id IN (?) AND id NOT IN(?)',@subjectlist_preselec_prog.map(&:id), common_subject_a.map(&:id))
      else
        tasks_main = @current_user.userable.positions[0].tasks_main
        if @lecturer_programme == 'Commonsubject'
          programme_id ='1'
          @subjectlist_preselec_prog = common_subject_a
        elsif (@lecturer_programme == 'Pos Basik' || @lecturer_programme == "Diploma Lanjutan") && tasks_main!=nil
          allposbasic_prog = Programme.where('course_type=? or course_type=?', "Pos Basik", "Diploma Lanjutan").pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
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
      @grades_group = @grades.group_by{|x|x.subject_id}
    end
    ###
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @grades }
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
      if @grade.update_attributes(grade_params)
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
  end
  
  def create_multiple
  end
  
  def edit_multiple
  end
  
  def update_multiple
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
        unless @lecturer_programme.nil?
          @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0) if !(@lecturer_programme=="Pos Basik" || @lecturer_programme=="Diploma Lanjutan")
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
          if @lecturer_programme == 'Commonsubject'
            @programme_list = Programme.roots 
            @student_list = Student.all.order(course_id: :asc)
            #subjects - only those with existing exampaper
            @subject_list = Programme.where('id IN(?)',common_subject_a.pluck(:id)).where('id IN(?)', Exam.where('id IN(?)', valid_exams).map(&:subject_id))
            #subjects - ALL subjects
            #@subject_list = common_subject_a
          elsif (@lecturer_programme == 'Pos Basik' || @lecturer_programme == "Diploma Lanjutan") && tasks_main!=nil
            allposbasic_prog = Programme.where('course_type=? or course_type=?', "Pos Basik", "Diploma Lanjutan").pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
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
      end
      ##
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def grade_params
      params.require(:grade).permit(:student_id, :subject_id, :sent_to_BPL, :sent_date, :formative, :score, :eligible_for_exam, :carry_paper, :summative, :resit, :finalscore, :grading_id, :exam1name, :exam1desc, :exam1marks, :exam2name, :exam2desc, :exam2marks, :examweight, scores_attributes: [:id,:_destroy, :type_id, :description, :marks, :weightage, :score, :completion, :formative])
    end
  
end