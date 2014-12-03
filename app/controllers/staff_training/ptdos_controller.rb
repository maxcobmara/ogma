class StaffTraining::PtdosController < ApplicationController
  before_action :set_ptdo, only: [:show, :edit, :update, :destroy]
  
  def index
    @ptdos = Ptdo.all
    @search = Ptdo.search(params[:q])
    @ptdos = @search.result
  end
  
  def show
    @ptdo = Ptdo.find(params[:id])
  end
  
  def new
    @ptdo = Ptdo.new(:ptschedule_id => params[:ptschedule_id])
  end
  
  def edit
    @ptdo = Ptdo.find(params[:id])
  end
  
  def create
    @ptdo = Ptdo.new(params[:ptdo])

    respond_to do |format|
      if @ptdo.save
        flash[:notice] = 'Ptdo was successfully created.'
        format.html { redirect_to(@ptdo) }
        format.xml  { render :xml => @ptdo, :status => :created, :location => @ptdo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ptdo.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @ptdo = Ptdo.find(params[:id])

    respond_to do |format|
      if @ptdo.update_attributes(params[:ptdo])
        flash[:notice] = 'Ptdo was successfully updated.'
        format.html { redirect_to(@ptdo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ptdo.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @ptdo = Ptdo.find(params[:id])
    @ptdo.destroy

    respond_to do |format|
      format.html { redirect_to(ptdos_url) }
      format.xml  { head :ok }
    end
  end
  
  def show_total_days
    @ptdos = Ptdo.find(:all, :conditions => ['final_approve=? and staff_id=? and trainee_report is not null',true,params[:id]]) 
  end
  
  private
      # Use callbacks to share common setup or constraints between actions.
      def set_ptdo
        @ptdo = Ptdo.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def ptdo_params
        params.require(:ptdo).permit(:fiscalstart, :budget, :used_budget, :budget_balance)
      end  
end