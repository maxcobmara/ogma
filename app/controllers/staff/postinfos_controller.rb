class Staff::PostinfosController < ApplicationController
  filter_resource_access
  before_action :set_postinfo, only: [:show, :edit, :update, :destroy]
  # GET /postinfos
  # GET /postinfos.xml

  def index
    @search = Postinfo.search(params[:q])
    @postinfos = @search.result
    @postinfos = @postinfos.page(params[:page]||1)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @postinfos }
    end
  end

  def new
    @postinfo=Postinfo.new
  end
  
  def create
    @postinfo=Postinfo.new(postinfo_params)
    respond_to do |format|
      if @postinfo.save
        format.html { redirect_to staff_postinfos_path, :notice =>t('staff.postinfos.title')+t('actions.created')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @postinfo.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /postinfos/1/edit
  def edit
    @postinfo = Postinfo.find(params[:id])
  end

  # PUT /postinfos/1
  # PUT /postinfos/1.xml
  def update
    @postinfo = Postinfo.find(params[:id])

    respond_to do |format|
      if @postinfo.update(postinfo_params)
        format.html { redirect_to staff_postinfos_path, :notice =>t('staff.postinfos.title')+t('actions.updated')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @postinfo.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @postinfo = Postinfo.find(params[:id])
  end
  
  def destroy
    @postinfo = Postinfo.find(params[:id])
    @postinfo.destroy

    respond_to do |format|
      format.html { redirect_to(staff_postinfos_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
    def set_postinfo
      @postinfo = Postinfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def postinfo_params
      params.require(:postinfo).permit(:details, :staffgrade_id, :post_count, :college_id, {:data => []})
    end

end
