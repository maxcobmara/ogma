class Training::WeeklytimetablesController < ApplicationController
  before_action :set_weeklytimetable, only: [:show, :edit, :update, :destroy]
  # GET /weeklytimetables
  # GET /weeklytimetables.xml
  def index
    #@weeklytimetables = Weeklytimetable.all
    #current_user = User.find(11)    #maslinda 
    #current_user = User.find(72)    #izmohdzaki
    @position_exist = Staff.where(id:25)[0].try(:positions)  #current_user.staff.positions
    if @position_exist  
      #@lecturer_programme = current_user.staff.positions[0].unit
      @lecturer_programme = Staff.where(id:25)[0].positions.try(:unit) 
      unless @lecturer_programme.nil?
        @programme = Programme.find(:first,:conditions=>['name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0])
      end
      unless @programme.nil?
        @programme_id = @programme.id 
      end
      #common subject - not yet - no matching programme (although assign as coordinator)
      #@weeklytimetables = Weeklytimetable.with_permissions_to(:index).search(@programme_id) 
      #@weeklytimetables = Weeklytimetable.search(@programme_id) 
    end
    
    @search = Weeklytimetable.search(params[:q])
    @weeklytimetables2 = @search.result                                                           
    @weeklytimetables3 = @weeklytimetables2.where(:programme_id => @programme_id) if @programme_id!=nil
    @weeklytimetables3 = @weeklytimetables2 if @programme_id==nil    
    @weeklytimetables = @weeklytimetables3.order(programme_id: :asc).page(params[:page]||1)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @weeklytimetables }
    end
  end
  
  def personalize_index
    @weeklytimetables_details=WeeklytimetableDetail.where('lecturer_id=?',@current_user.userable_id)

    respond_to do |format|
      format.html { render :action => "personalize_index" }
      format.xml  { render :xml => @weeklytimetables }
    end
  end

  # GET /weeklytimetables/1
  # GET /weeklytimetables/1.xml
  def show
    #current_user = User.find(11)    #maslinda 
    #current_user = User.find(72)    #izmohdzaki
    #roles = current_user.roles.pluck(:id)
    @weeklytimetable = Weeklytimetable.find(params[:id])
    @count1=@weeklytimetable.timetable_monthurs.timetable_periods.count
    @count2=@weeklytimetable.timetable_friday.timetable_periods.count 
    @staffid=25
    roles = Role.joins(:logins).where('logins.id=?',11).pluck(:id).uniq
    @is_admin = roles.include?(2)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @weeklytimetable }
    end
  end
  
  def personalize_show  
    @test_lecturer = @current_user   
    @selected_date = params[:id]
    @weeklytimetables_details=WeeklytimetableDetail.where('lecturer_id=?',@current_user.userable_id)
    
    @all_combine = []
    @weeklytimetables_details.each do |x|
        @all_combine << Weeklytimetable.find(x.weeklytimetable.id)
    end 
    @personalize = @all_combine.group_by{|t|t.startdate}
  end
  
  # GET /weeklytimetables/new
  # GET /weeklytimetables/new.xml
  def new
    @weeklytimetable = Weeklytimetable.new
    #@weeklytimetable.weeklytimetable_details.build
    @staffid = 25
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @weeklytimetable }
    end
  end

  # GET /weeklytimetables/1/edit
  def edit
    current_user = Login.find(11)#User.find(11)    #maslinda 
    #current_user = User.find(72)    #izmohdzaki
    roles = current_user.roles.pluck(:id)
    @is_admin = roles.include?(2)
    @staffid = 25
    #start-remove from partial : tab_daily_details_edit
    @count1=@weeklytimetable.timetable_monthurs.timetable_periods.count
    @count2=@weeklytimetable.timetable_friday.timetable_periods.count 
    @break_format1 = @weeklytimetable.timetable_monthurs.timetable_periods.pluck(:is_break)
    @break_format2 = @weeklytimetable.timetable_friday.timetable_periods.pluck(:is_break)
    @weeklytimetable = Weeklytimetable.find(params[:id])
    #start-remove from partial : tab_daily_details_edit
    #start-remove from partial : subtab_class_details_edit
    @semester_subject_topic_list = Programme.find(@weeklytimetable.programme_id).descendants.where('ancestry_depth=? OR ancestry_depth=?',3,4).sort_by(&:combo_code)		
    @timeslot = @weeklytimetable.timetable_monthurs.timetable_periods.where('is_break is false')
    @timeslot2 = @weeklytimetable.timetable_friday.timetable_periods.where('is_break is false')
    #start-remove from partial : subtab_class_details_edit  
  end

  # POST /weeklytimetables
  # POST /weeklytimetables.xml
  def create
    @weeklytimetable = Weeklytimetable.new(weeklytimetable_params)

    respond_to do |format|
      if @weeklytimetable.save
        format.html { redirect_to(training_weeklytimetable_path(@weeklytimetable), :notice => (t 'training.weeklytimetable.title')+(t 'actions.created')) }
        format.xml  { render :xml => @weeklytimetable, :status => :created, :location => @weeklytimetable }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @weeklytimetable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /weeklytimetables/1
  # PUT /weeklytimetables/1.xml
  def update
    #raise params.inspect

    @weeklytimetable = Weeklytimetable.find(params[:id])
    
    #start-copy from edit
    @count1=@weeklytimetable.timetable_monthurs.timetable_periods.count
    @count2=@weeklytimetable.timetable_friday.timetable_periods.count 
    @break_format1 = @weeklytimetable.timetable_monthurs.timetable_periods.pluck(:is_break)
    @break_format2 = @weeklytimetable.timetable_friday.timetable_periods.pluck(:is_break)
    @weeklytimetable = Weeklytimetable.find(params[:id])
    #start-remove from partial : tab_daily_details_edit
    #start-remove from partial : subtab_class_details_edit
    @semester_subject_topic_list = Programme.find(@weeklytimetable.programme_id).descendants.where('ancestry_depth=? OR ancestry_depth=?',3,4).sort_by(&:combo_code)		
    @timeslot = @weeklytimetable.timetable_monthurs.timetable_periods.where('is_break is false')
    @timeslot2 = @weeklytimetable.timetable_friday.timetable_periods.where('is_break is false')
    #start-copy from edit
    
    respond_to do |format|
      if @weeklytimetable.update(weeklytimetable_params)
        format.html { redirect_to(training_weeklytimetable_path(@weeklytimetable), :notice => (t 'training.weeklytimetable.title')+(t 'actions.updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @weeklytimetable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /weeklytimetables/1
  # DELETE /weeklytimetables/1.xml
  def destroy
    @weeklytimetable = Weeklytimetable.find(params[:id])
    @weeklytimetable.destroy

    respond_to do |format|
      format.html { redirect_to(weeklytimetables_url) }
      format.xml  { head :ok }
    end
  end
  
  def weekly_timetable
    @weeklytimetable = Weeklytimetable.find(params[:id])
    
    respond_to do |format|
      format.pdf do
        pdf = Weekly_timetablePdf.new(@weeklytimetable, view_context)
        send_data pdf.render, filename: "timetable_blank-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def personalizetimetable
    @test_lecturer = @current_user   
    @selected_date = params[:id]
    @weeklytimetables_details=WeeklytimetableDetail.where('lecturer_id=?',@current_user.userable_id)
    
    @all_combine = []
    @weeklytimetables_details.each do |x|
        @all_combine << Weeklytimetable.find(x.weeklytimetable.id)
    end 
    @personalize = @all_combine.group_by{|t|t.startdate}
    
    respond_to do |format|
      format.pdf do
        pdf = PersonalizetimetablePdf.new(@personalize, view_context, @test_lecturer, @selected_date)
        send_data pdf.render, filename: "timetable_blank-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end  
  
  #23March2013
  def general_timetable
    @weeklytimetable = Weeklytimetable.find(params[:id])
    render :layout => 'report'
  end
  
  def personalize_timetable
    @selected_date = params[:id]
    #---start:added-26Jul2013-for e-query & report manager--
    if @selected_date
    else
        @hihi = params[:locals][:id]
        @haha = params[:locals][:lecturer_id]
    end
    #---end:added-26Jul2013-for e-query & report manager--
    @weeklytimetables_details=WeeklytimetableDetail.find(:all, :conditions => ['lecturer_id=?',User.current_user.staff_id])
    #---start:added-26Jul2013-for e-query & report manager--
    if @hihi!=nil
        @selected_date = @hihi
        @weeklytimetables_details=WeeklytimetableDetail.find(:all, :conditions => ['lecturer_id=?',@haha.to_i])
    end
    #---end:added-26Jul2013-for e-query & report manager--
    @all_combine = []
    @weeklytimetables_details.each do |x|
        @all_combine << Weeklytimetable.find(x.weeklytimetable_id)  #Weeklytimetable.find(x.weeklytimetable.id)
    end 
    @personalize = @all_combine.group_by{|t|t.startdate}
    render :layout => 'report'
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_weeklytimetable
      @weeklytimetable = Weeklytimetable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def weeklytimetable_params
      params.require(:weeklytimetable).permit(:programme_id, :intake_id, :group_id, :startdate, :enddate, :semester, :prepared_by, :endorsed_by, :format1, :format2, :week, :is_submitted, :submitted_on, :hod_approved, :hod_approved_on, :hod_rejected, :hod_rejected_on, :reason, weeklytimetable_details_attributes: [:id,:topic, :time_slot, :lecturer_id, :weeklytimetable_id, :day2, :is_friday, :time_slot2, :location, :lecture_method, :subject, :location_desc])
    end
  
end
