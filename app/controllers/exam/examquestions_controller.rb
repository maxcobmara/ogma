class Exam::ExamquestionsController < ApplicationController
  filter_access_to :index, :new, :create, :examquestion_report, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  
  before_action :set_examquestion, only: [:show, :edit, :update, :destroy]
  before_action :set_index_data, only: [:index, :examquestion_report] 
  before_action :set_new_create_data, only: [:new, :create]
  before_action :set_edit_update_data, only: [:edit, :update]

  # GET /examquestions
  # GET /examquestions.xml
  def index
    #-----in case-use these 4 lines-------
    #@programmes = Programme.roots
    #@examquestions = Examquestion.search2(params[:programmid])    #all if not specified
    #@subject_exams = @examquestions.group_by { |t| t.subject_details }
    #@topic_exams = @examquestions.group_by { |t| t.topic_id }
    #-----in case-use these 4 lines-------

    respond_to do |format|
      if @examquestions && @programme_exams
        format.html # index.html.erb
        format.xml  { render :xml => @examquestions }
        format.csv { send_data @examquestions_all.to_csv }
        format.xls { send_data @examquestions_all.to_csv(col_sep: "\t") }
      else
        format.html { redirect_to(dashboard_url, :notice =>t('positions_required')+(t 'exam.title')+" - "+(t 'exam.examquestion.title')) }
      end
    end
  end

  # GET /examquestions/1
  # GET /examquestions/1.xml
  def show
    @examquestion = Examquestion.find(params[:id])
    @q_frequency=Examquestion.joins(:exams).where('examquestion_id=?',(params[:id]))
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @examquestion }
    end
  end

  # GET /examquestions/new
  # GET /examquestions/new.xml
  def new
    @examquestion = Examquestion.new
    3.times { @examquestion.shortessays.build }
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @examquestion }
    end
  end
  
  # GET /examquestions/1/edit
  def edit
  end

  # POST /examquestions
  # POST /examquestions.xml
  def create
    #raise params.inspect
    @examquestion= Examquestion.new(examquestion_params)
    respond_to do |format|
      if @examquestion.save
        flash[:notice] = (t 'exam.examquestion.title')+(t 'actions.created')
        format.html { redirect_to(exam_examquestion_path(@examquestion))}
        format.xml  { render :xml => @examquestion, :status => :created, :location => @examquestion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @examquestion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /examquestions/1
  # PUT /examquestions/1.xml
  def update
    respond_to do |format|
      if @examquestion.update(examquestion_params)
        flash[:notice] = (t 'exam.examquestion.title')+(t 'actions.updated')
        format.html { redirect_to(exam_examquestion_path(@examquestion)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @examquestion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /examquestions/1
  # DELETE /examquestions/1.xml
  def destroy
    @examquestion = Examquestion.find(params[:id])
    #22Apr2013--avoid deletion of examquestion that exist in exams-temp
    @exist_in_exam =  Exam.joins(:examquestions).where('examquestion_id=?',1).count
    if @exist_in_exam == 0
        @examquestion.destroy
    else
        flash[:error] = t('exam.examquestion.exist_in_exampaper')
    end
    #22Apr2013--avoid deletion of examquestion that exist in exams
    
    respond_to do |format|
      format.html { redirect_to(exam_examquestions_url) }
      format.xml  { head :ok }
    end
  end
  
  def examquestion_report
#     @search = Examquestion.search(params[:q])
#     @examquestions = @search.result
    ####
    if @examquestions && @programme_exams
#         format.html # index.html.erb
#         format.xml  { render :xml => @examquestions }
#         format.csv { send_data @examquestions.to_csv }
#         format.xls { send_data @examquestions.to_csv(col_sep: "\t") }
      respond_to do |format|
        format.pdf do
          pdf = Examquestion_reportPdf.new(@examquestions, @programme_exams, view_context, current_user.college)
          send_data pdf.render, filename: "examquestion_report-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
        end
      end
    else
      format.html { redirect_to(dashboard_url, :notice =>t('positions_required')+(t 'exam.title')+" - "+(t 'exam.examquestion.title')) }
    end
    ####
#     respond_to do |format|
#       format.pdf do
#         pdf = Examquestion_reportPdf.new(@examquestions, view_context, current_user.college)
#         send_data pdf.render, filename: "examquestion_report-{Date.today}",
#                                type: "application/pdf",
#                                disposition: "inline"
#       end
#     end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_examquestion
      @examquestion = Examquestion.find(params[:id])
    end
    
    def set_index_data
      ##----------
      @position_exist = @current_user.userable.positions
      current_roles=current_user.roles.pluck(:authname)
      posbasiks=['Diploma Lanjutan', 'Pos Basik', 'Pengkhususan']
      if @position_exist && @position_exist.count > 0
	@lecturer_programme = @current_user.userable.positions[0].unit
	unless @lecturer_programme.nil?
	  @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0) if posbasiks.include?(@lecturer_programme)==false
	end
	unless @programme.nil? || @programme.count==0
	  @programme_id = @programme.try(:first).try(:id)
	else
	  @tasks_main = @current_user.userable.positions[0].tasks_main
	  common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
	  if common_subjects.include?(@lecturer_programme) 
	    @programme_id ='1'
	  elsif posbasiks.include?(@lecturer_programme) && @tasks_main!=nil
	    @allposbasic_prog = Programme.where(course_type: posbasiks).pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
	    for basicprog in @allposbasic_prog
	      lecturer_basicprog_name = basicprog if @tasks_main.include?(basicprog)==true
	    end
	    if @lecturer_programme=="Pengkhususan" && current_roles.include?("programme_manager")
	      @programme_id='2'
	    else
	      @programme_id=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
	    end
	  elsif current_roles.include?("developer") || current_roles.include?("administration") || current_roles.include?("examquestions_module")
	    @programme_id='0'
	  else
	    leader_unit=@tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if @tasks_main!="" && @tasks_main.include?('Program')
	    if leader_unit
	      @programme_id = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0).first.id
	    end
	  end
	end
	if @programme_id
	@search = Examquestion.search(params[:q])
	@examquestions_all = @search.result.search2(@programme_id)
	@examquestions = @examquestions_all.page(params[:page]||1)
	@programme_exams = @examquestions.group_by{|x|x.subject.root_id}
	end
      end
      ##----------
    end
    
    def set_new_create_data
      @position_exist = current_user.userable.positions
      @lecturer_programme = current_user.userable.positions[0].unit
      @creator = current_user.userable_id
      posbasiks=["Diploma Lanjutan", "Pos Basik", "Pengkhususan"]
      unless @lecturer_programme.nil?
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0)
      end
      unless @programme.nil? || @programme.count==0
        @preselect_prog = @programme.first.id
        @programme_list=Programme.where(id: @preselect_prog)
        @subjects=Programme.subject_groupbyoneprogramme2(@preselect_prog)
      else
        common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
        current_roles=current_user.roles.pluck(:authname)
        if common_subjects.include?(@lecturer_programme) 
          @programme_list=Programme.roots
          @subjects=Programme.subject_groupbycommonsubjects2
        elsif posbasiks.include?(@lecturer_programme)
          @allposbasic_prog = Programme.roots.where(course_type: posbasiks)
          if @lecturer_programme=="Pengkhususan" && current_user.roles.pluck(:authname).include?("programme_manager")
            @programme_list=Programme.where(id: @allposbasic_prog.pluck(:id))
            @subjects=Programme.subject_groupbyposbasiks2
          else
            @allposbasic_prog.pluck(:name).each do |pname|
               @preselect_prog = Programme.where(name: pname).first.id if @position_exist.first.tasks_main.include?(pname)
            end  
            @programme_list=Programme.where(id: @preselect_prog)
            @subjects=Programme.subject_groupbyoneprogramme2(@preselect_prog)
          end
        elsif current_roles.include?("developer") || current_roles.include?("administration") || current_roles.include?("examquestions_module")
           @programme_list=Programme.roots
           if current_user.college.code=="kskbjb"
             @subjects=Programme.subject_groupbyprogramme
           elsif current_user.college.code=="amsas"
             @subjects=Programme.subject_groupbyprogramme_amsas
           end
        else
          tasks_main=@current_user.userable.positions.first.tasks_main
          leader_unit=tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if tasks_main!="" && tasks_main.include?('Program')
          if leader_unit       
            @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0).first
            @preselect_prog=@programme.id
            @programme_list=Programme.where(id: @preselect_prog)
            @subjects=Programme.subject_groupbyoneprogramme2(@preselect_prog)
          end
        end
      end
    end
    
    def set_edit_update_data
      @examquestion = Examquestion.find(params[:id])
      @creator = @examquestion.creator_id
      @lecturer_programme = current_user.userable.positions[0].unit
      current_roles=current_user.roles.pluck(:authname)
      if current_roles.include?("developer") || current_roles.include?("administration") || current_roles.include?("examquestions_module")
        @programme_list=Programme.roots
        if current_user.college.code=="kskbjb"
          @subjects=Programme.subject_groupbyprogramme
	elsif current_user.college.code="amsas"
          @subjects=Programme.subject_groupbyprogramme2
        end
      elsif current_roles.include?("programme_manager") && @lecturer_programme=="Pengkhususan" 
        posbasiks = Programme.roots.where(course_type: ["Diploma Lanjutan", "Pos Basik", "Pengkhususan"])
        @programme_list=Programme.where(id: posbasiks.pluck(:id))
        @subjects=Programme.subject_groupbyposbasiks2
      else
        @preselect_prog = @examquestion.subject.root_id
        @programme_list=Programme.where(id: @preselect_prog)
        common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
        if common_subjects.include?(@lecturer_programme) 
          @subjects=Programme.subject_groupbycommonsubjects2
        else
          @subjects=Programme.subject_groupbyoneprogramme2(@preselect_prog)
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def examquestion_params
      params.require(:examquestion).permit(:activate,:answermcq, :subject_id, :questiontype, :question, :answer, :marks, :category, :qkeyword, :qstatus, :creator_id, :createdt, :difficulty, :statusremark, :editor_id, :editdt, :approver_id, :approvedt, :bplreserve, :bplsent, :bplsentdt, :diagram, :diagram_file_name, :diagram_content_type, :diagram_file_size, :diagram_updated_at, :diagram_caption, :topic_id , :construct, :conform_curriculum, :conform_specification, :conform_opportunity, :accuracy_construct, :accuracy_topic, :accuracy_component, :fit_difficulty, :fit_important, :fit_fairness, :programme_id, answerchoices_attributes: [:id,:examquestion_id, :item, :description], examanswers_attributes: [:id,:examquestion_id,:item,:answer_desc], shortessays_attributes: [:id,:item,:subquestion,:submark,:subanswer, :examquestion_id, :keyword], booleanchoices_attributes: [:id, :examquestion_id,:item,:description], booleananswers_attributes: [:id,:examquestion_id, :item, :answer])
    end
end
