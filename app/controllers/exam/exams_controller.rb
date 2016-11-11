class Exam::ExamsController < ApplicationController
  filter_access_to :index, :new, :create, :exampaper, :question_selection, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  before_action :set_exam, only: [:show, :edit, :update, :destroy]
  before_action :set_shareable_data, only: [:new, :edit, :update, :create]
  before_action :set_new_create_data, only: [:new, :create]

  # GET /exams
  # GET /exams.xml
  def index
    #@exams = Exam.all
    ##----------
    @position_exist = @current_user.userable.positions
    roles=@current_user.roles.pluck(:authname)
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
          # NOTE - common subject lecturer no longer hv access
          #@programme_id ='1'
        elsif posbasiks.include?(@lecturer_programme) && @tasks_main!=nil
          @allposbasic_prog = Programme.where(course_type: ['Pos Basik', 'Diploma Lanjutan', 'Pengkhususan']).pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
          #for basicprog in @allposbasic_prog
            #lecturer_basicprog_name = basicprog if @tasks_main.include?(basicprog)==true
          #end
          # NOTE - whoever (posbasic lecturer) becoming SUP, shall have access to all Posbasic programmes
	  # NOTE - posbasic (Ketua Pengkhususan) also no longer hv access
          #if @lecturer_programme=="Pengkhususan" && current_user.roles.pluck(:authname).include?("programme_manager")
          #  @programme_id='2'
          #else
            @programme_id='2'#Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
          #end
        elsif roles.include?("developer") || roles.include?("administration") || roles.include?("exampaper_module_admin")|| roles.include?("exampaper_module_viewer")||  roles.include?("exampaper_module_member")
          @programme_id='0'
        else
          leader_unit=@tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if @tasks_main!="" && @tasks_main.include?('Program')
          if leader_unit
            @programme_id = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0).first.id
          end
        end
      end
      if @programme_id
        @search = Exam.search(params[:q])
        @exams = @search.result.search2(@programme_id)
        @exams = @exams.page(params[:page]||1)
        @programme_exams = @exams.group_by{|x|x.subject.root}
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
    
    render "exam/exams/#{current_user.college.code}/show"

#     respond_to do |format|
#       format.html # show.html.erb
#       format.xml  { render :xml => @exam }
#     end
  end

  # GET /exams/new
  # GET /exams/new.xml
  def new
    @exam = Exam.new
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
    @exam = Exam.find(params[:id])
    params[:exam][:examquestion_ids] ||= [] 
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
        pdf = Exam_paperPdf.new(@exam, view_context, current_user.college)
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
      @exam = Exam.find(params[:id])
    end
    
    # Assign shared data among new, edit, create & update
    def set_shareable_data
      @items=Examquestion.all 
      @lecturer_programme = @current_user.userable.positions[0].unit  
      posbasiks=['Diploma Lanjutan', 'Pos Basik', 'Pengkhususan']
      roles=@current_user.roles.pluck(:authname)
      tasks_main=@current_user.userable.positions[0].tasks_main
      if @exam.nil?
        #applicable - new only
        unless @lecturer_programme.nil?
          @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0).first
        end
        unless @programme.nil?
          @programme_id=@programme.id
	  @programme_names=Programme.where(id: @programme_id).map(&:programme_list) ### --CREATE
	  @subjects=Programme.subject_groupbyoneprogramme2(@programme_id) ### --CREATE
	  @topics=Programme.topic_groupbysubject_oneprogramme(@programme_id) ### --CREATE
        else
          #posbasik part
          posbasiks_prog = Programme.roots.where(course_type: posbasiks)
          posbasiks_prog.pluck(:name).each do |pname|
            @programme_id = Programme.where('name ILIKE(?)', pname).first.id if @current_user.userable.positions.first.tasks_main.include?(pname)
          end  
	  @subjects=Programme.subject_groupbyposbasiks2
        end
      else
        #applicable - edit, update, create
        @programme_id = @exam.subject.root.id 
	@programme_names=Programme.where(id: @programme_id).map(&:programme_list) ### --UPDATE
	@subjects=Programme.subject_groupbyoneprogramme2(@programme_id) ### --UPDATE
	@topics=Programme.topic_groupbysubject_oneprogramme(@programme_id) ### --UPDATE
      end
      
      #if Programme.where(course_type: ['Diploma']).pluck(:name).include?(@lecturer_programme) || (posbasiks.include?(@lecturer_programme) && @current_user.roles.pluck(:authname).include?("programme_manager")==false)
      if Programme.where(course_type: ['Diploma']).pluck(:name).include?(@lecturer_programme) && @current_user.roles.pluck(:authname).include?("programme_manager")==false
          @programme_names=Programme.where(id: @programme_id).map(&:programme_list)
          @subjects=Programme.subject_groupbyoneprogramme2(@programme_id)
          @topics=Programme.topic_groupbysubject_oneprogramme(@programme_id)
      elsif posbasiks.include?(@lecturer_programme)
          @programme_names=Programme.where(course_type: posbasiks).map(&:programme_list)
          @subjects=Programme.subject_groupbyposbasiks2
          @topics=Programme.topic_groupbyposbasiks
      else  #Commonsubject LECTURER have no selected programme
          common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
          if common_subjects.include?(@lecturer_programme) 
            @topics=Programme.topic_groupbycommonsubjects
            @subjects=Programme.subject_groupbycommonsubjects
            @programme_names=Programme.programme_names
          else
            if roles.include?("developer") || roles.include?("administration") || roles.include?("exampaper_module")
              @programme_names=Programme.programme_names
              @topics=Programme.topic_groupbysubject2
              @subjects=Programme.subject_groupbyprogramme2
            else
              leader_unit=tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if tasks_main!="" && tasks_main.include?('Program')
              if leader_unit
                @programme_id = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0).first.id
                @programme_names=Programme.where(id: @programme_id).map(&:programme_list)
                @subjects=Programme.subject_groupbyoneprogramme2(@programme_id)
                @topics=Programme.topic_groupbysubject_oneprogramme(@programme_id)
              end
            end    
          end
      end
      
      #Repeat for Final only
      finals_of_repeat=Exam.where(name: "R").pluck(:description)
      finals=[]
      finals_of_repeat.each{|y|finals << y.to_i}
      completed_finals=[]
      Exam.all.each{|x|completed_finals << x.id if x.complete_paper==true}
      if @programme_id
        subject_ids=Programme.where(id: @programme_id).first.descendants.where(course_type: 'Subject').pluck(:id)
        @final_exams=Exam.where(subject_id: subject_ids).where(name: "F").where.not(id: finals).where(id: completed_finals)
      else
        @final_exams=Exam.where(name: "F").where.not(id: finals).where(id: completed_finals)
      end
                           
    end
    
    # Assign New & Create data only
    def set_new_create_data
      roles=@current_user.roles.pluck(:authname)
      unless @programme.nil? #|| @programme.count==0
        @staff_listing=@current_user.userable_id
        @programme_detail=@programme.programme_list
        @subjects_paper=Programme.subject_groupbyoneprogramme2(@programme_id)
      else #Commonsubject LECTURER have no selected programme
        common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
        posbasiks=['Diploma Lanjutan', 'Pos Basik', 'Pengkhususan']
        if common_subjects.include?(@lecturer_programme) 
          @staff_listing=@current_user.userable_id
          @subjects_paper=Programme.subject_groupbycommonsubjects2 #new only
        elsif posbasiks.include?(@lecturer_programme)
          @staff_listing=@current_user.userable_id
          # NOTE - no longer accessible by Ketua Program Pengkhususan
          #if @current_user.roles.pluck(:authname).include?("programme_manager")
          #  @subjects_paper=Programme.subject_groupbyposbasiks2 #new only
          #else#all posbasic lecturer EXCEPT Ketua Program Pengkhususan
          #  posbasiks_prog = Programme.roots.where(course_type: posbasiks)
          #  posbasiks_prog.pluck(:name).each do |pname|
          #    @programme2 = Programme.where('name ILIKE(?)', pname).first if @current_user.userable.positions.first.tasks_main.include?(pname)
          #  end  
	  #  #@programme_detail=@programme2.programme_list
          #  @subjects_paper=Programme.subject_groupbyoneprogramme2(@programme2.id) #new only
          @subjects_paper=Programme.subject_groupbyposbasiks2 #new only
          #end
        elsif roles.include?("developer") || roles.include?("administration") || roles.include?("exampaper_module")
          @staff_listing=@exam.creator_list unless @exam.nil?
          @subjects_paper=Programme.subject_groupbyprogramme2 #new only
        else
          tasks_main=@current_user.userable.positions.first.tasks_main
          leader_unit=tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if tasks_main!="" && tasks_main.include?('Program')
          if leader_unit
            @staff_listing=@current_user.userable_id
            @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0).first
            @programme_id=@programme.id
            @programme_detail=@programme.programme_list
            @subjects_paper=Programme.subject_groupbyoneprogramme2(@programme_id)
          end
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_params
      params.require(:exam).permit(:name, :description, :created_by, :course_id, :subject_id, :klass_id, :exam_on, :duration, :full_marks, :starttime, :endtime, :topic_id, :sequ, examtemplates_attributes: [:id, :_destroy, :questiontype, :quantity, :total_marks], :examquestion_ids => [], :seq => [])
    end
end
