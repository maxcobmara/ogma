class Asset::AssetcategoriesController < ApplicationController
  #filter_resource_access
  before_action :set_assetcategory, only: [:show, :edit, :update, :destroy]
  # GET /assetcategories
  # GET /assetcategories.xml
  def index
    @search = Assetcategory.search(params[:q])
    @assetcategories = @search.result
    @assetcategories = @assetcategories.page(params[:page]||1)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assetcategories }
    end
  end

  def new
    @assetcategory=Assetcategory.new
  end
  
  def create
    #raise params.inspect
    @assetcategory=Assetcategory.new(assetcategory_params)
    respond_to do |format|
      if @assetcategory.save
        format.html { redirect_to asset_assetcategories_path, :notice =>t('assetcategory.caption')+t('actions.created')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assetcategory.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /assetcategoriess/1/edit
  def edit
    @assetcategory = Assetcategory.find(params[:id])
  end

  # PUT /assetcategories/1
  # PUT /assetcategories/1.xml
  def update
    @assetcategory = Assetcategory.find(params[:id])

    respond_to do |format|
      if @assetcategory.update(assetcategory_params)
        format.html { redirect_to asset_assetcategories_path, :notice =>t('assetcategory.caption')+t('actions.updated')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assetcategory.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @assetcategory = Assetcategory.find(params[:id])
  end
  
  def destroy
    @assetcategory = Assetcategory.find(params[:id])
    @assetcategory.destroy

    respond_to do |format|
      format.html { redirect_to(asset_assetcategories_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
    def set_assetcategory
      @assetcategory = Assetcategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assetcategory_params
      params.require(:assetcategory).permit(:parent_id, :description, :cattype_id, :college_id, {:data => []})
    end
end
