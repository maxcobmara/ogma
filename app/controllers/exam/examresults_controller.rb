class Exam::ExamresultsController < ApplicationController
  #filter_access_to :all
  #filter_resource_access
  filter_access_to :index, :index2, :new, :create, :show2, :examination_slip, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  
  before_action :set_examresult, only: [:show, :edit, :update, :destroy]
  before_action :set_index_index2_data, only: [:index, :index2]
  before_action :set_new_create_data, only: [:new, :create]
  before_action :set_edit_update_data, only: [:edit, :update] 
  
  # GET /examresults
  # GET /examresults.xml
  def index
    respond_to do |format|
      if @examresults
        format.html # index.html.erb
        format.xml  { render :xml => @examresults }
      else
        format.html { redirect_to(dashboard_url, :notice =>t('positions_required')+(t 'exam.title')+" - "+(t 'exam.examresult.title'))}
        format.xml  { render :xml => @examresults.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def index2
    respond_to do |format|
      if @resultlines
        format.html # index.html.erb
        format.xml  { render :xml => @resultlines }
      else
         format.html { redirect_to(dashboard_url, :notice =>t('positions_required')+t('menu.exam_slip'))}#+ ' Accessible to Programme / Pos basic lecturers only') }
         format.xml  { render :xml => @resultlines.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /examresults/1
  # GET /examresults/1.xml
  def show
    @examresult = Examresult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @examresult }
    end
  end
  
   def show2
     @resultline = Resultline.find(params[:id])
     @common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
     respond_to do |format|
       format.html # show.html.erb
       format.xml  { render :xml => @examresult }
     end
   end

  def examination_slip
    @resultline = Resultline.find(params[:id])
    respond_to do |format|
       format.pdf do
         pdf = Examination_slipPdf.new(@resultline, view_context)
         send_data pdf.render, filename: "examination_slip-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end

  # GET /examresults/new
  # GET /examresults/new.xml
  def new
    @examresult = Examresult.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @examresult }
    end
  end

  # GET /examresults/1/edit
  def edit
    @examresult = Examresult.find(params[:id])
  end

  # POST /examresults
  # POST /examresults.xml
  def create
    @examresult = Examresult.new(params[:examresult])
    programmeid=params[:examresult][:programme_id]
    sem=params[:examresult][:semester]
    exammonth=(params[:examresult][:examdts]).to_date.month if !(params[:examresult][:examdts]).to_date.nil?
    examyear=(params[:examresult][:examdts]).to_date.year if !(params[:examresult][:examdts]).to_date.nil?
    unless programmeid.blank? || programmeid.nil?
      unless sem.blank? || sem.nil?
        unless examyear.blank? || examyear.nil? || exammonth.blank? || exammonth.nil?
          @intake = Examresult.set_intake_group(examyear, exammonth, sem, @current_user.userable.positions)
          @subjects = Examresult.get_subjects(programmeid, sem)
          @students = Examresult.get_students(programmeid, examyear, exammonth, sem, @current_user.userable.positions)
        end
      end
    end
    respond_to do |format|
      if @students && @students.count > 0
        if @examresult.save
          flash[:notice]=t('exam.examresult.title2')+" "+t('actions.created')+" "+t('exam.examresult.update_resultlines')
          format.html {render :action => "edit"}
          format.xml  { head :ok }
          flash.discard
           #format.html { redirect_to(exam_examresult_path(@examresult), :notice => t('exam.examresult.title2')+" "+t('created')) }
            #format.xml  { render :xml => @examresult, :status => :created, :location => @examresult }
        else
          flash[:notice]='Error arise!'
          redirect_to  exam_examresults_path
        end
      else
        if @students && @students.count==0
          flash[:notice]=t('exam.examresult.no_student')
          format.html { render :action => "new" }
          format.xml  { render :xml => @examresult.errors, :status => :unprocessable_entity }
          flash.discard
        else
          flash[:notice]=t('exam.examresult.all_compulsory')
          format.html { render :action => "new" }
          format.xml  { render :xml => @examresult.errors, :status => :unprocessable_entity }
          flash.discard
        end
      end
    end
    
  end

  # PUT /examresults/1
  # PUT /examresults/1.xml
  def update
    @examresult = Examresult.find(params[:id])  
    respond_to do |format|
      if @examresult.update_attributes(examresult_params)
        format.html { redirect_to(exam_examresult_path(@examresult), :notice => t('exam.examresult.title2')+" "+t('actions.updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @examresult.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /examresults/1
  # DELETE /examresults/1.xml
  def destroy
    @examresult = Examresult.find(params[:id])
    @examresult.destroy

    respond_to do |format|
      format.html { redirect_to(exam_examresults_url) }
      format.xml  { head :ok }
    end
  end
  
  private 
  
  # Use callbacks to share common setup or constraints between actions.
    def set_examresult
      @examresult = Examresult.find(params[:id])
    end
    
    def set_index_index2_data
      position_exist = @current_user.userable.positions
      posbasiks=["Pos Basik", "Diploma Lanjutan", "Pengkhususan"]
      @common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
      if position_exist && position_exist.count > 0
        lecturer_programme = @current_user.userable.positions[0].unit
        unless lecturer_programme.nil?
          programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{lecturer_programme}%",0)  if posbasiks.include?(lecturer_programme)==false
        end
        unless programme.nil? || programme.count==0
          programme_id = programme.try(:first).try(:id)
        else
          tasks_main = @current_user.userable.positions[0].tasks_main
          if @common_subjects.include?(lecturer_programme) 
            programme_id ='1'
          elsif posbasiks.include?(lecturer_programme) && tasks_main!=nil
            allposbasic_prog = Programme.where(course_type: posbasiks).pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
            for basicprog in allposbasic_prog
              lecturer_basicprog_name = basicprog if tasks_main.include?(basicprog)==true
            end
            programme_id=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
          else
            programme_id='0'# if @current_user.roles.pluck(:authname).include?("administration")
          end
        end
        #INDEX use
        @search = Examresult.search(params[:q])
        @examresults = @search.result.search2(programme_id)
        @examresults = @examresults.page(params[:page]||1)
        #INDEX2 use
        @search2 = Resultline.search(params[:q])
        @resultlines = @search2.result.search2(programme_id)
        @resultlines = @resultlines.page(params[:page]||1)
	@progid=programme_id
      end
    end
    
    def set_new_create_data
      position_exist = @current_user.userable.positions
      posbasiks=["Pos Basik", "Diploma Lanjutan", "Pengkhususan"]
      common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
      if position_exist && position_exist.count > 0
        lecturer_programme = @current_user.userable.positions[0].unit
        unless lecturer_programme.nil?
          programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{lecturer_programme}%",0)  if posbasiks.include?(lecturer_programme)==false
        end
        unless programme.nil? || programme.count==0
          @programme_id = programme.try(:first).try(:id)
          @programmes=Programme.where(id: @programme_id)
        else
          tasks_main = @current_user.userable.positions[0].tasks_main
          if common_subjects.include?(@lecturer_programme) 
            #programme_id ='1'
          elsif posbasiks.include?(lecturer_programme) && tasks_main!=nil
            allposbasic_prog = Programme.where(course_type: posbasiks).pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
            for basicprog in allposbasic_prog
              lecturer_basicprog_name = basicprog if tasks_main.include?(basicprog)==true
            end
            @programme_id=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
            @programmes=Programme.where(id: programme_id)
          else
            @programme_id='0'
            @programmes=Programme.roots.where(course_type: ['Diploma', 'Diploma Lanjutan', 'Pos Basik', 'Pengkhususan'])
          end
        end
      end
    end
    
    def set_edit_update_data
      programmeid=@examresult.programme_id
      sem=@examresult.semester
      exammonth=@examresult.examdts.month
      examyear=@examresult.examdts.year
      unless programmeid.blank? || programmeid.nil?
        unless sem.blank? || sem.nil?
          unless examyear.blank? || examyear.nil? || exammonth.blank? || exammonth.nil?
            @intake = Examresult.set_intake_group(examyear, exammonth, sem, @current_user.userable.positions)
            @subjects = Examresult.get_subjects(programmeid, sem)
            @students = Examresult.get_students(programmeid, examyear, exammonth, sem, @current_user.userable.positions)
          end
        end
      end
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def examresult_params
      params.require(:examresult).permit(:programme_id, :total, :pngs17, :status, :remark, :semester, :examdts, :examdte, resultlines_attributes: [:id, :_destroy, :total, :pngs17, :status, :remark, :student_id, :pngk, :remark])
    end
  
end