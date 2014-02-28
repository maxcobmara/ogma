class BulletinsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_bulletin, only: [:show, :edit, :update, :destroy]
  # GET /bulletins
  # GET /bulletins.xml
  
  def index
    @search = Bulletin.search(params[:q])
    @bulletins = @search.result
    @bulletins = @bulletins.page(params[:page]||1)
    @bulletins_filtered = Bulletin.find(:all, :order => sort_column + ' ' + sort_direction ,:conditions => ['headline LIKE ? or content ILIKE ? ', "%#{params[:search]}%", "%#{params[:search]}%"])
  end

  # GET /bulletins/1
  # GET /bulletins/1.xml
  def show
    @bulletin = Bulletin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bulletin }
    end
  end

  # GET /bulletins/new
  # GET /bulletins/new.xml
  def new
    @bulletin = Bulletin.new
   
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bulletin }
    end
  end

  # GET /bulletins/1/edit
  def edit
    @bulletin = Bulletin.find(params[:id])
  end

  # POST /bulletins
  # POST /bulletins.xml
  def create
    @bulletin = Bulletin.new(params[:bulletin])

    respond_to do |format|
      if @bulletin.save
        flash[:notice] = 'Bulletin was successfully created.'
        format.html { redirect_to(@bulletin) }
        format.xml  { render :xml => @bulletin, :status => :created, :location => @bulletin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bulletin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bulletins/1
  # PUT /bulletins/1.xml
  def update
    respond_to do |format|
      if @bulletin.update(bulletin_params)
        format.html { redirect_to bulletin_path, notice: 'Bulletin Board was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bulletin.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /bulletins/1
  # DELETE /bulletins/1.xml
  def destroy
    @bulletin.destroy

    respond_to do |format|
      format.html { redirect_to(bulletins_url) }
      format.json { head :no_content }
    end
  end

  
private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulletin
      @bulletin = Bulletin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulletin_params
      params.require(:bulletin).permit(:headline, :content, :postedby_id, :publishdt , :date)
    end
    
    def sort_column
        Bulletin.column_names.include?(params[:sort]) ? params[:sort] : "headline" 
    end
    
    def sort_direction
        %w[asc desc].include?(params[:direction])? params[:direction] : "asc" 
    end
end

