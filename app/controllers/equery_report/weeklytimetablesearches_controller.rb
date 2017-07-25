class EqueryReport::WeeklytimetablesearchesController < ApplicationController
  filter_resource_access
    
  def new
    @searchweeklytimetabletype = params[:searchweeklytimetabletype]
    @weeklytimetablesearch = Weeklytimetablesearch.new
  end
  
  def create
#     @searchweeklytimetabletype = params[:method]
#     if (@searchweeklytimetabletype == '1' || @searchweeklytimetabletype == 1)
#         @weeklytimetablesearch = Weeklytimetablesearch.new(params[:weeklytimetablesearch])
#     end
    
    if @weeklytimetablesearch.save
        redirect_to equery_report_weeklytimetablesearch_path(@weeklytimetablesearch)
    else
        render :action => 'new'
    end
  end

  def show
    @weeklytimetablesearch = Weeklytimetablesearch.find(params[:id])
    @weeklytimetables=@weeklytimetablesearch.weeklytimetables.page(params[:page]).per(10)
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def weeklytimetablesearch_params
      params.require(:weeklytimetablesearch).permit(:intake_programme, :programme_id, :startdate, :enddate, :preparedby, :intake_id, :intake, :validintake, :college_id, [:data => {}])
    end
end
