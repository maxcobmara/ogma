class Asset::AssetDefectsController < ApplicationController
  before_action :set_defective, only: [:show, :edit, :update, :destroy]
  
  def index
    @search = AssetDefect.search(params[:q])
    @assets = @search.result
    @defective = @assets.order(created_at: :desc).page(params[:page]||1)
  end
  
  def show
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_defective
      @defective = AssetDefect.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_defect_params
      params.require(:asset_defect).permit(:code, :category, :unittype, :maxquantity, :minquantity, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id])
    end
end