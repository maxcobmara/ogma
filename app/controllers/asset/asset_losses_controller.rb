class Asset::AssetLossesController < ApplicationController
  filter_access_to :index, :new, :create, :kewpa28, :kewpa29, :kewpa30, :kewpa31, :edit_multiple, :update_multiple, :lost_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :endorse, :destroy, :attribute_check => true
  before_action :set_lost, only: [:show, :edit, :update, :destroy]
  before_action :set_losses, only: [:index, :loss_list]
  
  def index
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
  
  def edit_multiple
    @assetlosses_ids = params[:asset_loss_ids]
    unless @assetlosses_ids.blank? 
      @asset_losses = AssetLoss.where(id: @assetlosses_ids)
      @asset_losses_count = @asset_losses.count
      @asset_losses_docs_count = @asset_losses.map(&:endorsed_on).count
      @edit_type = params[:loss_submit_button]
       if @edit_type == I18n.t('asset.loss.writeoff_checked') && (@asset_losses_count == @asset_losses_docs_count)
         ## continue multiple edit (including subject edit here) --> refer view
       else
         flash[:error] = I18n.t('asset_losses.hod_endorsement_compulsory')
         redirect_to asset_losses_path
        end    # end for if @edit_type=="Edit Checked"
    else    
        flash[:notice] = I18n.t('select_one')
        redirect_to asset_losses_path
    end
  end
  
  def update_multiple
    #raise params.inspect
    @assetlosses_ids = params[:asset_loss_ids]
    @document_id = params[:asset_loss][:document_id]
    @asset_losses = AssetLoss.find(@assetlosses_ids)
    
    @asset_losses.each_with_index do |asset_loss, index| 
        asset_loss.is_writeoff = true
        asset_loss.document_id = @document_id 
        asset_loss.save
    end
    #flash[:notice] = I18n.t('asset_losses.writeoff_updated')
    redirect_to asset_losses_path
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
        pdf = Kewpa31Pdf.new(@asset_losses, view_context, @lead, @document_id)
        send_data pdf.render, filename: "kewpa31-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def loss_list
    respond_to do |format|
      format.pdf do
        pdf = Loss_listPdf.new(@asset_losses, view_context, current_user.college)
        send_data pdf.render, filename: "loss_list-{Date.today}",
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
    
    def set_losses
      @search = AssetLoss.search(params[:q])
      @asset_losses = @search.result
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_loss_params
      params.require(:asset_loss).permit(:asset_id, :cash_type, :created_at, :document_id, :endorsed_hod_by, :endorsed_on, :est_value, :form_type, :how_desc, :id, 
        :investigated_by, :investigation_code, :investigation_completed_on, :is_police_report_made, :is_prima_facie, :is_rule_broken, :is_staff_action, :is_submit_to_hod, 
        :is_used, :is_writeoff, :last_handled_by, :location_id, :loss_type, :lost_at, :new_measures, :notes, :ownership, :police_action_status, :police_report_code, 
        :prev_action_enforced_by, :preventive_action_dept, :preventive_measures, :recommendations, :report_code, :rules_broken_desc, :security_code, :security_officer_id,
        :security_officer_notes, :surcharge_notes, :updated_at, :value_federal, :value_state, :why_no_report, :college_id, {:data=>[]})
    end
end