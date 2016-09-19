class Staff::TitlesController < ApplicationController
  filter_resource_access
  before_action :set_title, only: [:show, :edit, :update, :destroy]
  # GET /titles
  # GET /titles.xml
  def index
    @search = Title.search(params[:q])
    @titles = @search.result
    @titles = @titles.page(params[:page]||1)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @titles }
    end
  end

  def new
    @title=Title.new
  end
  
  def create
    @title=Title.new(title_params)
    respond_to do |format|
      if @title.save
        format.html { redirect_to staff_title_path(@title), :notice =>t('staff.titles.title')+t('actions.created')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @title.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /titless/1/edit
  def edit
    @title = Title.find(params[:id])
  end

  # PUT /titles/1
  # PUT /titles/1.xml
  def update
    @title = Title.find(params[:id])

    respond_to do |format|
      if @title.update(title_params)
        format.html { redirect_to staff_title_path(@title), :notice =>t('staff.titles.title')+t('actions.updated')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @title.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @title = Title.find(params[:id])
  end
  
  def destroy
    @title = Title.find(params[:id])
    @title.destroy

    respond_to do |format|
      format.html { redirect_to(staff_titles_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
    def set_title
      @title = Title.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def title_params
      params.require(:title).permit(:titlecode, :name, :berhormat, :college_id, {:data => []})
    end
end
