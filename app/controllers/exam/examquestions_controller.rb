class Exam::ExamquestionsController < ApplicationController
  #filter_resource_access
    filter_access_to :all
  before_action :set_examquestion, only: [:show, :edit, :update, :destroy]
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

    @position_exist = current_user.userable.positions
    if @position_exist && @position_exist.count > 0
      @lecturer_programme = current_user.userable.positions[0].unit
      unless @lecturer_programme.nil?
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0)
      end
      unless @programme.nil? || @programme.count==0
        @programme_id = @programme.try(:first).try(:id)
      else
        common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
        if common_subjects.include?(@lecturer_programme) 
          @programme_id="2" #common subject lecturers
        else
          if current_user.roles.pluck(:authname).include?("administration")
            @programme_id=0  #admin 
          else
            if @lecturer_programme=="Pengkhususan" && current_user.roles.pluck(:authname).include?("programme_manager")
              @programme_id="1" #KP Pengkhususan
            else
              posbasiks_name = Programme.roots.where(course_type: ["Diploma Lanjutan", "Pos Basik", "Pengkhususan"]).pluck(:name)
              posbasiks_name.each do |pname|
                @programme_id = Programme.where(name: pname).first.id if @position_exist.first.tasks_main.include?(pname)
              end  
            end
          end
        end
      end
      
      @search = Examquestion.search(params[:q])
      @examquestions = @search.result.search2(@programme_id).sort_by(&:programme_id)
      @examquestions = Kaminari.paginate_array(@examquestions).page(params[:page]||1)
      @programme_exams = @examquestions.group_by(&:programme_id)
    end 

    respond_to do |format|
      if @examquestions && @programme_exams
        format.html # index.html.erb
        format.xml  { render :xml => @examquestions }
        format.csv { send_data @examquestions.to_csv }
        format.xls { send_data @examquestions.to_csv(col_sep: "\t") }
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
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_examquestion
      @examquestion = Examquestion.find(params[:id])
    end
    
    def set_new_create_data
      @position_exist = current_user.userable.positions
      @lecturer_programme = current_user.userable.positions[0].unit
      @creator = current_user.userable_id
      unless @lecturer_programme.nil?
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0)
      end
      unless @programme.nil? || @programme.count==0
        @preselect_prog = @programme.first.id
        @programme_list=Programme.where(id: @preselect_prog)
        @subjects=Programme.subject_groupbyoneprogramme2(@preselect_prog)
      else
        common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
        if common_subjects.include?(@lecturer_programme) 
          @programme_list=Programme.roots
          @subjects=Programme.subject_groupbycommonsubjects2
        elsif current_user.roles.pluck(:authname).include?("administration")
          @programme_list=Programme.roots
          @subjects=Programme.subject_groupbyprogramme
        else
          posbasiks = Programme.roots.where(course_type: ["Diploma Lanjutan", "Pos Basik", "Pengkhususan"])
          if @lecturer_programme=="Pengkhususan" && current_user.roles.pluck(:authname).include?("programme_manager")
            @programme_list=Programme.where(id: posbasiks.pluck(:id))
            @subjects=Programme.subject_groupbyposbasiks2
          else
            posbasiks.pluck(:name).each do |pname|
              @preselect_prog = Programme.where(name: pname).first.id if @position_exist.first.tasks_main.include?(pname)
            end  
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
      if current_user.roles.pluck(:authname).include?("administration")
        @programme_list=Programme.roots
        @subjects=Programme.subject_groupbyprogramme
      elsif current_user.roles.pluck(:authname).include?("programme_manager") && @lecturer_programme=="Pengkhususan" 
        posbasiks = Programme.roots.where(course_type: ["Diploma Lanjutan", "Pos Basik", "Pengkhususan"])
        @programme_list=Programme.where(id: posbasiks.pluck(:id))
        @subjects=Programme.subject_groupbyposbasiks2
      else
        @preselect_prog = @examquestion.programme_id
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
