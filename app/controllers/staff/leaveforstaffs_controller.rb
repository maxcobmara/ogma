class Staff::LeaveforstaffsController < ApplicationController
  filter_access_to :index, :new, :create, :leaveforstaff_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy,  :processing_level_1, :processing_level_2, :borang_cuti, :attribute_check => true
  
  before_action :set_admin, only: [:new, :edit, :index, :create, :update]
  before_action :set_index_list, only: [:index, :leaveforstaff_list]
  before_action :set_leaveforstaff, only: [:show, :edit, :update, :destroy]
  before_action :set_new_var, only: [:new, :create]
  before_action :set_edit_var, only: [:edit, :update]

  def index
    @leaveforstaffs = @leaveforstaffs.order(staff_id: :asc, leavestartdate: :asc).page(params[:page]||1)
  end
  
  def new
    @leaveforstaff = Leaveforstaff.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @leaveforstaff }
    end
  end
  
  def create
    @leaveforstaff = Leaveforstaff.new(leaveforstaff_params)
    @selected=params[:leaveforstaff][:staff_id]
    respond_to do |format|
      if @leaveforstaff.save
        #LeaveforstaffsMailer.staff_leave_notification(@leaveforstaff, request.host, view_context).deliver
        #ref : https://stackoverflow.com/questions/23448384/ruby-on-rails-check-whether-internet-connection-in-on-or-off
        begin 
          LeaveforstaffsMailer.support_approve_leave_notification(@leaveforstaff, request.host, view_context).deliver
          format.html { redirect_to(staff_leaveforstaff_path(@leaveforstaff), notice:t('staff_leave.new_notice'))}
          format.xml  { render :xml => @leaveforstaff, :status => :created, :location => @leaveforstaff }
          rescue SocketError => e
            format.html { redirect_to(staff_leaveforstaff_path(@leaveforstaff), notice:t('staff_leave.new_notice_mail_not_send'))}
            format.xml  { render :xml => @leaveforstaff, :status => :created, :location => @leaveforstaff }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @leaveforstaff.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @leaveforstaff.update(leaveforstaff_params)
        
        #supporting
        if @leaveforstaff.approval1==true && @leaveforstaff.approval2_id!=nil && @leaveforstaff.approver2!=true
          #LeaveforstaffsMailer.approve_leave_notification(@leaveforstaff, request.host, view_context).deliver 
          #ref : https://stackoverflow.com/questions/23448384/ruby-on-rails-check-whether-internet-connection-in-on-or-off
          begin
            LeaveforstaffsMailer.support_approve_leave_notification(@leaveforstaff, request.host, view_context).deliver 
	    format.html { redirect_to staff_leaveforstaff_path, notice: t('staff_leave.approve_notice')}
	    rescue SocketError => e
	      format.html { redirect_to staff_leaveforstaff_path, notice: t('staff_leave.approve_notice_mail_not_sent')}
	  end
	end

        #approving
        if (@leaveforstaff.approval1==true && (@leaveforstaff.approver2==true || @leaveforstaff.approver2=nil))
          #ref : https://stackoverflow.com/questions/23448384/ruby-on-rails-check-whether-internet-connection-in-on-or-off
          begin
            LeaveforstaffsMailer.successfull_leave_notification(@leaveforstaff, request.host, view_context).deliver
            format.html { redirect_to staff_leaveforstaff_path, notice: t('staff_leave.update_notice')}
            rescue SocketError => e
              format.html { redirect_to staff_leaveforstaff_path, notice: t('staff_leave.update_notice_mail_not_sent')}
          end
        end
        
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @leaveforstaff.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
  end
 
  def destroy
    @leaveforstaff.destroy

    respond_to do |format|
      format.html { redirect_to(staff_leaveforstaffs_url) }
      format.xml  { head :ok }
    end
  end

  def processing_level_1
    @leaveforstaff = Leaveforstaff.find(params[:id])
  end
  
  def processing_level_2
    @leaveforstaff = Leaveforstaff.find(params[:id])
  end
  
  
  def borang_cuti
    @leaveforstaff = Leaveforstaff.find(params[:id])
    
    respond_to do |format|
       format.pdf do
         pdf = Borang_cutiPdf.new(@leaveforstaff, view_context, current_user.college)
         send_data pdf.render, filename: "borang_cuti-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end
  
  def leaveforstaff_list
    respond_to do |format|
      format.pdf do
        pdf = Leaveforstaff_listPdf.new(@leaveforstaffs, view_context, current_user.college)
        send_data pdf.render, filename: "leaveforstaff_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leaveforstaff
      @leaveforstaffs = Leaveforstaff.find(params[:id])
    end
    
    def set_admin
      roles = current_user.roles.pluck(:authname)
      @is_admin = true if roles.include?("developer") || roles.include?("administration") ||  roles.include?("staff_leaves_module_admin") || roles.include?("staff_leaves_module_viewer") || roles.include?("staff_leaves_module_user")
    end
    
    def set_index_list
      roles = current_user.roles.pluck(:authname)
      @is_admin = true if roles.include?("developer") || roles.include?("administration") ||  roles.include?("staff_leaves_module_admin") || roles.include?("staff_leaves_module_viewer") || roles.include?("staff_leaves_module_user")
      if @is_admin
        @search = Leaveforstaff.search(params[:q])
      else
        @search = Leaveforstaff.sstaff2(current_user.userable.id).search(params[:q])
      end 
      @leaveforstaffs = @search.result
    end
    
    def set_new_var
      @staff_list=@is_admin ? Staff.valid_staffs.order(rank_id: :asc, name: :asc) : Staff.where(id: current_user.userable_id)
    end
    
    def set_edit_var
      @staff_list=Staff.where(id: @leaveforstaff.staff_id)
      @selected=@leaveforstaff.staff_id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leaveforstaff_params
      params.require(:leaveforstaff).permit(:id, :staff_id, :leavetype, :leavestartdate, :leavenddate, :leavedays, :reason, :notes, :replacement_id, :submit,  :approval1, :approval1_id, :approval1date, :approver2, :approval2_id, :approval2date, :address_on_leave, :phone_on_leave, :requestdate, :college_id, {:data => []})
    end
end