class DocumentsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  #filter_access_to :all#filter_resource_access #temp 5Apr2013
  # GET /documents
  # GET /documents.xml
  def index

    @search = Document.search(params[:q])
    @documents = @search.result
    @documents = @documents.page(params[:page]||1)
    @documents_filtered = Document.find(:all, :order => sort_column + ' ' + sort_direction ,:conditions => ['refno LIKE ? or title ILIKE ? ', "%#{params[:search]}%", "%#{params[:search]}%"])
    
    @tome = Document.find(:all, :joins => :staffs, :conditions => ['staff_id =? and (refno ILIKE ? or title ILIKE ?)', current_user,"%#{params[:search]}%", "%#{params[:search]}%"], :order => "created_at DESC")
    
    #problem on staffs.id
    #@docs_for_me = @documents.joins(:staffs).where(staffs.id => current_user).order(created_at: :asc)
    
  end

  # GET /documents/1
  # GET /documents/1.xml
  def show
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.xml
  def new
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find(params[:id])
  end
  
  def download
    @document = Document.find(params[:id])
    send_file @document.data.path, :type => @document.data_content_type
  end

  # POST /documents
  # POST /documents.xml
  def create

  end

  # PUT /documents/1
  # PUT /documents/1.xml
  def update

  end

  # DELETE /documents/1
  # DELETE /documents/1.xml
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to(documents_url) }
      format.xml  { head :ok }
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @documents = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:serialno, :refno, :category, :title, :from, :stafffiled_id, :letterdt, :letterxdt, :sender)
    end
    
    def sort_column
        Document.column_names.include?(params[:sort]) ? params[:sort] : "serialno" 
    end
    
    def sort_direction
        %w[asc desc].include?(params[:direction])? params[:direction] : "asc" 
    end
end
