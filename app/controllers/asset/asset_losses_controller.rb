class Asset::AssetLossesController < ApplicationController
  before_action :set_defective, only: [:show, :edit, :update, :destroy]
  
  def index
    @lost_assets = AssetLoss.order(code: :asc).page(params[:page]||1)
  end
  
  def show
  end
  
  def kewpa28
   @asset_loss = AssetLoss.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa28Pdf.new(@asset, view_context)
        send_data pdf.render, filename: "kewpa28-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa30
   @asset_loss = AssetLoss.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa30Pdf.new(@asset, view_context)
        send_data pdf.render, filename: "kewpa30-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
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