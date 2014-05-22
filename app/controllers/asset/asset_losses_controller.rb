class Asset::AssetLossesController < ApplicationController
  before_action :set_defective, only: [:show, :edit, :update, :destroy]
  
  def index
    @lost_assets = AssetLoss.order(code: :asc).page(params[:page]||1)
  end
  
  def show
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lost
      @lost = AssetLoss.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_loss_params
      params.require(:asset_defect).permit(:code, :category, :unittype, :maxquantity, :minquantity, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id])
    end
end