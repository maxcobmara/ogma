class Asset::AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy]
  
  def index
    @search = Asset.search(params[:q])
    @assets = @search.result
    @fixed_assets = @assets.where(assettype: 1).order(assetcode: :asc).page(params[:page]||1)
    @inventories  = @assets.where(assettype: 2).order(assetcode: :asc).page(params[:page]||1)
  end
  
  def show
  end
  
  def edit
  end
  
  def kewpa4
    @assets = Asset.where(assettype: 1)
    respond_to do |format|
      format.pdf do
        pdf = Kewpa4Pdf.new(@assets, view_context)
        send_data pdf.render, filename: "kewpa4-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa5
    @assets = Asset.where(assettype: 2).order(assetcode: :asc)
    respond_to do |format|
      format.pdf do
        pdf = Kewpa5Pdf.new(@assets, view_context)
        send_data pdf.render, filename: "kewpa5-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa13
    @assets = Asset.where('is_maintainable = ?', true).order(assetcode: :asc)
    respond_to do |format|
      format.pdf do
        pdf = Kewpa13Pdf.new(@assets, view_context)
        send_data pdf.render, filename: "kewpa13-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa3
    
     @asset = Asset.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa3Pdf.new(@asset, view_context)
        send_data pdf.render, filename: "kewpa3-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end  
  
  def kewpa2a
    
     @asset = Asset.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa2aPdf.new(@asset, view_context)
        send_data pdf.render, filename: "kewpa2a-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end  
  
  def kewpa2b
    
     @asset = Asset.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa2bPdf.new(@asset, view_context)
        send_data pdf.render, filename: "kewpa2b-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
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
