class Student::StudentDisciplineCasesController < ApplicationController
  
  #filter_resource_access
  filter_access_to :all
  before_action :set_student_discipline_case, only: [:show, :edit, :update, :destroy]
   
  # GET /student_discipline_cases
  # GET /student_discipline_cases.xml
  def index
    roles = current_user.roles.pluck(:id)
    @is_admin = roles.include?(2)
    if @is_admin
      @search = StudentDisciplineCase.search(params[:q])
    else
      @search = StudentDisciplineCase.sstaff2(current_user.userable.id).search(params[:q])
    end 
    
    ##@student_discipline_cases2 = @search.result
    ##@student_discipline_cases = @student_discipline_cases2.page(params[:page]||1)
    @student_discipline_cases2 = @search.result.sort_by{|x|x.student.course_id}
    @student_discipline_cases = Kaminari.paginate_array(@student_discipline_cases2).page(params[:page]||1) 

#     @student_year_sem=[]
#     @student_discipline_cases.each do |sdc|
# 	@student_year_sem << Student.year_and_sem(sdc.student.intake)
#     end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @student_discipline_cases }
    end
  end
  
  def discipline_report
    @search = StudentDisciplineCase.search(params[:q])
    @student_discipline_cases2 = @search.result.sort_by{|x|x.student.course_id}

    respond_to do |format|
       format.pdf do
         pdf = Discipline_reportPdf.new(@student_discipline_cases2, view_context)
                   send_data pdf.render, filename: "discipline_report-{Date.today}",
                   type: "application/pdf",
                   disposition: "inline"
       end
     end
  end
  
  def discipline_report2
    @search = StudentDisciplineCase.search(params[:q])
    @student_discipline_cases2 = @search.result.sort_by{|x|x.student.course_id}

    respond_to do |format|
       format.pdf do
         pdf = Discipline_reportPdf.new(@student_discipline_cases2, view_context)
                   send_data pdf.render, filename: "discipline_report-{Date.today}",
                   type: "application/pdf",
                   disposition: "inline"
       end
     end
  end

  # GET /student_discipline_cases/1
  # GET /student_discipline_cases/1.xml
  def show
    @student_discipline_case = StudentDisciplineCase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student_discipline_case }
    end
  end

  # GET /student_discipline_cases/new
  # GET /student_discipline_cases/new.xml
  def new
    @student_discipline_case = StudentDisciplineCase.new
    #@student_discipline_case.student_counseling_sessions.build
    @myhod = Position.where('tasks_main ILIKE (?)', "%Ketua Program%").pluck(:staff_id)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student_discipline_case }
    end
  end

  # GET /student_discipline_cases/1/edit
  def edit
    @student_discipline_case = StudentDisciplineCase.find(params[:id])
  end

  # POST /student_discipline_cases
  # POST /student_discipline_cases.xml
  def create
    @student_discipline_case = StudentDisciplineCase.new(student_discipline_case_params)
    @myhod = Position.where('tasks_main ILIKE (?)', "%Ketua Program%").pluck(:staff_id)
    respond_to do |format|
      if @student_discipline_case.save
        format.html { redirect_to(student_student_discipline_case_path(@student_discipline_case), :notice => (t 'student.discipline.new_case')+(t 'actions.created') )}
        format.xml  { render :xml => @student_discipline_case, :status => :created, :location => @student_discipline_case }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student_discipline_case.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /student_discipline_cases/1
  # PUT /student_discipline_cases/1.xml
  def update
    #raise params.inspect
    @student_discipline_case = StudentDisciplineCase.find(params[:id])
    #@student_counseling_session = StudentDisciplineCase.student_counseling_session.new(params[:student_counseling_session])
    
    respond_to do |format|
      if @student_discipline_case.update(student_discipline_case_params)
        format.html { redirect_to(student_student_discipline_case_path(@student_discipline_case), :notice => (t 'student.discipline.case')+t('actions.updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student_discipline_case.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /student_discipline_cases/1
  # DELETE /student_discipline_cases/1.xml
  def destroy
    @student_discipline_case = StudentDisciplineCase.find(params[:id])

    respond_to do |format|
      if @student_discipline_case.destroy
        format.html { redirect_to(student_student_discipline_cases_url) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(student_student_discipline_case_path(@student_discipline_case), :notice => t('student.discipline.removal_prohibited_for_referred_case'))}
       #format.html { redirect_to(student_student_discipline_cases_url, :notice => StudentDisciplineCase.display_msg(@student_discipline_case.errors))}
        format.xml  { render :xml => @student_discipline_case.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def actiontaken
    @student_discipline_case = StudentDisciplineCase.find(params[:id]) 
    @student_discipline_case.student_counseling_sessions.build if @student_discipline_case.student_counseling_sessions.count==0
  end

  def referbpl
    @student_discipline_case = StudentDisciplineCase.find(params[:id]) 
  end
  
  def reports
  end
  
  def anacdotal_report
    @student_id=params[:student].to_i
    @discipline_cases=StudentDisciplineCase.where(student_id: @student_id)
    respond_to do |format|
      format.pdf do
        pdf = Anacdotal_reportPdf.new(@discipline_cases, view_context)
        send_data pdf.render, filename: "discipline-bystudent-{Date.today}",
        type: "application/pdf",
        disposition: "inline"
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_discipline_case
      @student_discipline_case = StudentDisciplineCase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_discipline_case_params
      params.require(:student_discipline_case).permit(:reported_by, :student_id, :infraction_id, :description, :reported_on, :assigned_to, :assigned_on, :status, :file_id, :investigation, :action_type, :other_info, :case_created, :action, :location_id, :assigned2_to, :assigned2_on, :is_innocent, :closed_at_college_on, :sent_to_board_on, :board_meeting_on, :board_decision_on, :board_decision, :appeal_on, :appeal_decision, :appeal_decision_on, :counselor_feedback, :action_type2, student_counseling_sessions_attributes: [:id, :destroy, :requested_at, :student_id, :case_id])
    end
  
end
