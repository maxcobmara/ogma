class Asset::AssetDisposalsController < ApplicationController
  before_action :set_disposed, only: [:show, :edit, :update, :destroy]
  
  def index
    /@disposals = AssetDisposal.order(code: :asc).page(params[:page]||1)/
    @search = AssetDisposal.search(params[:q])
    @disposals = @search.result
    @disposals = @disposals.page(params[:page]||1)  
  end
  
  def show
  end
  
  def kewpa17
    @disposals = AssetDisposal.order('created_at DESC')
    respond_to do |format|
      format.pdf do
        pdf = Kewpa17Pdf.new(@disposals, view_context)
        send_data pdf.render, filename: "kewpa17-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  def kewpa20
    @disposal = AssetDisposal.order('created_at DESC')
    respond_to do |format|
      format.pdf do
        pdf = Kewpa20Pdf.new(@disposal, view_context)
        send_data pdf.render, filename: "kewpa20-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa16
    @disposal = AssetDisposal.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa16Pdf.new(@disposal, view_context)
        send_data pdf.render, filename: "kewpa16-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa18
    @disposal = AssetDisposal.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa18Pdf.new(@disposal, view_context)
        send_data pdf.render, filename: "kewpa18-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def kewpa19
    @lead = Position.find(1)
    @disposal = AssetDisposal.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa19Pdf.new(@disposal, view_context, @lead)
        send_data pdf.render, filename: "kewpa19-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
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