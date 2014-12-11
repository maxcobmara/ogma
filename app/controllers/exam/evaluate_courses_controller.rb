class Exam::EvaluateCoursesController < ApplicationController
  filter_resource_access
  before_action :set_evaluate_course, only: [:show, :edit, :update, :destroy] 
  
   def index  
    @position_exist = @current_user.userable.positions
    if @position_exist     
      @lecturer_programme = @current_user.userable.positions.first.unit
      unless @lecturer_programme.nil? 
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0).first
      end
      unless @programme.nil?
        @evaluate_courses = EvaluateCourse.where('course_id=?',@programme.id)
      else
        if @lecturer_programme == 'Commonsubject'
        else
          @evaluate_courses = EvaluateCourse.all
        end
      end
    end 
    @search = EvaluateCourse.search(params[:q])
    @evaluate_courses = @search.result
    @evaluate_courses = @evaluate_courses.order(course_id: :asc).page(params[:page]||1)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @evaluate_courses }
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluate_course
      @evaluate_course = EvaluateCourse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evaluate_course_params
      params.require(:evaluate_course).permit(:course_id, :subject_id, :staff_id, :student_id, :evaluate_date, :comment, :ev_obj, :ev_knowledge, :ev_deliver, :ev_content, :ev_tool, :ev_topic, :ev_work, :ev_note, :invite_lec, :average_course_id)
    end
end
