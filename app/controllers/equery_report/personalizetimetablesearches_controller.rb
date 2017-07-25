class EqueryReport::PersonalizetimetablesearchesController < ApplicationController
  filter_resource_access
    
  def new
    @searchpersonalizetimetabletype = params[:searchpersonalizetimetabletype]
    @personalizetimetablesearch = Personalizetimetablesearch.new
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def personalizetimetablesearch_params
      params.require(:personalizetimetablesearch).permit(:lecturer, :programme_id, :startdate, :enddate,  :college_id, [:data => {}])
    end
end
