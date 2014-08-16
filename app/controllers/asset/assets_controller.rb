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
  
  def update
    respond_to do |format|
      if @asset.update(asset_params)
        format.html { redirect_to asset_asset_path(@asset), notice: (t 'asset.title')+(t 'actions.updated')  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def new
    @asset = Asset.new
  end
  
  def kewpa2
    #@lead = Position.find(1).try(:staff).try(:name)
    @lead = Position.find(1)
    @asset = Asset.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa2Pdf.new(@asset, view_context, @lead)
        send_data pdf.render, filename: "kewpa2-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  
  def kewpa3
    @lead = Position.find(1)
    @asset = Asset.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa3Pdf.new(@asset, view_context, @lead)
        send_data pdf.render, filename: "kewpa3-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa4
    if params[:search]
      @assets = Asset.find(:all, :conditions => ['substring(assetcode, 18, 2 ) =? AND assettype =?', "#{params[:search]}", 1])
      respond_to do |format|
        format.pdf do
          pdf = Kewpa4Pdf.new(@assets, view_context)
          send_data pdf.render, filename: "kewpa4-{Date.today}",
                                type: "application/pdf",
                                disposition: "inline"
                 end
             end
        else
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
end  
  
  def kewpa5
    if params[:search]
      @assets = Asset.find(:all, :conditions => ['substring(assetcode, 18, 2 ) =? AND assettype =?', "#{params[:search]}", 2])
      respond_to do |format|
        format.pdf do
          pdf = Kewpa5Pdf.new(@assets, view_context)
          send_data pdf.render, filename: "kewpa5-{Date.today}",
                                type: "application/pdf",
                                disposition: "inline"
        end
      end
    else
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
end
  
  def kewpa6
    @asset = Asset.find(params[:id])
    @loanable = AssetLoan.find(:all, :conditions => ['asset_id=? AND is_approved!=?',params[:id], false], :order=>'returned_on ASC')
    respond_to do |format|
      format.pdf do
        pdf = Kewpa6Pdf.new(@asset, view_context)
        send_data pdf.render, filename: "kewpa6-{Date.today}",
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

  def kewpa14
    @asset = Asset.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa14Pdf.new(@asset, view_context)
        send_data pdf.render, filename: "kewpa14-{Date.today}",
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
      params.require(:asset).permit(:location_id, :staff_id, :student_id, :keyaccept, :keyexpectedreturn, :keyreturned, :force_vacate, :student_icno, :remark, :purchaseprice, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id])
    end
end
