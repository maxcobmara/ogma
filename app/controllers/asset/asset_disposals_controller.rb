class Asset::AssetDisposalsController < ApplicationController
  before_action :set_disposed, only: [:show, :edit, :update, :destroy]
  
  def index
    /@disposals = AssetDisposal.order(code: :asc).page(params[:page]||1)/
    @search = AssetDisposal.search(params[:q])
    @disposals = @search.result
    @disposals = @disposals.page(params[:page]||1)  
  end
  
  def new
    @disposal = AssetDisposal.new
  end
  
  # POST /asset_disposals
  # POST /asset_disposals.xml
  def create
    @disposal = AssetDisposal.new(asset_disposal_params)
    respond_to do |format|
      if @disposal.save
        format.html { redirect_to(asset_disposal_path(@disposal), :notice => t('asset.disposal.title')+t('actions.created')) }
        format.xml  { render :xml => @disposal, :status => :created, :location => @disposal}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @disposal.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @disposed = AssetDisposal.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @disposed }
    end
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
      params.require(:asset_disposal).permit(:asset_id, :description, :running_hours, :mileage, :current_condition,:current_value, :est_repair_cost,:est_value_post_repair, :est_time_next_fail, :repair1_need, :repair2_need,:repair3_need,:justify1_disposal, :justify2_disposal,:justify3_disposal,:is_checked, :checked_on, :is_verfied,:verified_on, :revalue, :revalued_by,:revalued_on, :document_id, :disposal_type,:type_others_desc, :discard_option,:receiver_name,:documentation_no, :is_disposed, :inform_hod,:disposed_by, :disposed_on, :is_discarded, :discarded_on, :discard_location, :discard_witness_1, :discard_witness_2, :checked_by, :verified_by, :examiner1, :examiner2, :is_staff1, :is_staff2, :examiner_staff1,:examiner_staff2, :witness_outsider1, :witness_outsider2,:witness_is_staff1, :witness_is_staff2)
      #:code, :category, :unittype, :maxquantity, :minquantity, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id])
    end
end