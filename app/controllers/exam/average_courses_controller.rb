class Exam::AverageCoursesController < ApplicationController
  #filter_resource_access
  filter_access_to :index, :new, :create, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :evaluation_analysis, :attribute_check => true
  before_action :set_average_course, only: [:show, :edit, :update, :destroy] 

  def new
    @average_course = AverageCourse.new
    #@subject_id=params[:subject_id]
    #@lecturer_id=params[:lecturer_id]
    
    evals=EvaluateCourse.where(staff_id: params[:lecturer_id]).where(subject_id: params[:subject_id])
    @evs_int=AverageCourse.avg_int(evals)
    @evs_act=AverageCourse.avg_actual(evals)
    @total_eval=evals.count
  end
  
  def create
    @average_course = AverageCourse.new(average_course_params)
    evals=EvaluateCourse.where(staff_id: params[:lecturer_id]).where(subject_id: params[:subject_id])
    @evs_int=AverageCourse.avg_int(evals)
    @evs_act=AverageCourse.avg_actual(evals)
    @total_eval=evals.count
    
    respond_to do |format|
      if @average_course.save
        format.html { redirect_to(exam_average_course_path(@average_course), :notice => t('exam.average_course.title')+t('actions.created')) }
        format.xml  { render :xml => @average_course, :status => :created, :location => @average_course }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @average_course.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @average_course = AverageCourse.find(params[:id])
    evals=EvaluateCourse.where(staff_id: @average_course.lecturer_id).where(subject_id: @average_course.subject_id)
    @evs_int=AverageCourse.avg_int(evals)
    @evs_act=AverageCourse.avg_actual(evals)
    @total_eval=evals.count
  end
  
  # PUT /average_courses/1
  # PUT /average_courses/1.xml
  def update
    @average_course = AverageCourse.find(params[:id])
    respond_to do |format|
      if @average_course.update(average_course_params)
        format.html { redirect_to exam_average_course_path(@average_course), notice: t('exam.average_course.title')+t('actions.updated')}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @average_course.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    @average_course = AverageCourse.find(params[:id])
    evals=EvaluateCourse.where(staff_id: @average_course.lecturer_id).where(subject_id: @average_course.subject_id)
    @evs_int=AverageCourse.avg_int(evals)
    @evs_act=AverageCourse.avg_actual(evals)
    @total_eval=evals.count
  end
  
   def evaluation_analysis
     @average_course=AverageCourse.find(params[:id])
     evals=EvaluateCourse.where(staff_id: @average_course.lecturer_id).where(subject_id: @average_course.subject_id)
 
     respond_to do |format|
        format.pdf do
          pdf = Evaluation_analysisPdf.new(@average_course, view_context, AverageCourse.avg_int(evals), current_user.college, AverageCourse.avg_actual(evals), evals.count)
          send_data pdf.render, filename: "evaluation_analysis-{Date.today}",
                                type: "application/pdf",
                                disposition: "inline"
        end
     end
   end
  
  private
  
    def set_average_course
      @average_course = AverageCourse.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def average_course_params
      params.require(:average_course).permit(:lecturer_id, :programme_id, :dissatisfaction, :recommend_for_improvement, :lesson_content, :evaluation_category, :support_justify, :principal_id, :principal_date, :subject_id, :delivery_quality, :lecturer_knowledge, :organisation, :expertise_qualification, :college_id, {:data => []})
    end
    
end