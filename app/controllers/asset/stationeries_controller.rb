class Asset::StationeriesController < ApplicationController
  before_action :set_stationery, only: [:show, :edit, :update, :destroy]
  
  def index
    @stationeries = Stationery.order(code: :asc).page(params[:page]||1)
  end
  
  def show
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stationery
      @stationery = Stationery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stationery_params
      params.require(:stationery).permit(:code, :category, :unittype, :maxquantity, :minquantity, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id])
    end
end