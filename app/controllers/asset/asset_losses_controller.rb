class Asset::AssetLossesController < ApplicationController

  
  def index
    @search = AssetLoss.search(params[:q])
    @asset_loss = @search.result
    # @lost_assets = AssetLoss.order(code: :asc).page(params[:page]||1)
    @asset_losses = AssetLoss.order('lost_at DESC')
        @asset_losses_group_writeoff = @asset_losses.group_by{|x|x.document_id}
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @asset_losses }
        end
  end
  
  def new
    @asset_loss = AssetLoss.new
  end
  
  def show
    @asset_loss = AssetLoss.find(params[:id])
  end
  
  def kewpa28
   @asset_loss = AssetLoss.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa28Pdf.new(@asset_loss, view_context)
        send_data pdf.render, filename: "kewpa28-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa29
   @asset_loss = AssetLoss.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa29Pdf.new(@asset_loss, view_context)
        send_data pdf.render, filename: "kewpa29-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa30
   @asset_loss = AssetLoss.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa30Pdf.new(@asset_loss, view_context)
        send_data pdf.render, filename: "kewpa30-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa31
    @lead = Position.find(1)
   @document_id = params[:id]
   @asset_losses = AssetLoss.find(:all, :conditions=>['document_id=?', @document_id], :order => 'created_at DESC') 
    respond_to do |format|
      format.pdf do
        pdf = Kewpa31Pdf.new(@asset_losses, view_context, @lead)
        send_data pdf.render, filename: "kewpa31-{Date.today}",
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