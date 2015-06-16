class StaffTraining::PtdosController < ApplicationController
  before_action :set_ptdo, only: [:show, :edit, :update, :destroy]
  
  def index
    roles = current_user.roles.pluck(:authname)
    @is_admin = roles.include?("administration") || roles.include?("training_administration") || roles.include?("training_manager") 
    @is_programme_mgr = roles.include?("programme_manager")
    @is_unit_leader = roles.include?("unit_leader")
    @is_admin_superior = roles.include?("administration_staff") && current_user.userable.positions.first.name=="Timbalan Pengarah (Pengurusan)"
    if @is_admin
      @search = Ptdo.search(params[:q])
    elsif @is_programme_mgr || @is_unit_leader
      if @is_programme_mgr && @is_unit_leader
        roles2=["programme_manager", "unit_leader"]
      elsif @is_programme_mgr && !@is_unit_leader
        roles2=["programme_manager"]
      elsif !@is_programme_mgr && @is_unit_leader
        roles2=["unit_leader"]
      end
      @search = Ptdo.unit_members(current_user.userable.positions.first.unit, current_user.userable_id, roles2).search(params[:q])
     elsif @is_admin_superior
       @search = Ptdo.where(staff_id: @current_user.admin_subordinates).search(params[:q])
    else
      @search = Ptdo.sstaff2(current_user.userable.id).search(params[:q])
    end 
    @ptdos = @search.result.page(params[:page]||1) 
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
        format.html { redirect_to(staff_training_ptdo_path(@ptdo), notice: (t 'staff.training.application_status.title_apply')+" "+(t 'actions.created'))}
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
        format.html { redirect_to(staff_training_ptdo_path(@ptdo), notice:  (t 'staff.training.application_status.title_apply')+" "+(t 'actions.updated') )}
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
      format.html { redirect_to(staff_training_ptdos_url) }
      format.xml  { head :ok }
    end
  end
  
  def show_total_days
    @search = Ptdo.search(params[:q])
    @ptdos = @search.result.where('final_approve=? and staff_id=? and trainee_report is not null', true, @current_user.userable_id) 
  end
  
  def training_report
    who=params[:id]
    who=params[:q][:staff_id] if who.nil?
    @search = Ptdo.search(params[:q])
    @ptdos = @search.result.where('final_approve=? and staff_id=? and trainee_report is not null', true, who) 
    domestic_courses_ids=Ptcourse.domestic.map(&:id)
    domestic_schedule_ids=Ptschedule.where(ptcourse_id: domestic_courses_ids).map(&:id)
    @domestic = @ptdos.where('ptschedule_id IN(?)', domestic_schedule_ids)
    overseas_courses_ids=Ptcourse.overseas.map(&:id)
    overseas_schedule_ids=Ptschedule.where(ptcourse_id: overseas_courses_ids).map(&:id)
    @overseas = @ptdos.where('ptschedule_id IN(?)', overseas_schedule_ids)
    
     respond_to do |format|
       format.pdf do
         pdf = Training_reportPdf.new(@ptdos, @domestic, @overseas, who, view_context)
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
        params.require(:ptdo).permit(:id, :ptcourse_id, :ptschedule_id, :staff_id, :justification, :unit_review, :unit_approve, :dept_review, :dept_approve, :replacement_id, :final_approve, :trainee_report, :payment, :remark)
      end  
end