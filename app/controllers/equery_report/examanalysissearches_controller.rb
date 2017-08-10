class EqueryReport::ExamanalysissearchesController < ApplicationController
   filter_resource_access
  
  def new
    @examanalysissearch = Examanalysissearch.new
  end
  
  def create
    if @examanalysissearch.save
        redirect_to equery_report_examanalysissearch_path(@examanalysissearch)
    else
        render :action => 'new'
    end
  end

  def show
    @examanalysissearch = Examanalysissearch.find(params[:id])
    @examanalyses=@examanalysissearch.examanalyses.page(params[:page]).per(10)
  end
   
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def examanalysissearch_params
      params.require(:examanalysissearch).permit(:programme_id, :examtype, :subject_id, :examon, :exampaper, :college_id, [:data => {}])
    end
end
