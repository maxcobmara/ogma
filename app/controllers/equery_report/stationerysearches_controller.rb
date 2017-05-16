class EqueryReport::StationerysearchesController < ApplicationController
  filter_resource_access
  
  def new
    @stationerysearch = Stationerysearch.new
    @searchstationerytype = params[:searchstationerytype]
  end

  def create
    if (@searchstationerytype == '1' || @searchstationerytype == 1)
      @stationerysearch = Stationerysearch.new(stationerysearch_params)
    end
    if @stationerysearch.save
      redirect_to equery_report_stationerysearch_path(@stationerysearch)
    else
      render :action => 'new'
    end
  end

  def show
    @stationerysearch = Stationerysearch.find(params[:id])
    @stationeries=@stationerysearch.stationeries.page(params[:page]).per(10)  # NOTE - when search solely by product
    # TODO - Kaminari - use array as in studentcounseling - when search NOT solely by product -- page limit to 5 stationery records (c/w add+deduct)
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def stationerysearch_params
      params.require(:stationerysearch).permit(:product, :document, :received, :received2, :issuedby, :receivedby, :issuedate, :issuedate2, :college_id, [:data => {}])
    end
end
