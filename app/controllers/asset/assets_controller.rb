class Asset::AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy]
  
  def index
    @search = Asset.search(params[:q])
    @assets = @search.result
    @fixed_assets = @assets.fixed
    @fixed_assets = @fixed_assets.page(params[:page]||1)
  end
  
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset
      @asset = Asset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_params
      params.require(:asset).permit(:location_id, :staff_id, :student_id, :keyaccept, :keyexpectedreturn, :keyreturned, :force_vacate, :student_icno, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id])
    end
end