class Training::WeeklytimetablesController < ApplicationController
  #filter_resource_access
  filter_access_to :all
  
  before_action :set_weeklytimetable, only: [:show, :edit, :update, :destroy]
  # GET /weeklytimetables
  # GET /weeklytimetables.xml
  def index
    #@weeklytimetables = Weeklytimetable.all
    @search = Weeklytimetable.search(params[:q])
    @weeklytimetables2= @search.result  
    
    roles = current_user.roles.pluck(:authname)
    @is_admin = roles.include?("administration") 
    @position_exist = current_user.userable.positions
    if @position_exist && @position_exist.count > 0 && !@position_exist.first.unit.blank?
      main_task_first=@position_exist.first.tasks_main
      lecturer_programme = current_user.userable.positions[0].unit
      unless lecturer_programme.nil?
        programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{lecturer_programme}%",0)  #Diploma only
      end
      unless programme.nil? || programme.count==0
        programme_id = programme.try(:first).try(:id)
        @weeklytimetables3 = @weeklytimetables2.search2(programme_id, roles, current_user.userable_id)
      else
        if @is_admin
          @weeklytimetables3 = @weeklytimetables2
        elsif ["Diploma Lanjutan", "Pos Basik", "Pengkhususan"].include?(lecturer_programme)
          if roles.include?("programme_manager")  #Ketua Program Pengkhususan
            programme_ids=Programme.where(course_type: ["Diploma Lanjutan", "Pos Basik", "Pengkhususan"]).pluck(:id)
            @weeklytimetables3 = @weeklytimetables2.where(programme_id: programme_ids)
          else
            programme_id=Position.get_postbasic_id(main_task_first, lecturer_programme)
            @weeklytimetables3 = @weeklytimetables2.search2(programme_id, roles, current_user.userable_id)
          end
        elsif ["Sains Perubatan Asas", "Anatomi & Fisiologi", "Sains Tingkahlaku", "Komunikasi & Sains Pengurusan", "Komuniti"].include?(lecturer_programme) && roles.include?("unit_leader")
            @weeklytimetables3 = @weeklytimetables2
        end
      end
      @is_coordinator= Intake.where(programme_id: programme_id, staff_id: current_user.userable_id).count > 0       #coordinator - determine in Intakes
      @weeklytimetables = @weeklytimetables3.order(programme_id: :asc, intake_id: :desc, startdate: :desc).page(params[:page]||1)
      
    end 
    
    respond_to do |format|
      if @position_exist.first && !@position_exist.first.unit.blank?
        format.html # index.html.erb
        format.xml  { render :xml => @weeklytimetables }
      else
        format.html {redirect_to '/dashboard', notice: "Position (and unit) are required to be assigned!"}
      end
    end
  end
  
  def personalize_index
    @weeklytimetables_details=WeeklytimetableDetail.where('lecturer_id=?', current_user.userable_id)
    respond_to do |format|
      format.html { render :action => "personalize_index" }
      format.xml  { render :xml => @weeklytimetables }
    end
  end

  # GET /weeklytimetables/1
  # GET /weeklytimetables/1.xml
  def show
    @weeklytimetable = Weeklytimetable.find(params[:id])
    @count1=@weeklytimetable.timetable_monthurs.timetable_periods.count
    @count2=@weeklytimetable.timetable_friday.timetable_periods.count 
    @staffid=current_user.userable_id
    roles=current_user.roles.pluck(:authname)
    lecturer_programme = current_user.userable.positions[0].unit
    @is_admin=roles.include?("administration")
    @is_coordinator= Intake.where(programme_id: @weeklytimetable.programme_id, staff_id: current_user.userable_id).count > 0 
    @is_creator=@weeklytimetable.prepared_by==@staffid
    @is_common_leader=["Sains Perubatan Asas", "Anatomi & Fisiologi", "Sains Tingkahlaku", "Komunikasi & Sains Pengurusan", "Komuniti"].include?(lecturer_programme) && roles.include?("unit_leader")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @weeklytimetable }
    end
  end
  
  def personalize_show   
    @test_lecturer=current_user
    @selected_date = params[:id]
    @weeklytimetables_details=WeeklytimetableDetail.where('lecturer_id=?', current_user.userable_id)
    @all_combine = []
    @weeklytimetables_details.each do |x|
        @all_combine << Weeklytimetable.find(x.weeklytimetable.id)
    end 
    @personalize = @all_combine.group_by{|t|t.startdate}
  end
  
  # GET /weeklytimetables/new
  # GET /weeklytimetables/new.xml
  def new
    #Admin & Coordinator ONLY - diploma & pos basik/pengkhususan/dip lanjutan (common subjects lecturer has no access)
    @weeklytimetable = Weeklytimetable.new
    @staffid = current_user.userable_id 
    roles = current_user.roles.pluck(:authname)
    @is_admin = roles.include?("administration") 
    if @is_admin
      @programme_list=Programme.roots
      @intake_list=Intake.all.order(programme_id: :asc, monthyear_intake: :desc)
      posbasics=["Diploma Lanjutan", "Pos Basik", "Pengkhususan"]
      prog_names=@programme_list.where(course_type: "Diploma").pluck(:name)
      @lecturer_list= Staff.joins(:positions).where('positions.unit IN(?) or positions.unit IN(?)', prog_names, posbasics).order(name: :asc)
    else
      #retrieve programme & groups coordinated from Intake
      @programme_id=Intake.where(staff_id: @staffid).first.programme_id
      @programme_list=Programme.roots.where(id: @programme_id)
      group_intake_ids=Intake.where(programme_id: @programme_id, staff_id: @staffid).pluck(:id).compact
      @intake_list=Intake.where(id: group_intake_ids)
      @lecturer_list=Staff.where(id: @staffid)
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @weeklytimetable }
    end
  end

  # GET /weeklytimetables/1/edit
  def edit
    roles = current_user.roles.pluck(:authname)
    @is_admin = roles.include?("administration")
    @staffid = current_user.userable_id
    lecturer_programme = current_user.userable.positions[0].unit
    @is_coordinator= Intake.where(programme_id: @weeklytimetable.programme_id, staff_id: current_user.userable_id).count > 0
    @is_creator=@weeklytimetable.prepared_by==@staffid
    @is_common_leader=["Sains Perubatan Asas", "Anatomi & Fisiologi", "Sains Tingkahlaku", "Komunikasi & Sains Pengurusan", "Komuniti"].include?(lecturer_programme) && roles.include?("unit_leader")
    #start-remove from partial : tab_daily_details_edit
    @count1=@weeklytimetable.timetable_monthurs.timetable_periods.count
    @count2=@weeklytimetable.timetable_friday.timetable_periods.count 
    @break_format1 = @weeklytimetable.timetable_monthurs.timetable_periods.order(sequence: :asc).pluck(:is_break)
    @break_format2 = @weeklytimetable.timetable_friday.timetable_periods.order(sequence: :asc).pluck(:is_break)
    @weeklytimetable = Weeklytimetable.find(params[:id])
    #start-remove from partial : tab_daily_details_edit
    #start-remove from partial : subtab_class_details_edit
    @timeslot = @weeklytimetable.timetable_monthurs.timetable_periods.where('is_break is false')
    @timeslot2 = @weeklytimetable.timetable_friday.timetable_periods.where('is_break is false')
    #start-remove from partial : subtab_class_details_edit  
    #start-lecturer list - edit of programme no longer available, diploma & posbasic lecturer list already fixed
    dip_programmes=Programme.roots.where(course_type: "Diploma").pluck(:name)
    lecturer_programme = current_user.userable.positions[0].unit   #note - dip & posbasic (programme name), commonsubjects (subject name)
    programme=Programme.find(@weeklytimetable.programme_id)
    prog_name=programme.name #based on saved records
    prog_type=programme.course_type #based on saved records
    posbasics= ["Diploma Lanjutan", "Pos Basik", "Pengkhususan"]
    common_subjects = ["Sains Perubatan Asas", "Anatomi & Fisiologi", "Sains Tingkahlaku", "Komunikasi & Sains Pengurusan", "Komuniti"]
    
    ##diploma & posbasic - based on saved WT(coordinators/admin), commonsubjects - based on logged-in user(unit in Positions is of type commonsubjects)
    common_subjects_ids=Programme.find(@weeklytimetable.programme_id).descendants.where(course_type: "Commonsubject").pluck(:id)
    @comms_topic=[]
    common_subjects_ids.each{|x|@comms_topic += Programme.find(x).descendant_ids}
    prog_topics_ifcommon_exist= Programme.find(@weeklytimetable.programme_id).descendants.where('ancestry_depth=? OR ancestry_depth=?',3,4).where('id not in(?)', @comms_topic).sort_by(&:combo_code)
    full_topics=Programme.find(@weeklytimetable.programme_id).descendants.where('ancestry_depth=? OR ancestry_depth=?',3,4).sort_by(&:combo_code)
    if dip_programmes.include?(prog_name) && (@is_coordinator || @is_admin || roles.include?("programme_manager")) 
      lecturer_ids= Staff.joins(:positions).where('unit=?', prog_name).pluck(:id)
      if @comms_topic==[]
        @semester_subject_topic_list=full_topics
      else
        @semester_subject_topic_list=prog_topics_ifcommon_exist
      end
    elsif posbasics.include?(prog_type) && (@is_coordinator || @is_admin || roles.include?("programme_manager"))
      if roles.include?("programme_manager")
        lecturer_ids=Staff.joins(:positions).where('(unit=? or unit=? or unit=?)', "Diploma Lanjutan","Pos Basik", "Pengkhususan").pluck(:id)
      else
        lecturer_ids=Staff.joins(:positions).where('(unit=? or unit=? or unit=?) and tasks_main ILIKE(?)', "Diploma Lanjutan","Pos Basik", "Pengkhususan", "%#{prog_name}%").pluck(:id)
      end
      if @comms_topic==[]
        @semester_subject_topic_list=full_topics
      else
        @semester_subject_topic_list=prog_topics_ifcommon_exist
      end
    elsif common_subjects.include?(lecturer_programme)
      lecturer_ids=Staff.joins(:positions).where('unit IN(?) and unit=?', common_subjects, lecturer_programme).pluck(:id)
      @semester_subject_topic_list = Programme.find(@weeklytimetable.programme_id).descendants.where('ancestry_depth=? OR ancestry_depth=?',3,4).where(id: @comms_topic).sort_by(&:combo_code)
    end
    if @is_admin
      lecturer_ids+=Staff.joins(:positions).where('unit IN(?)', common_subjects).pluck(:id)
      @semester_subject_topic_list = full_topics
    end
    @lecturer_list=Staff.where('id IN(?)', lecturer_ids).order(name: :asc)
    #end-lecture list   
  end

  # POST /weeklytimetables
  # POST /weeklytimetables.xml
  def create
    @weeklytimetable = Weeklytimetable.new(weeklytimetable_params)
    #from NEW###
    #Admin & Coordinator ONLY - diploma & pos basik/pengkhususan/dip lanjutan (common subjects lecturer has no access)
    @staffid = current_user.userable_id 
    roles = current_user.roles.pluck(:authname)
    @is_admin = roles.include?("administration") 
    if @is_admin
      @programme_list=Programme.roots
      @intake_list=Intake.all.order(programme_id: :asc, monthyear_intake: :desc)
      posbasics=["Diploma Lanjutan", "Pos Basik", "Pengkhususan"]
      prog_names=@programme_list.where(course_type: "Diploma").pluck(:name)
      @lecturer_list= Staff.joins(:positions).where('positions.unit IN(?) or positions.unit IN(?)', prog_names, posbasics).order(name: :asc)
    else
      #retrieve programme & groups coordinated from Intake
      @programme_id=Intake.where(staff_id: @staffid).first.programme_id
      @programme_list=Programme.roots.where(id: @programme_id)
      group_intake_ids=Intake.where(programme_id: @programme_id, staff_id: @staffid).pluck(:id).compact
      @intake_list=Intake.where(id: group_intake_ids)
      @lecturer_list=Staff.where(id: @staffid)
    end
    ###
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
    @weeklytimetable = Weeklytimetable.find(params[:id])
    roles = current_user.roles.pluck(:authname)
    @is_admin = roles.include?("administration")
    @staffid = current_user.userable_id
    lecturer_programme = current_user.userable.positions[0].unit
    @is_coordinator= Intake.where(programme_id: @weeklytimetable.programme_id, staff_id: current_user.userable_id).count > 0
    @is_creator=@weeklytimetable.prepared_by==@staffid
    @is_common_leader=["Sains Perubatan Asas", "Anatomi & Fisiologi", "Sains Tingkahlaku", "Komunikasi & Sains Pengurusan", "Komuniti"].include?(lecturer_programme) && roles.include?("unit_leader")
    #start-copy from edit
    @count1=@weeklytimetable.timetable_monthurs.timetable_periods.count
    @count2=@weeklytimetable.timetable_friday.timetable_periods.count 
    @break_format1 = @weeklytimetable.timetable_monthurs.timetable_periods.order(sequence: :asc).pluck(:is_break)
    @break_format2 = @weeklytimetable.timetable_friday.timetable_periods.order(sequence: :asc).pluck(:is_break)
    @weeklytimetable = Weeklytimetable.find(params[:id])
    #start-remove from partial : tab_daily_details_edit
    #start-remove from partial : subtab_class_details_edit
    @semester_subject_topic_list = Programme.find(@weeklytimetable.programme_id).descendants.where('ancestry_depth=? OR ancestry_depth=?',3,4).sort_by(&:combo_code)		
    @timeslot = @weeklytimetable.timetable_monthurs.timetable_periods.where('is_break is false')
    @timeslot2 = @weeklytimetable.timetable_friday.timetable_periods.where('is_break is false')
    #start-copy from edit
    #start-lecturer list - edit of programme no longer available, diploma & posbasic lecturer list already fixed
    dip_programmes=Programme.roots.where(course_type: "Diploma").pluck(:name)
    lecturer_programme = current_user.userable.positions[0].unit    #note - dip & posbasic (programme name), commonsubjects (subject name)
    programme=Programme.find(@weeklytimetable.programme_id)
    prog_name=programme.name
    prog_type=programme.course_type
    posbasics= ["Diploma Lanjutan", "Pos Basik", "Pengkhususan"]
    common_subjects = ["Sains Perubatan Asas", "Anatomi & Fisiologi", "Sains Tingkahlaku", "Komunikasi & Sains Pengurusan", "Komuniti"]
    
    ##diploma & posbasic - based on saved WT(coordinators/admin), commonsubjects - based on logged-in user(unit in Positions is of type commonsubjects)
    common_subjects_ids=Programme.find(@weeklytimetable.programme_id).descendants.where(course_type: "Commonsubject").pluck(:id)
    @comms_topic=[]
    common_subjects_ids.each{|x|@comms_topic += Programme.find(x).descendant_ids}
    prog_topics_ifcommon_exist= Programme.find(@weeklytimetable.programme_id).descendants.where('ancestry_depth=? OR ancestry_depth=?',3,4).where('id not in(?)', @comms_topic).sort_by(&:combo_code)
    full_topics=Programme.find(@weeklytimetable.programme_id).descendants.where('ancestry_depth=? OR ancestry_depth=?',3,4).sort_by(&:combo_code)
    if dip_programmes.include?(prog_name) && (@is_coordinator || @is_admin || roles.include?("programme_manager")) 
      lecturer_ids= Staff.joins(:positions).where('unit=?', prog_name).pluck(:id)
      if @comms_topic==[]
        @semester_subject_topic_list=full_topics
      else
        @semester_subject_topic_list=prog_topics_ifcommon_exist
      end
    elsif posbasics.include?(prog_type) && (@is_coordinator || @is_admin || roles.include?("programme_manager"))
      if roles.include?("programme_manager")
        lecturer_ids=Staff.joins(:positions).where('(unit=? or unit=? or unit=?)', "Diploma Lanjutan","Pos Basik", "Pengkhususan").pluck(:id)
      else
        lecturer_ids=Staff.joins(:positions).where('(unit=? or unit=? or unit=?) and tasks_main ILIKE(?)', "Diploma Lanjutan","Pos Basik", "Pengkhususan", "%#{prog_name}%").pluck(:id)
      end 
      if @comms_topic==[]
        @semester_subject_topic_list=full_topics
      else
        @semester_subject_topic_list=prog_topics_ifcommon_exist
      end
    elsif common_subjects.include?(lecturer_programme)
      lecturer_ids=Staff.joins(:positions).where('unit IN(?) and unit=?', common_subjects, lecturer_programme).pluck(:id)
      @semester_subject_topic_list = Programme.find(@weeklytimetable.programme_id).descendants.where('ancestry_depth=? OR ancestry_depth=?',3,4).where(id: @comms_topic).sort_by(&:combo_code)
    end
    if @is_admin
      lecturer_ids+=Staff.joins(:positions).where('unit IN(?)', common_subjects).pluck(:id)
    end
    @lecturer_list=Staff.where('id IN(?)', lecturer_ids).order(name: :asc)
    #end-lecture list   
    
    respond_to do |format|
      if @weeklytimetable.update(weeklytimetable_params)
        format.html { redirect_to(training_weeklytimetable_path(@weeklytimetable), :notice => (t 'training.weeklytimetable.title')+(t 'actions.updated')) }
        format.xml  { head :ok }
      else
        if @weeklytimetable.hod_rejected==true || @weeklytimetable.hod_approved==true
          format.html {render :action => "approval"}
        else
          format.html { render :action => "edit" }
        end
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
      format.html { redirect_to(training_weeklytimetables_url) }
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
    @selected_date = params[:id]
    @weeklytimetables_details=WeeklytimetableDetail.where('lecturer_id=?', current_user.userable_id)
    @all_combine = []
    @weeklytimetables_details.each do |x|
        @all_combine << Weeklytimetable.find(x.weeklytimetable.id)
    end 
    @personalize = @all_combine.group_by{|t|t.startdate}
    respond_to do |format|
      format.pdf do
        pdf = PersonalizetimetablePdf.new(@personalize, view_context, current_user, @selected_date)
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
  
  def approval
    @weeklytimetable = Weeklytimetable.find(params[:id])
    @count1=@weeklytimetable.timetable_monthurs.timetable_periods.count
    @count2=@weeklytimetable.timetable_friday.timetable_periods.count 
#     @staffid=current_user.userable_id
#     roles=current_user.roles.pluck(:authname)
#     lecturer_programme = current_user.userable.positions[0].unit
#     @is_admin=roles.include?("administration")
#     @is_coordinator=@weeklytimetable.prepared_by==@staffid
#     @is_common_leader=["Sains Perubatan Asas", "Anatomi & Fisiologi", "Sains Tingkahlaku", "Komunikasi & Sains Pengurusan", "Komuniti"].include?(lecturer_programme) && roles.include?("unit_leader")
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
