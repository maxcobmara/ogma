class EqueryReport::EvaluatecoursesearchesController < ApplicationController
   filter_resource_access
  
  def new
    @searchevaluatecoursetype = params[:searchevaluatecoursetype]
    @evaluatecoursesearch = Evaluatecoursesearch.new
  end
  
  def create
    if @evaluatecoursesearch.save
        redirect_to equery_report_evaluatecoursesearch_path(@evaluatecoursesearch)
    else
        render :action => 'new'
    end
  end

  def show
    @evaluatecoursesearch = Evaluatecoursesearch.find(params[:id])
    @evaluatecourses=@evaluatecoursesearch.evaluatecourses#.page(params[:page]).per(10)
  end
   
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def evaluatecoursesearch_params
      params.require(:evaluatecoursesearch).permit(:programme_id, :subject_id, :evaldate, :lecturer_id, :invite_lecturer, :evaldate_end, :programme_id2, :is_staff, :visitor_id, :college_id, [:data => {}])
    end
end
