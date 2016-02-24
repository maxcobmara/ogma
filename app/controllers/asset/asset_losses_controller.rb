class Asset::AssetLossesController < ApplicationController
  filter_access_to :index, :new, :create, :kewpa28, :kewpa29, :kewpa30, :kewpa31, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  before_action :set_lost, only: [:show, :edit, :update, :destroy]
  
  def index
    @search = AssetLoss.search(params[:q])
    @asset_loss = @search.result
    # TODO 
    #1) group result by 'treasury approval no' & display KEWPA31 link accordingly
    #2) check all / uncheck all, + 'write-off checked' button
    
    # @lost_assets = AssetLoss.order(code: :asc).page(params[:page]||1)
    #@asset_losses = AssetLoss.order('lost_at DESC')
        #@asset_losses_group_writeoff = @asset_losses.group_by{|x|x.document_id}
        #respond_to do |format|
          #format.html # index.html.erb
          #format.xml  { render :xml => @asset_losses }
          #end
  end
  
  def new
    @asset_loss = AssetLoss.new
  end
  
  def create
    @asset_loss = AssetLoss.new(asset_loss_params)
    respond_to do |format|
      if @asset_loss.save
        format.html { redirect_to @asset_loss, notice: 'A new asset lost was successfully created.' }
        format.json { render action: 'show', status: :created, location: @asset_loss }
      else
        format.html { render action: 'new' }
        format.json { render json: @asset_loss.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    @asset_loss = AssetLoss.find(params[:id])
  end
  
  def edit
    @asset_loss = AssetLoss.find(params[:id])
  end
  
  def update
    @asset_loss = AssetLoss.find(params[:id])
    respond_to do |format|
      if @asset_loss.update(asset_loss_params)
        format.html { redirect_to asset_loss_path, notice: 'An asset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @asset_loss.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @asset_loss = AssetLoss.find(params[:id])
    @asset_loss.destroy
    respond_to do |format|
      format.html { redirect_to(asset_losses_url) }
      format.xml  { head :ok }
    end
  end
  
  def kewpa28
    @lead = Position.find(1)
   @asset_loss = AssetLoss.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa28Pdf.new(@asset_loss, view_context, @lead)
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
   @asset_losses = AssetLoss.where('document_id=?', @document_id).order(created_at: :desc) 
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
      params.require(:asset_loss).permit(:asset_id, :cash_type, :created_at, :document_id, :endorsed_hod_by, :endorsed_on, :est_value, :form_type, :how_desc, :id, 
        :investigated_by, :investigation_code, :investigation_completed_on, :is_police_report_made, :is_prima_facie, :is_rule_broken, :is_staff_action, :is_submit_to_hod, 
        :is_used, :is_writeoff, :last_handled_by, :location_id, :loss_type, :lost_at, :new_measures, :notes, :ownership, :police_action_status, :police_report_code, 
        :prev_action_enforced_by, :preventive_action_dept, :preventive_measures, :recommendations, :report_code, :rules_broken_desc, :security_code, :security_officer_id,
        :security_officer_notes, :surcharge_notes, :updated_at, :value_federal, :value_state, :why_no_report)
    end
end