class Asset::AssetDefectsController < ApplicationController
  before_action :set_defective, only: [:show, :edit, :update, :destroy]
  
  def index
    #@search = AssetDefect.where.not(decision: true).search(params[:q])
    @search = AssetDefect.where('decision is not true').search(params[:q])
    @assets = @search.result
    @defective = @assets.order(created_at: :desc).page(params[:page]||1)
  end
  
  def show
  end
  
  def edit
  end
  
  def decision
    @defective = AssetDefect.find(params[:id])
  end
  
  def process2
    @defective = AssetDefect.find(params[:id])
  end
  
  def new
    @asset = Asset.find(params[:asset_id])
    @asset_defect = @asset.asset_defects.new(params[:asset_defect])
  end
  
  def create
    @asset_defect = AssetDefect.new(asset_defect_params)
    respond_to do |format|
      if @asset_defect.save
        format.html { redirect_to @asset_defect, notice: (t 'asset.defect.title')+(t 'actions.created') }
        format.json { render action: 'show', status: :created, location: @asset_defect }
      else
        format.html { render action: 'new'}
        format.json { render json: @asset_defect.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    editingpage = params[:asset_defect][:editing_page]
    respond_to do |format|
      if @asset_defect.update(asset_defect_params)
        format.html { redirect_to asset_defect_path, notice: (t 'asset.defect.title')+(t 'actions.updated')}
        format.json { head :no_content }
      else
        if editingpage=="process2"
          format.html { render action: 'process2'}
        elsif editingpage=="decision"
          format.html { render action: 'decision'}
        else
          format.html { render action: 'edit' }
        end
        format.json { render json: @asset_defect.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def kewpa9
    @lead = Position.find(1)
    @defective = AssetDefect.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa9Pdf.new(@defective, view_context, @lead)
         send_data pdf.render, filename: "kewpa9-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  def destroy
    @asset_defect = AssetDefect.find(params[:id])
    @asset_defect.destroy

    respond_to do |format|
      format.html { redirect_to(asset_defects_url)}
      format.xml  { head :ok }
    end
  end
   
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_defective
      @asset_defect = AssetDefect.find(params[:id])
      @defective = @asset_defect
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_defect_params
      params.require(:asset_defect).permit(:description, :asset_id, :asset_show, :reported_by, :notes,:process_type, :recommendation, :is_processed, :processed_by, :processed_on, :decision, :decision_by, :decision_on)
    end
end

# == Schema Information
#
# Table name: asset_defects
#
#  asset_id       :integer
#  created_at     :datetime
#  decision       :boolean
#  decision_by    :integer
#  decision_on    :date
#  description    :text
#  id             :integer          not null, primary key
#  is_processed   :boolean
#  notes          :text
#  process_type   :string(255)
#  processed_by   :integer
#  processed_on   :date
#  recommendation :text
#  reported_by    :integer
#  updated_at     :datetime
