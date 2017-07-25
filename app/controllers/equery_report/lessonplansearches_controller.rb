class EqueryReport::LessonplansearchesController < ApplicationController
  filter_resource_access
    
  def new
    @searchlessonplantype = params[:searchlessonplantype]
    @lessonplansearch = Lessonplansearch.new
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def lessonplansearch_params
      params.require(:lessonplansearch).permit(:lecturer, :intake_id, :programme_id, :intake, :valid_schedule, :subject, :loggedin_staff,  :college_id, [:data => {}])
    end
end
