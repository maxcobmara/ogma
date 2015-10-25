class Exam::ExamresultsController < ApplicationController
  # GET /examresults
  # GET /examresults.xml
  def index
    position_exist = @current_user.userable.positions
    posbasiks=["Pos Basik", "Diploma Lanjutan", "Pengkhususan"]
    if position_exist && position_exist.count > 0
      lecturer_programme = @current_user.userable.positions[0].unit
      unless lecturer_programme.nil?
        programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{lecturer_programme}%",0)  if posbasiks.include?(lecturer_programme)==false
      end
      unless programme.nil? || programme.count==0
        programme_id = programme.try(:first).try(:id)
      else
        tasks_main = @current_user.userable.positions[0].tasks_main
        common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
        if common_subjects.include?(@lecturer_programme) 
          #programme_id ='1'
        elsif posbasiks.include?(lecturer_programme) && tasks_main!=nil
          allposbasic_prog = Programme.where(course_type: posbasiks).pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
          for basicprog in allposbasic_prog
            lecturer_basicprog_name = basicprog if tasks_main.include?(basicprog)==true
          end
          programme_id=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
        else
          programme_id='0'
        end
      end
      
      @search = Examresult.search(params[:q])
      @examresults = @search.result.search2(programme_id)
      @examresults = @examresults.page(params[:page]||1)
    end
    
    respond_to do |format|
      if @examresults
        format.html # index.html.erb
        format.xml  { render :xml => @examresults }
      else
        format.html { redirect_to(dashboard_url, :notice =>t('positions_required')+(t 'exam.title')+" - "+(t 'exam.examresult.title')+ ' Accessible to Programme / Pos basic lecturers only') }
        format.xml  { render :xml => @examresults.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def index2
    @position_exist = @current_user.userable.positions
    if @position_exist     
      @examresults = Examresult.all
    end
    respond_to do |format|
      if @position_exist
        format.html # index.html.erb
        format.xml  { render :xml => @examresults }
      else
	 format.html {redirect_to "/home", :notice =>t('position_required')+t('menu.exam_slip')}
         format.xml  { render :xml => @examresult.errors, :status => :unprocessable_entity }
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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @examresult }
    end
  end
  
  def examslip
    @resultline = Resultline.find(params[:id])
    render :layout => 'report'
  end
  
  def show_stat
    @examresult = Examresult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @examresult }
    end
  end
  
  def show_summary
    @examresult = Examresult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @examresult }
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
  
  def new_analysis
    
  end

  # GET /examresults/1/edit
  def edit
    @examresult = Examresult.find(params[:id])
  end
  
  def edit_stat
    @examresult = Examresult.find(params[:id])
  end

  # POST /examresults
  # POST /examresults.xml
  def create
    @examresult = Examresult.new(params[:examresult])
    respond_to do |format|
      if @examresult.save
        format.html { redirect_to(@examresult, :notice => t('exam.examresult.title2')+" "+t('created')) }
        format.xml  { render :xml => @examresult, :status => :created, :location => @examresult }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @examresult.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /examresults/1
  # PUT /examresults/1.xml
  def update
    @examresult = Examresult.find(params[:id])  
    respond_to do |format|
      if @examresult.update_attributes(examresult_params)
        format.html { redirect_to(exam_examresult_path(@examresult), :notice => t('exam.examresult.title2')+" "+t('updated')) }
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
  
  # Use callbacks to share common setup or constraints between actions.
    def set_examresult
      @exammark = Exammark.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def examresult_params
      params.require(:examresult).permit(:programme_id, :total, :pngs17, :status, :remark, :semester, :examdts, :examdte, resultlines_attributes: [:id, :_destroy, :total, :pngs17, :status, :remark, :student_id, :pngk])
    end
  
end
