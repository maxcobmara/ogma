class Staff::StaffAttendancesController < ApplicationController
  before_action :set_staff_attendance, only: [:show, :edit, :update, :destroy]

  # GET /staff_attendances
  # GET /staff_attendances.xml
  def index
    @mylate_attendances = StaffAttendance.find_mylate(@current_user)
    @approvelate_attendances = StaffAttendance.find_approvelate(@current_user)

    @thumb_ids =  StaffAttendance.get_thumb_ids_unit_names(1)
    @unit_names = StaffAttendance.get_thumb_ids_unit_names(2)
    @all_thumb_ids = StaffAttendance.thumb_ids_all

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
      format.html { redirect_to(staff_attendances_url) }
      format.xml  { head :ok }
    end
  end

  def laporan_bulanan_punchcard

    @staff_attendance = StaffAttendance.where(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Laporan_bulanan_punchcardPdf.new(@staff_attendance, view_context)
        send_data pdf.render, filename: "laporan_bulanan_punchcard-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def laporan_mingguan_punchcard

    @staff_attendance = StaffAttendance.where(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Laporan_mingguan_punchcardPdf.new(@staff_attendance, view_context)
        send_data pdf.render, filename: "laporan_mingguan_punchcard-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def laporan_harian_punchcard

    @staff_attendance = StaffAttendance.where(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Laporan_harian_punchcardPdf.new(@staff_attendance, view_context)
        send_data pdf.render, filename: "laporan_harian_punchcard-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def manage
    @mylate_attendances = StaffAttendance.find_mylate(@current_user)
    @myearly_attendances = StaffAttendance.find_myearly(@current_user)
    @approvelate_attendances = StaffAttendance.find_approvelate(@current_user)
    @approveearly_attendances = StaffAttendance.find_approveearly(@current_user)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @staff_attendances }
    end
  end

  def approve
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
    @all_dates_staffs = StaffAttendance.where('logged_at>=? and logged_at<? and thumb_id IN(?)',"2012-05-07","2014-01-01", thumb_ids_in_staff).order('logged_at ASC').limit(1500)
    @logged_at_list =[]
    for all_dates_staff in @all_dates_staffs.map(&:logged_at)
      @logged_at_list << all_dates_staff.in_time_zone('UTC').to_date.beginning_of_month.to_s
    end
    @title_for_month= @logged_at_list.uniq
    @all_thumbs = @all_dates_staffs.map(&:thumb_id).uniq.sort


    @staff_info = Staff.where('thumb_id IN (?)',@all_thumbs).order('thumb_id ASC').select("thumb_id, name,id")
    @staff_thumb = Staff.where('thumb_id IN (?)',@all_thumbs).order('thumb_id ASC').map(&:thumb_id)
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

  def report
  end

  def monthly_weekly_report
  end

  def monthly_listing
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff_attendance
      @staff_attendance = StaffAttendance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staff_attendance_params
      params.require(:staff_attendance).permit(:thumb_id, :logged_at, :log_type, :reason, :trigger, :approved_by, :is_approved, :approved_on, :status, :review)
    end
end
