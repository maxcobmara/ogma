class Exam::EvaluateCoursesController < ApplicationController
  filter_resource_access
  before_action :set_evaluate_course, only: [:show, :edit, :update, :destroy] 
  before_action :set_programme_subject_lecturer, only: [:edit, :update]
  before_action :set_data_new_create, only: [:new, :create]
  before_action :set_data_index_show, only: [:index, :show]
  
   def index  
    @search = EvaluateCourse.search(params[:q])
    @evaluate_courses = @search.result.search2(@programme_id)
    @evaluate_courses = @evaluate_courses.order(course_id: :asc).page(params[:page]||1)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @evaluate_courses }
    end
  end
  
  def new
    @evaluate_course = EvaluateCourse.new
     if @current_user.userable_type == "Student"
       student_course = Student.where(id: @current_user.userable_id).first.course_id
       unless student_course.nil?
       else
         #course_id not exist in student table
         flash[:notice] = t('exam.evaluate_course.update_course_student_info')
         redirect_to exam_evaluate_courses_path
       end
     else
       #flash[:notice] = t('exam.evaluate_course.title')+t('exam.evaluate_course.must_student')
       #redirect_to exam_evaluate_courses_path
       #AUTHORIZATION - Administration & Programme Manager can still NEW / CREATE
       unless @programme.nil?
       else
         if @current_user.userable.positions.first.tasks_main.include?("Ketua Program") || @current_user.userable.roles.pluck(:authname).include?("programme_manager")
           #unit not exist in Staff Task & Responsibilities (position table) for this Programme_Manager
           flash[:notice] = t('exam.evaluate_course.kp_which_programme')
           redirect_to exam_evaluate_courses_path
         else
           #Administration part
         end
       end     
     end
  end
  
  def create
    @evaluate_course = EvaluateCourse.new(evaluate_course_params)
    respond_to do |format|
      if @evaluate_course.save
        format.html { redirect_to(exam_evaluate_courses_path, :notice => t('exam.evaluate_course.title')+t('actions.created')) }
        format.xml  { render :xml => @evaluate_course, :status => :created, :location => @evaluate_course }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @evaluate_course.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  # PUT /evaluate_courses/1
  # PUT /evaluate_courses/1.xml
  def update
    @evaluate_course = EvaluateCourse.find(params[:id])
    respond_to do |format|
      if @evaluate_course.update(evaluate_course_params)
        format.html { redirect_to exam_evaluate_course_path(@evaluate_course), notice: t('exam.evaluate_course.title')+t('actions.updated')}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @evaluate_course.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /evaluate_courses/1
  # DELETE /evaluate_courses/1.xml
  def destroy
    @evaluate_course = EvaluateCourse.find(params[:id])
    @evaluate_course.destroy

    respond_to do |format|
      format.html { redirect_to(exam_evaluate_courses_url) }
      format.xml  { head :ok }
    end
  end
  
  def courseevaluation
    @evaluate_course = EvaluateCourse.find(params[:id])
    @evs = []
    @evs << @evaluate_course.ev_obj
    @evs << @evaluate_course.ev_knowledge
    @evs << @evaluate_course.ev_deliver
    @evs << @evaluate_course.ev_content
    @evs << @evaluate_course.ev_tool
    @evs << @evaluate_course.ev_topic
    @evs << @evaluate_course.ev_work
    @evs << @evaluate_course.ev_note
    respond_to do |format|
       format.pdf do
         pdf = CourseevaluationPdf.new(@evaluate_course, view_context, @evs)
         send_data pdf.render, filename: "courseevaluation-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluate_course
      @evaluate_course = EvaluateCourse.find(params[:id])
    end
    
    def set_programme_subject_lecturer
      @position_exist = @current_user.userable.positions
      if @position_exist     
        @lecturer_programme = @current_user.userable.positions.first.unit
        unless @lecturer_programme.nil? 
          @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0).first
        end
        unless @programme.nil?
          @preselect_prog = @programme.id
          @programme_list = Programme.where(id: @preselect_prog)
          @subjectlist_preselect_prog = Programme.where(id: @preselect_prog).first.descendants.at_depth(2)
          @lecturer_list = Staff.joins(:positions).where('positions.name=? and unit=?', "Pengajar", @lecturer_programme)
          @student_list = Student.where(course_id: @preselect_prog)
        else
          @programme_list = Programme.roots
          @subjectlist_preselect_prog = Programme.all.at_depth(2)
          @lecturer_list = Staff.joins(:positions).where('positions.name=?', "Pengajar").order(name: :asc)
          @student_list = Student.all
        end
      end
    end
    
    def set_data_new_create
      if @current_user.userable_type == "Student"
        student_course = Student.where(id: @current_user.userable_id).first.course_id
        unless student_course.nil?
          @preselect_prog = student_course
          @programme_list = Programme.where(id: student_course)
          @programme_name = @programme_list.first.name               #same with UNIT in positions table
          @subjectlist_preselect_prog = Programme.where(id: student_course).first.descendants.at_depth(2)
          @lecturer_list = Staff.joins(:positions).where('positions.name=? and unit=?', "Pengajar", @programme_name)
        end
      else
        #----NO CHECKING REQUIRED - PROGRAMME MGR - POSITION CONFIRM EXIST, ADMINISTRATION too?
        #@position_exist = @current_user.userable.positions
        #if @position_exist     
          @lecturer_programme = @current_user.userable.positions.first.unit
          unless @lecturer_programme.nil? 
            @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0).first
          end
          unless @programme.nil?
            @preselect_prog = @programme.id
            @programme_list = Programme.where(id: @preselect_prog)
            @subjectlist_preselect_prog = Programme.where(id: @preselect_prog).first.descendants.at_depth(2)
            @lecturer_list = Staff.joins(:positions).where('positions.name=? and unit=?', "Pengajar", @lecturer_programme)
            @student_list = Student.where(course_id: @preselect_prog)
          else
            if @current_user.userable.positions.first.tasks_main.include?("Ketua Program")
              #unit not exist in Staff Task & Responsibilities (position table) for this Programme_Manager
            else
              #Administration part
              @programme_list = Programme.roots
              @subjectlist_preselect_prog = Programme.all.at_depth(2)
              @lecturer_list = Staff.joins(:positions).where('positions.name=?', "Pengajar").order(name: :asc)
              @student_list = Student.all
            end
          end
        #end
      end
    end
    
    def set_data_index_show
      if @current_user.userable_type == "Student"
        @programme_id="s,"+"#{@current_user.userable_id}"
      else
        #staff section-start
        @position_exist = @current_user.userable.positions
        if @position_exist     
          @lecturer_programme = @current_user.userable.positions.first.unit
          unless @lecturer_programme.nil? 
            @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0).first
          end
          unless @programme.nil?
            @programme_id = @programme.id
          else
            if @lecturer_programme == 'Commonsubject'
            else
              @programme_id = 0
            end
          end
        end 
        #staff section-end
      end  
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evaluate_course_params
      params.require(:evaluate_course).permit(:course_id, :subject_id, :staff_id, :student_id, :evaluate_date, :comment, :ev_obj, :ev_knowledge, :ev_deliver, :ev_content, :ev_tool, :ev_topic, :ev_work, :ev_note, :invite_lec, :average_course_id)
    end
end
