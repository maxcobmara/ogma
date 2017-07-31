class EqueryReport::LessonplansearchesController < ApplicationController
  filter_resource_access
    
  def new
    @searchlessonplantype = params[:searchlessonplantype]
    @lessonplansearch = Lessonplansearch.new
  end
  
  def create
    if @lessonplansearch.save
        redirect_to equery_report_lessonplansearch_path(@lessonplansearch)
    else
        render :action => 'new'
    end
  end

  def show
    @lessonplansearch = Lessonplansearch.find(params[:id])
    @lessonplans=@lessonplansearch.lessonplans
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def lessonplansearch_params
      params.require(:lessonplansearch).permit(:lecturer, :intake_id, :programme_id, :intake, :valid_schedule, :subject, :loggedin_staff, :intake_programme, :college_id, [:data => {}])
    end
end
