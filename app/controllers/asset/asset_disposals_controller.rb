class Asset::AssetDisposalsController < ApplicationController
  before_action :set_disposed, only: [:show, :edit, :update, :destroy]
  
  def index
    @disposals = AssetDisposal.order(code: :asc).page(params[:page]||1)
  end
  
  def show
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_disposed
      @disposed = AssetDisposal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_disposal_params
      params.require(:asset_disposal).permit(:code, :category, :unittype, :maxquantity, :minquantity, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id])
    end
end