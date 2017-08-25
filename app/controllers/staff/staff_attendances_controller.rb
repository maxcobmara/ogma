class Staff::StaffAttendancesController < ApplicationController
  filter_access_to :index, :new, :create, :manager, :manager_admin, :status, :attendance_report, :attendance_report_main, :daily_report, :weekly_report, :monthly_report, :monthly_listing, :monthly_details,  :actionable, :attendance_list, :attendance_status_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :approval,  :destroy, :attribute_check => true
  
  before_action :set_staff_attendance, only: [:show, :edit, :update, :destroy]
  before_action :set_staff_attendances, only: [:index, :attendance_list]
  
  # GET /staff_attendances
  # GET /staff_attendances.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @staff_attendances }
    end
  end

  #start - import excel
  def import_excel
  end

  def import
      a=StaffAttendance.import(params[:file])
      msg=StaffAttendance.messages(a)
      if a[:sye].count>0 || a[:ser].count>0 || a[:snu].count>0
	@invalid_year = a[:sye]
	@exist_records = a[:ser]
	@no_user = a[:snu]
	@success = a[:sas] if a[:sas].count>0
        respond_to do |format|
          flash[:notice] = msg
          format.html { render action: 'import_excel' }
          flash.discard
        end
      else
	respond_to do |format|
	  format.html {redirect_to staff_staff_attendances_url, notice: msg}
	end
      end
  end

  def download_excel_format
    send_file ("#{::Rails.root.to_s}/public/excel_format/staff_attendance_import.xls")
  end
  #end - import excel

  # GET /staff_attendances/1
  # GET /staff_attendances/1.xml
  def show
    @staff_attendance = StaffAttendance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @staff_attendance }
    end
  end

  # GET /staff_attendances/new
  # GET /staff_attendances/new.xml
  def new
    @staff_attendance = StaffAttendance.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @staff_attendance }
    end
  end

  # GET /staff_attendances/1/edit
  def edit
    @staff_attendance = StaffAttendance.find(params[:id])
  end

  # POST /staff_attendances
  # POST /staff_attendances.xml
  def create
    #raise params.inspect
    @staff_attendance = StaffAttendance.new(staff_attendance_params)

    respond_to do |format|
      if @staff_attendance.save
        #format.html { redirect_to(staff_staff_attendance, :notice => 'StaffAttendance was successfully created.') }
	format.html {redirect_to staff_staff_attendances_url, notice: t('staff_attendance.title')+t('actions.created')}
        format.xml  { render :xml => @staff_attendance, :status => :created, :location => @staff_attendance }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @staff_attendance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /staff_attendances/1
  # PUT /staff_attendances/1.xml
  def update
    @staff_attendance = StaffAttendance.find(params[:id])

    respond_to do |format|
      if @staff_attendance.update(staff_attendance_params)
        format.html { redirect_to(staff_staff_attendance_path(@staff_attendance), :notice => (t 'staff_attendance.title')+(t 'actions.updated'))}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @staff_attendance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /staff_attendances/1
  # DELETE /staff_attendances/1.xml
  def destroy
    @staff_attendance = StaffAttendance.find(params[:id])
    @staff_attendance.destroy

    respond_to do |format|
      format.html { redirect_to(staff_staff_attendances_url) }
      format.xml  { head :ok }
    end
  end

  def manager
    #@udept=Position.unit_department2
    @udept=StaffAttendance.get_thumb_ids_unit_names(2)
    unit_name=current_user.userable.positions.first.unit
    if @udept.include?(unit_name) ==true #matching unit_name with valid department
      @mylate_attendances = StaffAttendance.find_mylate(current_user) 
      @myearly_attendances = StaffAttendance.find_myearly(current_user)
      @approvelate_attendances = StaffAttendance.find_approvelate(current_user)
      @approveearly_attendances = StaffAttendance.find_approveearly(current_user)  
    elsif @udept.include?(unit_name)==false  #elsif @udept.include?("--"+unit_name)
      if current_user.userable.thumb_id.blank? && current_user.userable.staff_shift_id.blank? && current_user.userable.positions.first.unit.blank?
        redirect_to('/dashboard', :notice => I18n.t('staff_attendance.require_complete_data_manage'))
      #else
        #redirect_to('/dashboard', :notice => I18n.t('staff_attendance.attendance_not_exist')
      end
    end
  end
  
  def manager_admin
    @late_early_recs_ids=[]
    all_late_early=StaffAttendance.triggered
    all_late_early.each do |x|
      shift_id=StaffShift.shift_id_in_use(x.logged_at.strftime('%Y-%m-%d'),x.thumb_id)
      @late_early_recs_ids << x.id if x.r_u_late(shift_id)=="flag" || x.r_u_early(shift_id)=="flag"
    end
    @search=StaffAttendance.search(params[:q])
    @late_early_recs=@search.result.where(id: @late_early_recs_ids)
    @late_early_recs=@late_early_recs.page(params[:page]||1)
  end

  def approval
    @staff_attendance = StaffAttendance.find(params[:id])
  end

  def actionable
    StaffAttendance.where(id: params[:triggers]).update_all(trigger: true)
    StaffAttendance.where(id: params[:ignores]).update_all(trigger: false)
    redirect_to :back
  end

  def status
    #@all_dates_staffs = StaffAttendance.find(:all, :conditions =>['logged_at>=? and logged_at<?',"2012-05-07","2012-10-16"], :order => 'logged_at ASC')
    thumb_ids_in_staff = Staff.where('thumb_id IS NOT NULL').order(:thumb_id).pluck(:thumb_id).uniq
    #@all_dates_staffs = StaffAttendance.where('logged_at>=? and logged_at<? and thumb_id IN(?)',"2012-05-07","2014-01-01", thumb_ids_in_staff).order('logged_at ASC').limit(1500)
    @all_dates_staffs = StaffAttendance.where('logged_at>=? and logged_at<? and thumb_id IN(?)',Date.today-2.years, Date.today+1.day, thumb_ids_in_staff).order('logged_at ASC').limit(15000)
#     @logged_at_list =[]
#     for all_dates_staff in @all_dates_staffs.map(&:logged_at)
#       @logged_at_list << all_dates_staff.in_time_zone('UTC').to_date.beginning_of_month.to_s
#     end
#     @title_for_month= @logged_at_list.uniq
    @title_for_month=@all_dates_staffs.map{|x|x.logged_at.in_time_zone('UTC').to_date.beginning_of_month.to_s}.uniq
#     @all_thumbs = @all_dates_staffs.map(&:thumb_id).uniq.sort


#     @staff_info = Staff.where('thumb_id IN (?)',@all_thumbs).order('thumb_id ASC').select("thumb_id, name,id")
#     @staff_thumb = Staff.where('thumb_id IN (?)',@all_thumbs).order('thumb_id ASC').map(&:thumb_id)
    #for checking : @staff_name = Staff.find(:all, :conditions=> ['thumb_id IN (?)',@all_thumbs], :order=>'thumb_id ASC').map(&:staff_thumb)
    @all_dates = @all_dates_staffs.group_by{|x|x.thumb_id}

    #StaffAttendance.find(:all, :conditions => ["trigger IS TRUE AND is_approved IS FALSE AND thumb_id =? AND logged_at>=? AND logged_at<?", 773, "2012-10-01", "2012-11-01"], :order => 'logged_at DESC').count
    #StaffAttendance.find(:all, :conditions => ["trigger IS TRUE AND is_approved IS FALSE AND thumb_id =? AND logged_at>=? AND logged_at<?", 772, "2012-10-01", "2012-11-01"], :order => 'logged_at DESC').count
    @year_group = @title_for_month.group_by{|x|x.to_date.year}

    #@thismonthreds = StaffAttendance.this_month_red
    #@lastmonthreds = StaffAttendance.last_month_red
    #@prevmonthreds = StaffAttendance.previous_month_red

    #@thismonthgreens = StaffAttendance.this_month_green
    #@lastmonthgreens = StaffAttendance.last_month_green
    #@prevmonthgreens = StaffAttendance.previous_month_green
  end
  
  def attendance_report 
    #@udept=Position.unit_department2 <--  be4 AMSAS - data entry(org chart) #Position.unit_department
    if current_user.college.code=='amsas'
      @udept=Position.department_list(current_user.college.code)
      @udept_staffs=Position.thumbids_per_department #<--  be4 AMSAS - data entry(org chart) #StaffAttendance.get_thumb_ids_unit_names_amsas
    else
      @udept=Position.unit_department2
      @udept_staffs=Position.unit_department_staffs2 #Position.unit_department_staffs
    end
  end
  
  def attendance_report_main
    commit = params[:list_submit_button]
    if commit==t('staff_attendance.daily_report')
      if params[:daily_date].blank? || params[:unit_department].blank? 
        redirect_to(attendance_report_staff_staff_attendances_path, :notice => I18n.t('staff_attendance.compulsory_daily'))
      elsif params[:unit_department].include?("--")
        redirect_to(attendance_report_staff_staff_attendances_path, :notice => I18n.t('staff_attendance.require_complete_data'))
      else
        redirect_to daily_report_staff_staff_attendances_path(:daily_date => params[:daily_date], :unit_department => params[:unit_department], format: 'pdf' )
      end
    elsif commit==t('staff_attendance.weekly_report')
      if params[:weekly_date].blank? || params[:unit_department].blank?
        redirect_to(attendance_report_staff_staff_attendances_path, :notice => I18n.t('staff_attendance.compulsory_weekly'))
      elsif params[:unit_department].include?("--")
        redirect_to(attendance_report_staff_staff_attendances_path, :notice => I18n.t('staff_attendance.require_complete_data'))
      else
        redirect_to weekly_report_staff_staff_attendances_path(:weekly_date => params[:weekly_date], :unit_department => params[:unit_department], format: 'pdf' )
      end 
    elsif commit==t('staff_attendance.monthly_report')
      if params[:monthly_date].blank? || params[:unit_department].blank?
        redirect_to(attendance_report_staff_staff_attendances_path, :notice => I18n.t('staff_attendance.compulsory_monthly'))
      elsif params[:unit_department].include?("--")
        redirect_to(attendance_report_staff_staff_attendances_path, :notice => I18n.t('staff_attendance.require_complete_data'))
      else
        redirect_to monthly_report_staff_staff_attendances_path(:monthly_date => params[:monthly_date], :unit_department => params[:unit_department], format: 'pdf' )
      end 
    elsif commit==t('staff_attendance.monthly_listing')
      if params[:monthly_list].blank? || params[:unit_department].blank? || params[:staff].blank?
        redirect_to(attendance_report_staff_staff_attendances_path, :notice => I18n.t('staff_attendance.compulsory_listing'))
      elsif params[:staff]==(t 'select')
	redirect_to(attendance_report_staff_staff_attendances_path, :notice => I18n.t('staff_attendance.compulsory_listing'))
      else
        redirect_to monthly_listing_staff_staff_attendances_path(:monthly_list => params[:monthly_list], :unit_department => params[:unit_department], :staff => params[:staff] ,format: 'pdf' )
      end
    elsif commit==t('staff_attendance.monthly_details')
      if params[:monthly_list2].blank? || params[:unit_department].blank? || params[:staff2].blank? || params[:details_type].blank?
        redirect_to(attendance_report_staff_staff_attendances_path, :notice => I18n.t('staff_attendance.compulsory_details'))
      elsif params[:staff2]==(t 'select')
        redirect_to(attendance_report_staff_staff_attendances_path, :notice => I18n.t('staff_attendance.compulsory_details'))
      else
        redirect_to monthly_details_staff_staff_attendances_path(:monthly_list2 => params[:monthly_list2], :unit_department => params[:unit_department], :staff2 => params[:staff2], :details_type => params[:details_type], format: 'pdf' )
      end
    end
  end

  def daily_report
    daily_date=params[:daily_date].to_date
    daily_start=daily_date.beginning_of_day
    daily_end=daily_date.end_of_day
    unit_dept=params[:unit_department]
    unit_dept_post_staffids=Position.where('staff_id is not null and unit=?', unit_dept).pluck(:staff_id)
    unit_dept_post_staffids+=Position.where('staff_id is not null and unit=?', "Pentadbiran").pluck(:staff_id) if unit_dept=="Pentadbiran Am"
    thumb_ids=Staff.where('thumb_id is not null and id in(?)', unit_dept_post_staffids).pluck(:thumb_id)
    unit_dept_post_staffids.each do |staffid|
      if User.where(userable_id: staffid.to_i).count > 0 #check account existance
        staff_roles=User.where(userable_id: staffid.to_i).first.roles.map(&:authname)
        @leader_id=staffid if staff_roles.include?("unit_leader") || staff_roles.include?("programme_manager")
      end
    end
    unless @leader_id.nil?
      @leader=Staff.find(@leader_id.to_i) 
    else
      @leader=Position.unit_department_leader(unit_dept)
    end
    #to confirm
    #@staff_attendances = StaffAttendance.where('logged_at >? and logged_at <? and thumb_id IN(?)', daily_start, daily_end, thumb_ids)
    @staff_attendances = StaffAttendance.where('trigger is true and logged_at >? and logged_at <? and thumb_id IN(?) and is_approved is not true', daily_start, daily_end, thumb_ids)
    @w_wo_triggered = StaffAttendance.where('logged_at >? and logged_at <? and thumb_id IN(?)', daily_start, daily_end, thumb_ids)
    respond_to do |format|
      format.pdf do
        pdf = Laporan_harian_punchcardPdf.new(@staff_attendances, @leader, daily_date, thumb_ids, @w_wo_triggered, view_context)
        send_data pdf.render, filename: "laporan_harian_punchcard-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def weekly_report
    weekly_date=params[:weekly_date].to_time
    weekly_start=weekly_date.beginning_of_week
    weekly_end=weekly_date.end_of_week
    if weekly_date.year < 2015
      wstart=weekly_start
      wend=weekly_end
    elsif weekly_date.year > 2014
      wstart=(weekly_start-1.days).to_time.beginning_of_day
      wend=(weekly_start+3.days ).to_time.end_of_day
    end
    unit_dept=params[:unit_department]
    unit_dept_post_staffids=Position.where('staff_id is not null and unit=?', unit_dept).pluck(:staff_id)
    unit_dept_post_staffids+=Position.where('staff_id is not null and unit=?', "Pentadbiran").pluck(:staff_id) if unit_dept=="Pentadbiran Am"
    thumb_ids=Staff.where('thumb_id is not null and id in(?)', unit_dept_post_staffids).pluck(:thumb_id)
    unit_dept_post_staffids.each do |staffid|
      if User.where(userable_id: staffid.to_i).count > 0 #check account existance
        staff_roles=User.where(userable_id: staffid.to_i).first.roles.map(&:authname)
        @leader_id=staffid if staff_roles.include?("unit_leader") || staff_roles.include?("programme_manager")
      end
    end
    unless @leader_id.nil?
      @leader=Staff.find(@leader_id.to_i) 
    else
      @leader=Position.unit_department_leader(unit_dept)
    end
    #@staff_attendances = StaffAttendance.where('trigger is true and logged_at >? and logged_at <? and thumb_id IN(?)', weekly_start, weekly_end, thumb_ids)
    @staff_attendances = StaffAttendance.where("trigger=? AND is_approved =? AND thumb_id IN (?) AND logged_at>=? AND logged_at<=?", true, false, thumb_ids, wstart, wend).order(logged_at: :desc)
    @notapproved_lateearly=@staff_attendances.group_by {|t| t.thumb_id } 
    
    respond_to do |format|
      format.pdf do
        pdf = Laporan_mingguan_punchcardPdf.new(@staff_attendances, @leader, weekly_date, @notapproved_lateearly, thumb_ids, view_context)
        send_data pdf.render, filename: "laporan_mingguan_punchcard-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def monthly_report
    monthly_date=params[:monthly_date].to_time
    monthly_start=monthly_date.beginning_of_month
    monthly_end=monthly_date.end_of_month
    unit_dept=params[:unit_department]
    unit_dept_post_staffids=Position.where('staff_id is not null and unit=?', unit_dept).pluck(:staff_id)
    unit_dept_post_staffids+=Position.where('staff_id is not null and unit=?', "Pentadbiran").pluck(:staff_id) if unit_dept=="Pentadbiran Am"
    thumb_ids=Staff.where('thumb_id is not null and id in(?)', unit_dept_post_staffids).pluck(:thumb_id)
    unit_dept_post_staffids.each do |staffid|
      if User.where(userable_id: staffid.to_i).count > 0 #check account existance
        staff_roles=User.where(userable_id: staffid.to_i).first.roles.map(&:authname)
        @leader_id=staffid if staff_roles.include?("unit_leader") || staff_roles.include?("programme_manager")
      end
    end
    unless @leader_id.nil?
      @leader=Staff.find(@leader_id.to_i) 
    else
      @leader=Position.unit_department_leader(unit_dept)
    end
    #@staff_attendances = StaffAttendance.where('trigger is true and logged_at >? and logged_at <? and thumb_id IN(?)', monthly_start, monthly_end, thumb_ids)
    @staff_attendances = StaffAttendance.count_non_approved(thumb_ids, monthly_start, monthly_end)
    @notapproved_lateearly=StaffAttendance.where("trigger=? AND is_approved =? AND thumb_id IN (?) AND logged_at>=? AND logged_at<=?", true, false, thumb_ids, monthly_start, monthly_end).order(logged_at: :desc).group_by {|t| t.thumb_id }
    
    respond_to do |format|
      format.pdf do
        pdf = Laporan_bulanan_punchcardPdf.new(@staff_attendances,@leader, monthly_date, @notapproved_lateearly, thumb_ids, view_context)
        send_data pdf.render, filename: "laporan_bulanan_punchcard-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def monthly_listing
    monthly_list=params[:monthly_list].to_time
    monthly_start=monthly_list.beginning_of_month
    monthly_end=monthly_list.end_of_month
    unless current_user.college.code=='amsas'
      staff=params[:staff].to_i   #  <--  be4 AMSAS - data entry(org chart) 
      thumb_id=Staff.find(staff).thumb_id 
    else
      thumb_id=params[:staff].to_i
    end
    unit_dept=params[:unit_department]
    @staff_attendances=StaffAttendance.where('thumb_id=? and logged_at >=? and logged_at <=?', thumb_id, monthly_start, monthly_end).order('logged_at ASC, log_type ASC')
    respond_to do |format|
      format.pdf do
        pdf = Senarai_bulanan_punchcardPdf.new(@staff_attendances, monthly_list, unit_dept, thumb_id, view_context)
        send_data pdf.render, filename: "senarai_bulanan_punchcard-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def monthly_details
    monthly_list2=params[:monthly_list2].to_time
    monthly_start=monthly_list2.beginning_of_month
    monthly_end=monthly_list2.end_of_month
    unless current_user.college.code=='amsas'
      staff2=params[:staff2].to_i   #  <--  be4 AMSAS - data entry(org chart) 
      thumb_id=Staff.find(staff2).thumb_id 
    else
      thumb_id=params[:staff2].to_i
    end
    unit_dept=params[:unit_department]
    list_type=params[:details_type]
    @staff_attendances=StaffAttendance.where('thumb_id=? and logged_at >=? and logged_at <=?', thumb_id, monthly_start, monthly_end).order('logged_at ASC, log_type ASC')
    respond_to do |format|
      format.pdf do
        pdf = Perincian_bulanan_punchcardPdf.new(@staff_attendances, monthly_list2, unit_dept, thumb_id, list_type, view_context)
        send_data pdf.render, filename: "senarai_bulanan_punchcard-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def attendance_list
    respond_to do |format|
      format.pdf do
        pdf = Attendance_listPdf.new(@ooo, @group_sa_by_day, @search, view_context, current_user.college)
        send_data pdf.render, filename: "attendance_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  def attendance_status_list
    thumb_ids_in_staff = Staff.where('thumb_id IS NOT NULL').pluck(:thumb_id).uniq.sort
    all_dates_staffs = StaffAttendance.where('logged_at>=? and logged_at<? and thumb_id IN(?)',Date.today-2.years, Date.today+1.day, thumb_ids_in_staff).order('logged_at ASC').limit(15000)
    @all_dates = all_dates_staffs.group_by{|x|x.thumb_id}
    @title_for_month=all_dates_staffs.map{|x|x.logged_at.in_time_zone('UTC').to_date.beginning_of_month.to_s}.uniq
    @year_group = @title_for_month.group_by{|x|x.to_date.year}

    respond_to do |format|
      format.pdf do
        pdf = Attendance_status_listPdf.new(@all_dates, @title_for_month, @year_group, view_context, current_user.college)
        send_data pdf.render, filename: "attendance_status_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff_attendance
      @staff_attendance = StaffAttendance.find(params[:id])
    end
    
    def set_staff_attendances
      #/////////////////
      #@mylate_attendances = StaffAttendance.find_mylate(@current_user)
      #@approvelate_attendances = StaffAttendance.find_approvelate(@current_user)

      @thumb_ids =  StaffAttendance.get_thumb_ids_unit_names(1)
      @unit_names = StaffAttendance.get_thumb_ids_unit_names(2)
      @all_thumb_ids = StaffAttendance.thumb_ids_all
      #////////////////
    
      #Part 1 - Ransack Search
      @search = StaffAttendance.search(params[:q])
      @staff_attendances2 = @search.result

      #ERROR 'Key Not Found' will arise, for EXISTING THUMBPRINT W/O matching user/staff
      #(at line : sort_unit=sas2.sort_by{|item2| @lookup.fetch(item2.thumb_id)})
      #(Restriction for NEW import excel already included - refer Spreadsheet2.update_thumb_id)
      #Restrict retrieval of invalid EXISTING SA (thumbprint record w/o matching user/staff) as below line::::STAFF NOT EXIST? (for thumb_id)
      #try hack for RANSACK result only - KSKB server not OK
      @staff_attendances2 = @staff_attendances2.where('thumb_id IN(?)', @all_thumb_ids) if @staff_attendances2!=nil
      #end part 1

      #Part 2 - Other than Ransack
      #hack for ALL unit
      #if params[:q]==nil  ||  (params[:q][:keyword_search]==nil)
  	#@staff_attendances2 = @staff_attendances2.where('logged_at >? and logged_at<? and thumb_id IN(?)','2012-09-30','2012-11-01',@all_thumb_ids)
  	#@staff_attendances2 = StaffAttendance.where('logged_at >? and logged_at<? and thumb_id IN(?)','2012-12-31','2014-12-01', @all_thumb_ids)
      #end
      #end part 2

      if params[:q]==nil  || (params[:q][:keyword_search]==nil)
        #part 1 : records for latest 2 months
        #(a) From menu -> Staff | Staff Attendance | Staff Attendance
        #(b) Search for ALL department - w/o date (result: latest 2 months)
        @startdate = (Date.today.end_of_month-3.month).strftime('%Y-%m-%d')		#'2014-05-31'
        @enddate = (Date.today+1.day).strftime('%Y-%m-%d')					#'2014-08-10'
        @staff_attendances2 = @staff_attendances2.where('logged_at >? and logged_at<? and thumb_id IN(?)',@startdate,@enddate,@all_thumb_ids)
      elsif params[:q]!=nil && (params[:q][:keyword_search]!=nil)
        #part 2 : records starting current date upto 2 years in reverse
        #Search by ONE department - w/o date (result: latest 2 years)
        @startdate = (Date.today.end_of_year-3.year).strftime('%Y-%m-%d')		#'2011-12-31'
        @enddate = (Date.today+1.day).strftime('%Y-%m-%d')				#'2014-08-10'
        @staff_attendances2 = @staff_attendances2.where('logged_at >? and logged_at<? and thumb_id IN(?)',@startdate,@enddate,@all_thumb_ids)
      end
      #end part 2

      @groupped_by_date = @staff_attendances2.group_by{|r|r.group_by_thingy}	#Active Records : relations
      @lookup={}
      @all_thumb_ids.each_with_index do |item, index|
	  @lookup[item]=index
      end
      @dategroup_then_unit=[]
      @groupped_by_date.sort.reverse.each do |date2,sas2|
        sort_unit=sas2.sort_by{|item2| @lookup.fetch(item2.thumb_id)}
        @dategroup_then_unit<< sort_unit
      end
      @keluar_balik=[]
      @dategroup_then_unit.each do |sorted_date|
	  sorted_date.each do |sorted_unit|
	    @keluar_balik<< sorted_unit
	  end
      end

      @staff_attendances = Kaminari.paginate_array(@keluar_balik).page(params[:page]||1)
      @ooo = @staff_attendances.group_by {|t| t.group_by_thingy }

      #Normal Array (diff fr @gropped_by_date)
      #group all attendances by DATE first for use - to determine last SA record of the day
      @group_sa_by_day=@keluar_balik.group_by{|t|t.group_by_thingy}
       
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staff_attendance_params
      params.require(:staff_attendance).permit(:thumb_id, :logged_at, :log_type, :reason, :trigger, :approved_by, :is_approved, :approved_on, :status, :review, :college_id, {:data => []})
    end
end
