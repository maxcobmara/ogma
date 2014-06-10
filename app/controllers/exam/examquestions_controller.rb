class Exam::ExamquestionsController < ApplicationController
  before_action :set_examquestion, only: [:show, :edit, :update, :destroy]
  # GET /examquestions
  # GET /examquestions.xml
  def index
    #-----in case-use these 4 lines-------
    #@programmes = Programme.roots
    #@examquestions = Examquestion.search2(params[:programmid])    #all if not specified
    #@subject_exams = @examquestions.group_by { |t| t.subject_details }
    #@topic_exams = @examquestions.group_by { |t| t.topic_id }
    #-----in case-use these 4 lines-------

    current_user = User.find(11)    #maslinda 
    #current_user = User.find(72)    #izmohdzaki
    @position_exist = current_user.staff.positions
    if @position_exist
      @lecturer_programme = current_user.staff.positions[0].unit
      unless @lecturer_programme.nil?
        @programme = Programme.find(:first,:conditions=>['name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0])
      end
      unless @programme.nil?
        @programme_id = @programme.id
        @subject_ids_of_programme = Programme.find(@programme_id).descendants.at_depth(2).pluck(:id)
      else
        if @lecturer_programme == 'Commonsubject'
          @programme_id ='1'
        else
          @programme_id='0'
        end
        @subject_ids_of_programme = Programme.all.at_depth(2).pluck(:id)
      end
      #@examquestions = Examquestion.search2(@programme_id)                                 #listing based on programme
      #@programme_exams = @examquestions.group_by {|t| t.subject.root} 
      
    end 
 
    @search = Examquestion.search(params[:q])
    @examquestions3 = @search.result                                                         #result of search   
    #Examquestion.search(:subject_id_in=>[75,1366])
    #@examquestions = @examquestions3.where(:subject_id => [75,1366])  
    @examquestions_prog = @examquestions3.where(:subject_id => @subject_ids_of_programme)    #select for current programme (of logged-in user)
    @examquestions = @examquestions_prog.order(subject_id: :asc).page(params[:page]||1)
    @programme_exams = @examquestions.group_by {|t| t.subject.root} 
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @examquestions }
      format.csv { send_data @examquestions.to_csv }
      format.xls { send_data @examquestions.to_csv(col_sep: "\t") }
    end
  end

  # GET /examquestions/1
  # GET /examquestions/1.xml
  def show
    @examquestion = Examquestion.find(params[:id])
    @q_frequency=Examquestion.find(:all, :joins=>:exams,:conditions=>['examquestion_id=?',(params[:id])])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @examquestion }
    end
  end

  # GET /examquestions/new
  # GET /examquestions/new.xml
  def new
    @examquestion = Examquestion.new
    #@lecturer_programme = current_user.staff.position.unit     - replace with : 2 lines (below)
    current_user = User.find(11)  #current_user = User.find(72) - izmohdzaki, 11-maslinda
    @lecturer_programme = current_user.staff.positions[0].unit
    
    @creator = current_user.staff.id 
    
    unless @lecturer_programme.nil?
      @programme = Programme.find(:first,:conditions=>['name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0])
    end
    unless @programme.nil? #for lecturers
      @programme_listing = Programme.find(:all, :conditions=> ['id=?',@programme.id]).to_a
      @preselect_prog = @programme.id
      @all_subject_ids = Programme.find(@preselect_prog).descendants.at_depth(2).map(&:id)
      if @lecturer_programme == 'Commonsubject'
        @subjects2 = Programme.find(:all, :conditions=>['id IN(?) AND course_type=?',@all_subject_ids, @lecturer_programme],:order=>'ancestry ASC') 
      else
        @subjects2 = Programme.find(:all, :conditions=>['id IN(?) AND course_type=?',@all_subject_ids, 'Subject'], :order=>'ancestry ASC')  #'Subject' 
        #subjects2 - kaka2 (NEW)
      end
    else #for admin
      @programme_listing = Programme.roots
      @subjects2 = Programme.all.at_depth(2).sort #default for NEW record & resubmission of NEW record - refer kaka2
    end
    
    #no topic will be displayed until subject is selected - below line required as DEFAULT value
    @topics = Programme.all.at_depth(3).sort  
    #refer examquestion.js.coffee (same for all, except for : when programme & subject are selected, topics will be populated accordingly)
    
    3.times { @examquestion.shortessays.build }
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @examquestion }
    end
  end

  def update_subjects
    programme = Programme.find(params[:programme_id])
    @subjects = Programme.find(programme.id).descendants.at_depth(2).order(ancestry: :asc)
  end

  def update_topics
    @topics = Programme.find(params[:subject_id]).descendants.at_depth(3).order(ancestry: :asc)
  end
  
  # GET /examquestions/1/edit
  def edit
    @examquestion = Examquestion.find(params[:id])
    current_user = User.find(11)  #current_user = User.find(72) - izmohdzaki, 11-maslinda
		@creator = @examquestion.creator_id
    
    @lecturer_programme = current_user.staff.positions[0].unit      
    unless @lecturer_programme.nil?
      @programme = Programme.find(:first,:conditions=>['name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0])
    end
    
    #NOTE : For ALL records, EDIT : @subjects1 & @topics always SELECTED (mandatory fields), (programme list - based on logged-in user)
    unless @programme.nil?  
      @programme_listing = Programme.find(:all, :conditions=> ['id=?',@programme.id]).to_a
      @preselect_prog = @programme.id
      @all_subject_ids = Programme.find(@preselect_prog).descendants.at_depth(2).map(&:id)
      
      if @lecturer_programme == 'Commonsubject'
        @subjects1 = Programme.find(:all, :conditions=>['id IN(?) AND course_type=?',@all_subjects_ids, @lecturer_programme],:order=>'ancestry ASC')  
      else
        @subjects1 = Programme.find(:all, :conditions=> ['id IN(?)',@all_subject_ids])
      end
    else  #for admin (has no programme in current_user.staff.position.unit)
      @programme_listing = Programme.roots
      @subjects1 = Programme.find(@examquestion.subject_id).root.descendants.at_depth(2).sort_by{|x|x.ancestry}
    end
    @topics = Programme.find(@examquestion.subject_id).descendants.at_depth(3).sort_by{|x|x.code}
  end

  # POST /examquestions
  # POST /examquestions.xml
  def create
    @examquestion= Examquestion.new(examquestion_params)
    
    current_user = User.find(11)  #current_user = User.find(72) - izmohdzaki, 11-maslinda    
    #--newly added--same as edit--required when incomplete data submitted
    @lecturer_programme = current_user.staff.positions[0].unit      
    if @lecturer_programme != 'Commonsubject'
      @programme = Programme.find(:first,:conditions=>["name ILIKE (?) AND ancestry_depth=?","%#{@lecturer_programme}%",0])
    end
    unless @programme.nil? #for lecturers
      @programme_listing = Programme.find(:all, :conditions=> ['id=?',@programme.id]).to_a
      @preselect_prog = @programme.id
      @all_subject_ids = Programme.find(@preselect_prog).descendants.at_depth(2).map(&:id)      
      if @lecturer_programme == 'Commonsubject' #common subject lecturers
        unless @examquestion.subject_id.nil? || @examquestion.subject_id.blank? || @examquestion.subject_id==0 
          @subjects2 = Programme.find(:all, :conditions=>['id IN(?) AND course_type=?',@all_subjects1, @lecturer_programme],:order=>'ancestry ASC')
          #to define topic later
        else
          @subjects2 = Programme.find(:all, :conditions=>['id IN(?) AND course_type=?',@all_subjects2, @lecturer_programme],:order=>'ancestry ASC')
          #to define topic later
        end 
      else  #programme lecturers
        #when SUBJECT is selected, @subjects2 - lili2 NEW (resubmission) & @topics - kaka3 NEW (resubmission)
        @subjects2 = Programme.find(:all, :conditions=>['id IN(?) AND course_type=?',@all_subject_ids, 'Subject'],:order=>'ancestry ASC')   
        unless @examquestion.subject_id.nil? || @examquestion.subject_id.blank? || @examquestion.subject_id==0 || @examquestion.subject_id=='Select the Subject' #if subject already selected
          @topics = Programme.find(@examquestion.subject_id).descendants.at_depth(3)
        else
          @topics = Programme.find(@preselect_prog).descendants.at_depth(3) #default - still required, although TOPIC FIELD is hide
        end
        #when SUBJECT is NOT selected, @subjects2 - kaka2 (NEW-resubmission), @topics - kaka3 (NEW-resubmission)
      end
    else #for admin
      @programme_listing = Programme.roots
      unless @examquestion.subject_id.nil? || @examquestion.subject_id.blank? || @examquestion.subject_id==0 || @examquestion.subject_id=='Select the Subject' #if subject already selected
        @subjects2 = Programme.find(@examquestion.subject.root_id).descendants.at_depth(2).sort_by{|x|x.ancestry}
        @topics = Programme.find(@examquestion.subject_id).descendants.at_depth(3).sort
      else  # if subject not selected yet 
        #check if programme IS SELECTED (re-submit of new record)
        if @examquestion.programme_id.nil? || @examquestion.programme_id.blank? #note : SUBJECT FIELD & TOPIC FIELD are hide
          @subjects2= Programme.find(:all, :conditions=>['ancestry_depth=?',2],:order=>'ancestry ASC')
          @topics = Programme.all.at_depth(3).sort  #refer examquestion.js.coffee
        else
          @subjects2 = Programme.find(@examquestion.programme_id).descendants.at_depth(2).sort_by{|x|x.ancestry}
          @topics = Programme.find(@examquestion.programme_id).descendants.at_depth(3).sort
        end
      end      
    end
    #--newly added--same as edit--required when incomplete data submitted
   
    respond_to do |format|
      if @examquestion.save
        flash[:notice] = (t 'exam.examquestions.title')+(t 'actions.created')
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
    #raise params.inspect
    @examquestion = Examquestion.find(params[:id])
    #@subject_exams = @examquestions.group_by { |t| t.subject_details }

    respond_to do |format|
      if @examquestion.update(examquestion_params)
        flash[:notice] = (t 'exam.examquestions.title')+(t 'actions.updated')
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
    @exist_in_exam = Exam.find(:all, :joins=>:examquestions, :conditions=> ['examquestion_id=?',params[:id]]).count
    if @exist_in_exam == 0
        @examquestion.destroy
    else
        flash[:error] = 'This examquestion EXIST in examination and is not allowed for deletion.'
    end
    #22Apr2013--avoid deletion of examquestion that exist in exams
    
    respond_to do |format|
      format.html { redirect_to(examquestions_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_examquestion
      @examquestion = Examquestion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def examquestion_params
      params.require(:examquestion).permit(:activate,:answermcq, :subject_id, :questiontype, :question, :answer, :marks, :category, :qkeyword, :qstatus, :creator_id, :createdt, :difficulty, :statusremark, :editor_id, :editdt, :approver_id, :approvedt, :bplreserve, :bplsent, :bplsentdt, :diagram, :diagram_file_name, :diagram_content_type, :diagram_file_size, :diagram_updated_at, :diagram_caption, :topic_id , :construct, :conform_curriculum, :conform_specification, :conform_opportunity, :accuracy_construct, :accuracy_topic, :accuracy_component, :fit_difficulty, :fit_important, :fit_fairness, :programme_id, answerchoices_attributes: [:id,:examquestion_id, :item, :description], examanswers_attributes: [:id,:examquestion_id,:item,:answer_desc], shortessays_attributes: [:id,:item,:subquestion,:submark,:subanswer, :examquestion_id, :keyword], booleanchoices_attributes: [:id, :examquestion_id,:item,:description], booleananswers_attributes: [:id,:examquestion_id, :item, :answer])
    end
end
