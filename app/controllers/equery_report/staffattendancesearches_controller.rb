class EqueryReport::StaffattendancesearchesController < ApplicationController
  filter_access_to :all
  
  def new
    @searchstaffattendancetype = params[:searchattendancetype]
    @staffattendancesearch = Staffattendancesearch.new
  end

  def create
    #@searchstaffattendancetype = params[:method]
    @staffattendancesearch = Staffattendancesearch.new(params[:staffattendancesearch])
    if !@staffattendancesearch.department.blank? && !@staffattendancesearch.thumb_id.blank? && !@staffattendancesearch.logged_at.blank?
      if @staffattendancesearch.save
        redirect_to equery_report_staffattendancesearch_path(@staffattendancesearch)
      else
        render :action => 'new'
      end
    else
      flash[:notice] = t('equery.staffattendance.select_all_fields')
      redirect_to new_equery_report_staffattendancesearch_path(@staffattendancesearch,  :searchattendancetype =>1)
    end
  end
  
  def view_staff
    unless params[:department2].blank?
      department_name = params[:department2]
      thumb_ids=Staff.find(:all, :conditions => ['staff_shift_id is not null AND thumb_id is not null']).map(&:thumb_id)
      @staff_list=Staff.find(:all, :joins => :position, :conditions => ['(unit=? OR tasks_main ILIKE(?)) and thumb_id IN(?) and positions.name!=?', department_name, "%#{department_name}%", thumb_ids,'ICMS Vendor Admin'], :order => 'name ASC')
    end
    render :partial => 'view_staff', :layout => false
  end
  
  def view_monthyear
    unless params[:thumbid].blank?
      thumbid = params[:thumbid]
      @staryear = StaffAttendance.find(:first, :conditions => ['thumb_id=?', thumbid], :order=>'logged_at ASC').logged_at.year
    end
    render :partial => 'view_monthyear', :layout => false
  end
 
  def show
    @staffattendancesearch = Staffattendancesearch.find(params[:id])
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def staffattendancesearch_params
      params.require(:staffattendancesearch).permit(:department, :thumb_id, :logged_at, :college_id, [:data => {}])
    end
 
end