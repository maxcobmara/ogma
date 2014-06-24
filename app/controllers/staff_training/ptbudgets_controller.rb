class StaffTraining::PtbudgetsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_ptbudget, only: [:show, :edit, :update, :destroy]
  #filter_resource_access
  # GET /ptbudgets
  # GET /ptbudgets.xml
  def index
    @search = Ptbudget.search(params[:q])
    @ptbudgets = @search.result
    @ptbudgets = @ptbudgets.page(params[:page]||1)
    #@ptbudgets_filtered = Ptbudget.find(:all, :order => psort_column + ' ' + sort_direction ,:conditions => ['fiscal_end LIKE ? or budget ILIKE ? ', "%#{params[:search]}%", "%#{params[:search]}%"])
  end

  # GET /ptbudgets/1
  # GET /ptbudgets/1.xml
  def show
    @ptbudget = Ptbudget.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ptbudget }
    end
  end

  # GET /ptbudgets/new
  # GET /ptbudgets/new.xml
  def new
    @ptbudget = Ptbudget.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ptbudget }
    end
  end

  # GET /ptbudgets/1/edit
  def edit
    @ptbudget = Ptbudget.find(params[:id])
  end

  # POST /ptbudgets
  # POST /ptbudgets.xml
  def create
    @ptbudget = Ptbudget.new(params[:ptbudget])

    respond_to do |format|
      if @ptbudget.save
        flash[:notice] = 'A new budget was successfully created.'
        format.html { redirect_to(@ptbudget) }
        format.xml  { render :xml => @ptbudget, :status => :created, :location => @ptbudget }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ptbudget.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ptbudgets/1
  # PUT /ptbudgets/1.xml
  def update
    @ptbudget = Ptbudget.find(params[:id])

    respond_to do |format|
      if @ptbudget.update_attributes(params[:ptbudget])
        flash[:notice] = 'Your training budget was successfully updated.'
        format.html { redirect_to(@ptbudget) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ptbudgets.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ptbudgets/1
  # DELETE /ptbudgets/1.xml
  def destroy
    @ptbudget = Ptbudget.find(params[:id])
    @ptbudget.destroy

    respond_to do |format|
      format.html { redirect_to(ptbudgets_url) }
      format.xml  { head :ok }
    end
  end
end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_ptbudget
      @ptbudget = Ptbudget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ptbudget_params
      params.require(:ptbudget).permit(:fiscalstart, :budget, :used_budget, :budget_balance)
    end
    
    def sort_column
        Ptbudget.column_names.include?(params[:sort]) ? params[:sort] : "fiscal_end" 
    end
    
    def sort_direction
        %w[asc desc].include?(params[:direction])? params[:direction] : "asc" 
    end