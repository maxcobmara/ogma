class Exam::ExamsController < ApplicationController
  filter_resource_access
  before_action :set_exam, only: [:show, :edit, :update, :destroy]
  before_action :set_edit_data, only: [:edit, :update, :create]

  # GET /exams
  # GET /exams.xml
  def index
    #@exams = Exam.all
    ##----------
    @position_exist = @current_user.userable.positions
    if @position_exist && @position_exist.count > 0
      @lecturer_programme = @current_user.userable.positions[0].unit
      unless @lecturer_programme.nil?
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0) if !(@lecturer_programme=="Pos Basik" || @lecturer_programme=="Diploma Lanjutan")
      end
      unless @programme.nil? || @programme.count==0
        @programme_id = @programme.try(:first).try(:id)
      else
        @tasks_main = @current_user.userable.positions[0].tasks_main
        common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
        if common_subjects.include?(@lecturer_programme) #@lecturer_programme =='Commonsubject'
          @programme_id ='1'
        elsif (@lecturer_programme == 'Pos Basik' || @lecturer_programme == 'Diploma Lanjutan') && @tasks_main!=nil
          @allposbasic_prog = Programme.where('course_type=? or course_type=?', "Pos Basik", "Diploma Lanjutan").pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
          for basicprog in @allposbasic_prog
            lecturer_basicprog_name = basicprog if @tasks_main.include?(basicprog)==true
          end
          @programme_id=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
        else
          @programme_id='0' if !@lecturer_programme.nil? && @current_user.userable.positions[0].name !='Pengajar'
        end
      end
      if @programme_id
        #@exams_all = Exam.search(@programme_id) 
        @search = Exam.search(params[:q])
        @exams = @search.result.search2(@programme_id)
        @exams = @exams.order(subject_id: :asc).page(params[:page]||1)
      end
    end
    ##----------
    #@search = Exam.search(params[:q])
    #@exams = @search.result       
    
    respond_to do |format|
      if @exams 
        format.html # index.html.erb
        format.xml  { render :xml => @exams }
      else
        format.html { redirect_to(dashboard_url, :notice =>t('positions_required')+(t 'exam.title')+" - "+(t 'exam.exams.title')) }
      end
    end
  end

  # GET /exams/1
  # GET /exams/1.xml
  def show
    @exam = Exam.find(params[:id])
    if @exam.subject_id!=nil && (@exam.subject.parent.code == '1' || @exam.subject.parent.code == '2')
      @year = "1 / " 
    elsif @exam.subject_id!=nil && (@exam.subject.parent.code == '3' || @exam.subject.parent.code == '4')
     @year = "2 / "
    elsif @exam.subject_id!=nil && (@exam.subject.parent.code == '5' || @exam.subject.parent.code == '6')
     @year = "3 / "
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @exam }
    end
  end

  # GET /exams/new
  # GET /exams/new.xml
  def new
    @exam = Exam.new
    @lecturer_programme = @current_user.userable.positions[0].unit      
    unless @lecturer_programme.nil?
      @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0).first
    end
    unless @programme.nil? #|| @programme.count==0
      @staff_listing=@current_user.userable_id
      @programme_listing = Programme.where('id=?',@programme.id).to_a
      @preselect_prog = @programme.id
      @all_subject_ids = Programme.find(@preselect_prog).descendants.at_depth(2).map(&:id)
      @subjectlist_preselect_prog = Programme.where('id IN(?) AND course_type=?',@all_subject_ids, 'Subject')  #'Subject' 
    else #Commonsubject LECTURER have no selected programme
      common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
      if common_subjects.include?(@lecturer_programme) 
        @subjectlist_preselect_prog = Programme.where('course_type=?','Commonsubject')
        @staff_listing=@current_user.userable_id
      else
        @subjectlist_preselect_prog = Programme.at_depth(2)
        @staff_listing=@exam.creator_list
      end
      @programme_listing = Programme.roots
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @exam }
    end
  end

  # GET /exams/1/edit
  def edit
    @exam = Exam.find(params[:id])
  end
  
  def question_selection
    @exam=Exam.where(id: params[:id]).first
    topicid=params[:topicid]
    @selected = Examquestion.where(topic_id: topicid)
    respond_to do |format|
      format.js
    end
  end

  # POST /exams
  # POST /exams.xml
  def create
    @exam = Exam.new(exam_params)
    @create_type = params[:submit_button]             
    @lecturer_programme = @current_user.userable.positions[0].unit      
    unless @lecturer_programme.nil?
      @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0).first
    end
    unless @programme.nil? #|| @programme.count==0
      @programme_listing = Programme.where('id=?',@programme.id).to_a
      @preselect_prog = @programme.id
      @all_subject_ids = Programme.find(@preselect_prog).descendants.at_depth(2).map(&:id)
      @subjectlist_preselect_prog = Programme.where('id IN(?) AND course_type=?',@all_subject_ids, 'Subject')  #'Subject' 
    else  #Commonsubject LECTURER have no selected programme
      common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
      if common_subjects.include?(@lecturer_programme) 
        @subjectlist_preselect_prog = Programme.where('course_type=?','Commonsubject')
      else
        @subjectlist_preselect_prog = Programme.at_depth(2)
      end
      @programme_listing = Programme.roots
    end
    if @create_type == t('exam.exams.create_exam')
        @exam.klass_id = 1  #added for use in E-Query & Report Manager (27Jul2013)
    elsif @create_type == t('exam.exams.create_template')
        @exam.klass_id = 0
    end   
    
    respond_to do |format|
      if @exam.save
        flash[:notice] = (t 'exam.exams.created_add_question_details')
        #format.html { redirect_to (exam_exam_path(@exam)) }
        #format.xml  { render :xml => @exam, :status => :created, :location => @exam }
        format.html {render :action => "edit"}
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @exam.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /exams/1
  # PUT /exams/1.xml
  def update
    params[:exam][:examquestion_ids] ||= []
    @exam = Exam.find(params[:id])
    if @exam.klass_id == 0
      #template
      respond_to do |format|
        if @exam.update_attributes(exam_params)
          format.html { redirect_to(exam_exam_path(@exam.id), :notice => (t 'exam.exams.title2')+(t 'actions.updated')) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @exam.errors, :status => :unprocessable_entity }
        end
      end
    else
      #complete exam paper
      respond_to do |format|
        if @exam.update_attributes(exam_params)
          if (params[:exam][:seq]!=nil && ((params[:exam][:seq]).count >=  (params[:exam][:examquestion_ids]).count)) || (params[:exam][:examquestion_ids]).count==0
            format.html { redirect_to(exam_exam_path(@exam.id), :notice => (t 'exam.exams.title')+(t 'actions.updated')) }
            format.xml  { head :ok }
            #Note: when saved question is removed(untick), seq.count > examquestions.count  --> ref: model (remove_unused_sequence) to remove extra seq in Exam table
          else
            #-------(1)for first time data entry--default to edit to set sequence------------------
            #-------(2)for additional data entry--default to edit to set sequence------------------
            #-------for both situation--sequence fields are not available during questions addition
            #-------sequence can only be set once after question is saved into exam----------------
            format.html {render :action => "edit"}
            if params[:exam][:seq]!=nil && ((params[:exam][:seq]).count >  (params[:exam][:examquestion_ids]).count) 
              flash[:notice]='klik update - item removed'
            else
              flash[:notice] = (t 'exam.exams.title')+(t 'actions.updated')+(t 'exam.exams.set_sequence')
            end
            #format.xml  { render :xml => @exam.errors, :status => :unprocessable_entity }
            format.xml  { head :ok }
            flash.discard
            #-------END FOR ABOVE CONDITIONS--------------------------------------------------------          
          end
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @exam.errors, :status => :unprocessable_entity }
        end
      end     #end for respond_to do |format|
    end   #end for if @exam.klass_id == 0
    
  end

  # DELETE /exams/1
  # DELETE /exams/1.xml
  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy

    respond_to do |format|
      format.html { redirect_to(exam_exams_url) }
      format.xml  { head :ok }
    end
  end
  
  def exampaper
    @exam = Exam.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Exam_paperPdf.new(@exam, view_context)
        send_data pdf.render, filename: "exampaper-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def view_subject_main
    @lecturer_programme = current_user.staff.position.unit 
    @programme_id = params[:programmeid]
    unless @programme_id.blank? 
      all_subject_ids = Programme.find(@programme_id).descendants.at_depth(2).map(&:id)
      if @lecturer_programme == 'Commonsubject'
        @subjects = Programme.where('id IN(?) AND course_type=?',all_subject_ids, @lecturer_programme)  
      else
        @subjects = Programme.where('id IN(?) AND course_type=?',all_subject_ids, 'Subject')  #'Subject' 
      end
      #@subjects = Programme.find(@programme_id).descendants.at_depth(2)
    end
    render :partial => 'view_subject_main', :layout => false
  end
  
  def view_subject
    @lecturer_programme = current_user.staff.position.unit 
    @programme_id = params[:programmeid]
    @exam_id = params[:examid]
    unless @programme_id.blank? 
      all_subject_ids = Programme.find(@programme_id).descendants.at_depth(2).map(&:id)
      if @lecturer_programme == 'Commonsubject'
        @subjects = Programme.where('id IN(?) AND course_type=?',all_subject_ids, @lecturer_programme)  
      else
        @subjects = Programme.where('id IN(?) AND course_type=?',all_subject_ids, 'Subject')  #'Subject' 
      end
      #@subjects = Programme.find(@programme_id).descendants.at_depth(2)
    end
    render :partial => 'view_subject', :layout => false
  end
  
  def view_topic
    @subject = params[:subject]
    @exam_id = params[:examid]
    if @subject!='0' #|| @subject!=0
      @topics = Programme.find(@subject).descendants.at_depth(3)
    end
    render :partial => 'view_topic', :layout => false
  end
  
  def view_questions
    @exam_id = params[:examid]
    @topic_id = params[:topicid]
    unless (@topic_id.blank? && @exam_id.blank?) || @topic_id ==""
      #@questions = Examquestion.find(:all, :conditions => ['subject_id=?',@subject_id])
      @questions = Examquestion.where('topic_id=? and bplreserve is not true and bplsent is not true', @topic_id)
      @questions_group = @questions.group_by{|x|x.questiontype}
      #@questions2 = Examquestion.find(:all, :conditions => ['subject_id!=?',@subject_id])
      @questions2 = Examquestion.where('topic_id!=? and bplreserve is not true and bplsent is not true',@topic_id)
      @questions_group2 = @questions2.group_by{|x|x.questiontype}
    end
    render :partial => 'view_questions', :layout => false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @examn = Exam.find(params[:id])
    end
    
    # Assign values associated to EDIT - edit(from show), edit(after create) & update
    def set_edit_data
      @programme_id = @exam.subject.root.id
      @lecturer_programme = @current_user.userable.positions[0].unit  
      #unless @programme_id.nil? #|| @programme.count==0
      if Programme.where(course_type: ['Diploma','Diploma Lanjutan', 'Pos Basik']).pluck(:name).include?(@lecturer_programme)
        @programme_names=Programme.where(id: @programme_id).map(&:programme_list)
        @subjects=Programme.subject_groupbyoneprogramme(@programme_id)
        @topics=Programme.topic_groupbysubject_oneprogramme(@programme_id)
      else  #Commonsubject LECTURER have no selected programme
        common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
        if common_subjects.include?(@lecturer_programme) 
          @topics=Programme.topic_groupbycommonsubjects
          @subjects=Programme.subject_groupbycommonsubjects
        else
          @topics=Programme.topic_groupbysubject
          @subjects=Programme.subject_groupbyprogramme2
        end
        @programme_names=Programme.programme_names
      end
      @items=Examquestion.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_params
      params.require(:exam).permit(:name, :description, :created_by, :course_id, :subject_id, :klass_id, :exam_on, :duration, :full_marks, :starttime, :endtime, :topic_id, :sequ, examtemplates_attributes: [:id, :_destroy, :questiontype, :quantity, :total_marks], :examquestion_ids => [], :seq => [])
    end
end
