class StaffTraining::PtdosController < ApplicationController
  before_action :set_ptdo, only: [:show, :edit, :update, :destroy]
  
  def index
    roles = current_user.roles.pluck(:id)
    @is_admin = roles.include?(2)
    if @is_admin
      @search = Ptdo.search(params[:q])
    else
      @search = Ptdo.sstaff2(current_user.userable.id).search(params[:q])
    end 
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
    @ptdo = Ptdo.new(ptdo_params)

    respond_to do |format|
      if @ptdo.save
        format.html { redirect_to(staff_training_ptdo_path(@ptdo), notice: 'Apply for training was successfully created.' )}
        format.json { render action: 'show', status: :created, location: @ptdo }
      else
        format.html { render action: 'new' }
        format.json { render json: @ptdo.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @ptdo = Ptdo.find(params[:id])

    respond_to do |format|
      if @ptdo.update(ptdo_params)
        format.html { redirect_to(staff_training_ptdo_path(@ptdo), notice: 'Apply for training was successfully updated.' )}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ptdo.errors, status: :unprocessable_entity }
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
    @search = Ptdo.search(params[:q])
    @ptdos = @search.result.where('final_approve=? and staff_id=? and trainee_report is not null', true, params[:id]) 
  end
  
  def training_report
    @search = Ptdo.search(params[:q])
    @ptdos = @search.result
     respond_to do |format|
       format.pdf do
         pdf = Document_reportPdf.new(@ptdos, view_context)
         send_data pdf.render, filename: "training_report-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
   end
  
  private
      # Use callbacks to share common setup or constraints between actions.
      def set_ptdo
        @ptdo = Ptdo.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def ptdo_params
        params.require(:ptdo).permit(:id, :ptcourse_id, :ptschedule_id, :staff_id, :justification, :unit_review, :unit_approve, :dept_review, :dept_approve, :replacement_id, :final_approve, :trainee_report)
      end  
end