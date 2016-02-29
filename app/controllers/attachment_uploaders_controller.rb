class AttachmentUploadersController < ApplicationController
  #filter_resource_access
  before_action :set_attachment_uploader, only: [:show, :edit, :update, :destroy]
  # GET /banks
  # GET /banks.xml
  def index
    @attachment_uploaders=AttachmentUploader.all
  end

  # GET /banks/1
  # GET /banks/1.xml
  def show
  end

  # GET /banks/new
  # GET /banks/new.xml
  def new
    @attachment_uploader=AttachmentUploader.new
  end

  # GET /banks/1/edit
  def edit
    @attachment_uploader=AttachmentUploader.find(params[:id])
  end

  # POST /banks
  # POST /banks.xml
  def create
    @attachment_uploader = AttachmentUploader.new(attachment_uploader_params)
    
    respond_to do |format|
      if @attachment_uploader.save
        format.html { redirect_to @attachment_uploader, notice:t('banks.new_flash')}
        format.json { render action: 'show', status: :created, location: @attachment_uploader}
      else
        format.html { render action: 'new' }
        format.json { render json: @attachment_uploader.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /banks/1
  # PUT /banks/1.xml
  def update
    @attachment_uploader=AttachmentUploader.find(params[:id])
    respond_to do |format|
      if @attachment_uploader.update(attachment_uploader_params)
        format.html { redirect_to @attachment_uploader, notice:t('banks.update_flash') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @attachment_uploader.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banks/1
  # DELETE /banks/1.xml
  def destroy
    @attachment_uploader.destroy
    respond_to do |format|
      format.html { redirect_to banks_url }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment_uploader
      @attachment_uploader = AttachmentUploader.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_uploader_params
      params.require(:attachment_uploader).permit(:id, :msgnotification_id, :created_at, :updated_at, :data, :data_file_name, :data_content_type, :data_file_size, :data_updated_at])
    end
end
