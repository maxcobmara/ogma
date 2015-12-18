class Exam::ExammarksController < ApplicationController
  filter_access_to :all #use this for new_multiple, create_multiple, edit_multiple & update_multiple to works
  #filter_resource_access
  before_action :set_exammark, only: [:show, :edit, :update, :destroy]
  before_action :set_students_exam_list, only: [:new, :create, :edit]

  # GET /exammarks
  # GET /exammarks.xml
  def index
    valid_exams = Exammark.get_valid_exams
    @valid_exammm = valid_exams.count
    position_exist = @current_user.userable.positions
    posbasiks=["Pos Basik", "Diploma Lanjutan", "Pengkhususan"]
    roles=@current_user.roles.pluck(:authname)
    if position_exist && position_exist.count > 0
      lecturer_programme = @current_user.userable.positions[0].unit
      unless lecturer_programme.nil?
        programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{lecturer_programme}%",0)  if posbasiks.include?(lecturer_programme)==false
      end
      unless programme.nil? || programme.count==0
        programme_id = programme.try(:first).try(:id)
        subjects_ids = Programme.where(id: programme_id).first.descendants.at_depth(2).pluck(:id)
        @exams_list_raw = Exam.where('subject_id IN(?) and id IN(?)', subjects_ids, valid_exams).order(name: :asc, subject_id: :asc)
      else
        tasks_main = @current_user.userable.positions[0].tasks_main
        common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
        if common_subjects.include?(lecturer_programme) 
          programme_id ='1'
          subject_ids=Programme.where(course_type: 'Commonsubject').pluck(:id)
          @exams_list_raw = Exam.where('id IN(?)', valid_exams).where(subject_id: subject_ids)#.order(name: :asc, subject_id: :asc)
        elsif posbasiks.include?(lecturer_programme) && tasks_main!=nil
          allposbasic_prog = Programme.where(course_type: posbasiks).pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
          for basicprog in allposbasic_prog
            lecturer_basicprog_name = basicprog if tasks_main.include?(basicprog)==true
          end
          if @current_user.roles.pluck(:authname).include?("programme_manager")
            programme_id='2'
            programme_ids=Programme.where(course_type: posbasiks).pluck(:id)
            subject_ids=[]
            programme_ids.each do |progid|
              Programme.where(id: progid).first.descendants.each do |descendant|
                subject_ids << descendant.id if descendant.course_type=='Subject'
              end
            end
          else
            programme_id=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
            subject_ids = Programme.where(id: programme_id).first.descendants.at_depth(2).pluck(:id)
          end
          @exams_list_raw = Exam.where('subject_id IN(?) and id IN(?)', subject_ids, valid_exams)#.order(name: :asc, subject_id: :asc)
        elsif roles.include?("administration")
          programme_id='0'
          @exams_list_raw = Exam.where('id IN(?)', valid_exams)#.order(name: :asc, subject_id: :asc)
        else
          leader_unit=tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if tasks_main!="" && tasks_main.include?('Program')
          if leader_unit
            programme_id = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0).first.id
            subjects_ids = Programme.where(id: programme_id).first.descendants.at_depth(2).pluck(:id)
            @exams_list_raw = Exam.where('subject_id IN(?) and id IN(?)', subjects_ids, valid_exams)#.order(name: :asc, subject_id: :asc)
          end
        end
      end
      @exams_list_exist_mark = Exam.joins(:exammarks).where('exam_id IN(?)', @exams_list_raw.pluck(:id)).uniq.pluck(:id)
      if @exams_list_exist_mark==[]
        @exams_list=Exam.where(id: @exams_list_raw).order(exam_on: :desc, name: :asc, subject_id: :asc)
      elsif @exams_list_exist_mark.count > 0
        @exams_list= Exam.where('id IN(?) and id NOT IN(?)', @exams_list_raw.pluck(:id), @exams_list_exist_mark).order(exam_on: :desc, name: :asc, subject_id: :asc)
      end
      
      @search = Exammark.search(params[:q])
      @exammarks = @search.result.search2(programme_id)
      @exammarks = @exammarks.page(params[:page]||1)
      @exammarks_group = @exammarks.group_by{|x|x.exam_id}
    end
    
    respond_to do |format|
      if @exammarks && @exammarks_group
        format.html # index.html.erb
        format.xml  { render :xml => @exammarks }
      else
        format.html { redirect_to(dashboard_url, :notice =>t('positions_required')+(t 'exam.title')+" - "+(t 'exam.exammark.title')) }
      end
    end
  end

  # GET /exammarks/1
  # GET /exammarks/1.xml
  def show
    @exammark = Exammark.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @exammark }
    end
  end
  
  def new
    @exammark = Exammark.new    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @exammark }
    end
  end
 
  def edit
  end
  
  def create
    @exammark = Exammark.new(exammark_params)
    examid = params[:exammark][:exam_id]
    if examid!=""
      qcount = @exammark.get_questions_count(examid)
      0.upto(qcount-1) do
        @exammark.marks.build
      end
      respond_to do |format|
        if @exammark.save
          flash[:notice] = (t 'exam.exammark.title')+(t 'actions.created')
          format.html { redirect_to(edit_exam_exammark_path(@exammark), :notice =>t('exam.exammark.title')+t('actions.created')) }
          format.xml  { render :xml => @exammark }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @exammark.errors, :status => :unprocessable_entity }     
        end
      end
    else
      flash[:notice] = t 'exam.exammark.exam_compulsory'      #checking required here, as validation only done during record saving
      redirect_to new_exam_exammark_path
    end
  end
  
  # PUT /exammarks/1
  # PUT /exammarks/1.xml
  def update
    @exammark = Exammark.find(params[:id])
    @exammark.total_mcq = params[:exammark][:total_mcq] #5June2013-added refer exammark.rb(set_total_mcq) & _form.html.haml(rev 26Nov14)
    respond_to do |format|
      if @exammark.update(exammark_params)
        format.html { redirect_to(exam_exammark_path(@exammark), :notice => t('exam.exammark.title')+t('actions.updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @exammark.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @exammark = Exammark.find(params[:id])
    @exammark.destroy
    respond_to do |format|
      format.html { redirect_to(exam_exammarks_url, :notice => t('exam.exammark.title')+t('actions.removed') ) }
      format.xml  { head :ok }
    end
  end
    
  def new_multiple
    @examid = params[:examid]
    unless @examid.nil?
      @exammarks = Array.new(1) { Exammark.new }
      @selected_exam = Exam.find(@examid)
      @iii=Exammark.set_intake_group(@selected_exam.exam_on.year,@selected_exam.exam_on.month,@selected_exam.subject.parent.code,@current_user).to_s
      common_subject = Programme.where('course_type=?','Commonsubject').map(&:id)
      valid_exams = Exammark.get_valid_exams
      position_exist = @current_user.userable.positions
      if position_exist  
        @lecturer_programme = @current_user.userable.positions[0].unit
        unless @lecturer_programme.nil?
          programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0)  if !(@lecturer_programme=="Pos Basik" || @lecturer_programme=="Diploma Lanjutan")
        end
        unless @programme.nil? || @programme.count == 0
          @programme_id = @programme.id
          @student_list = Student.where('course_id=?', @programme.id).order(name: :asc)
          @dept_unit_prog = Programme.where(id: @programme_id).first.programme_list
          @intakes_lt = @student_list.order(:intake).pluck(:intake).uniq
        else
          #for administrator, Posbasik, Diploma Lanjutan & Commonsubject lecturer : to assign programme, based on selected exampaper 
          if @examid
            @dept_unit = Programme.find(Exam.find(@examid).subject_id).root
            @dept_unit_prog = @dept_unit.programme_list
            @intakes_lt = Student.where('course_id=?',@dept_unit.id).order(:intake).pluck(:intake).uniq #must be among the programme of exampaper coz even common subject...
            @programme_id=@dept_unit.id
          end
        end
      end
    else
      flash[:notice] = t 'exam.exammark.select_exam'
      redirect_to exam_exammarks_path
    end
  end
  
  def create_multiple
    selected_intake = params[:exammarks]["0"][:intake_id]
    @examid = params[:exammarks]["0"][:exam_id]                                                       #required if render new_multiple
    @programme_id = params[:exammarks]["0"][:programme_id]                                  #required if render new_multiple
    @selected_exam = Exam.find(@examid)                                                                   #required if render new_multiple
    @intakes_lt = Student.where('course_id=?',@programme_id).pluck(:intake).uniq    #required if render new_multiple
                                               
    @exammark = Exammark.new
    qcount = @exammark.get_questions_count(@examid)
    current_program = Programme.find(Exam.find(@examid).subject_id).root_id
    selected_student = Student.where(course_id: current_program.to_i, intake: selected_intake)
    rec_count = selected_student.count
    @exammarks = Array.new(rec_count) { Exammark.new }                      
    @exammarks.each_with_index do |exammark,ind|                                     
      exammark.student_id = selected_student[ind].id
      exammark.exam_id = @examid
      0.upto(qcount-1) do
        exammark.marks.build
      end       
    end
    if @exammarks.all?(&:valid?) 
      @exammarks.each(&:save!)
      flash[:notice] = t('exam.exammark.multiple_created')
      render :action => 'edit_multiple', :exammark_ids =>@exammarks.map(&:id)
    else                                                                      
      flash[:notice] = t('exam.exammark.marks_intakes_exist')
      render :action => 'new_multiple'
    end
  end
 
  def edit_multiple
    exammarkids = params[:exammark_ids]
    unless exammarkids.blank? 
      @exammarks = Exammark.find(exammarkids)
      student_count = @exammarks.map(&:student_id).uniq.count
      edit_type = params[:exammark_submit_button]
      if edit_type == t('edit_checked') 
        ## continue multiple edit (including subject edit here) --> refer view
      end
    else
        flash[:notice] = t 'exam.exammark.select_one'
        redirect_to exam_exammarks_path
    end
  end
  
  def update_multiple
    exammarksid = params[:exammark_ids]
    totalmcqs =params[:total_mcqs]                                          
    marks = params[:marks_attributes]
    exammarks = Exammark.find(exammarksid)	
    #below (add-in sort_by) in order to get data match accordingly to form values (sorted by student name)
    exammarks.sort_by{|x|x.studentmark.name}.each_with_index do |exammark, index| 
       exammark.total_mcq = totalmcqs[index]
       totalmarks_in_grade = 0
       exammark.marks.sort_by{|x|x.created_at}.each_with_index do |aa, cc|
         aa.student_mark = params[:marks_attributes][cc.to_s][:student_marks][index]
         totalmarks_in_grade += (params[:marks_attributes][cc.to_s][:student_marks][index]).to_f     
       end
       exammark.save 
    end
    respond_to do |format|
      @exammarks = exammarks
      # TODO - refractor this
      exceed_total=[]
      mcq_max=0
      arr_current_marks=[]
      @exammarks.each do |exammrk|
        current_marks=0
        exammrk.marks.each{|m|current_marks+=m.student_mark}
        arr_current_marks << current_marks
      end
      if exammarks[0].exampaper.name!="M"
        # NOTE Final - total marks is entered values[displayed only for Radiografi & Cara Kerja], + display of summative (in % weightage) [for all programmes]
	fullmarks=Exammark.fullmarks(exammarks[0].exam_id)
        exammarks[0].exampaper.exam_template.question_count.each{|k,v|mcq_max=(v['count'].to_i) if k=="mcq"}
        other_max=fullmarks-mcq_max
        exammarks.each_with_index{|x, ind| exceed_total << x.total_marks.to_f if x.total_marks > fullmarks || x.total_mcq > mcq_max || arr_current_marks[ind] > other_max }
      else
        # NOTE Mid sem - based on entered values --> total marks is generated values (in % weightage)
        if exammarks[0].exampaper.exam_template.total_in_weight==0
          fullmarks=exammarks[0].exampaper.total_marks
        else
          fullmarks=exammarks[0].exampaper.exam_template.total_in_weight
        end
        exammarks[0].exampaper.exam_template.question_count.each{|k,v|mcq_max=v['count'].to_f if k=="mcq"}
        other_max=fullmarks-mcq_max
        exammarks.each_with_index{|x, ind| exceed_total << x.total_mcq.to_f if x.total_mcq > mcq_max || arr_current_marks[ind] > other_max}
      end
      if exceed_total.count> 0
        flash[:notice]=(t 'exam.exammark.exceed_total')
        format.html {render :action => 'edit_multiple'}
        format.xml  { head :ok }
      else
        format.html { redirect_to(exam_exammarks_url, :notice =>t('exam.exammark.multiple_updated')) }
        format.xml  { head :ok }
      end
    end
  end
  
  private
    # usage - new, edit & create - @students_list & @exams_list for collection_select
    def set_students_exam_list
      valid_exams = Exammark.get_valid_exams
      position_exist = @current_user.userable.positions
      posbasiks=['Pos Basik', 'Diploma Lanjutan', 'Pengkhususan']
      common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
      roles=@current_user.roles.pluck(:authname)
      if position_exist  
        lecturer_programme = @current_user.userable.positions[0].unit
        unless lecturer_programme.nil?
          programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{lecturer_programme}%",0) if posbasiks.include?(lecturer_programme)==false
        end
        unless programme.nil? || programme.count==0
          programme_id = programme.first.id
          @students_list = Student.where(course_id: programme_id).order('matrixno, name asc')
          subjects_ids = Programme.where(id: programme_id).first.descendants.at_depth(2).pluck(:id)
          @exams_list = Exam.where('subject_id IN(?) and id IN(?)', subjects_ids, valid_exams).order(name: :asc, subject_id: :asc)
        else
          tasks_main = @current_user.userable.positions[0].tasks_main
          if common_subjects.include?(lecturer_programme)  
            subject_ids=Programme.where(course_type: 'Commonsubject').pluck(:id)
            @exams_list = Exam.where('subject_id IN(?) and id IN(?)', subject_ids, valid_exams).order(name: :asc, subject_id: :asc)
            @students_list=Student.all.order('matrixno, name asc')
          elsif posbasiks.include?(lecturer_programme) && tasks_main!=nil
            allposbasic_prog = Programme.where('course_type=? or course_type=?', "Pos Basik", "Diploma Lanjutan").pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
            for basicprog in allposbasic_prog
              lecturer_basicprog_name = basicprog if tasks_main.include?(basicprog)==true
            end
            if @current_user.roles.pluck(:authname).include?("programme_manager")
            else
              programme_id=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
              subject_ids = Programme.where(id: programme_id).first.descendants.at_depth(2).pluck(:id)
              @exams_list = Exam.where('subject_id IN(?) and id IN(?)', subject_ids, valid_exams).order(name: :asc, subject_id: :asc)
              @students_list = Student.where(course_id: programme_id).order('matrixno, name asc')
            end
          elsif roles.include?("administration")
            subject_ids=Programme.where(course_type: ['Subject', 'Commonsubject']).pluck(:id)
            @exams_list = Exam.where('subject_id IN(?) and id IN(?)', subject_ids, valid_exams).order(name: :asc, subject_id: :asc)
            @students_list=Student.all.order('matrixno, name asc')
          else
            leader_unit=tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if tasks_main!="" && tasks_main.include?('Program')
            if leader_unit
              programme_id = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0).first.id
              subject_ids = Programme.where(id: programme_id).first.descendants.at_depth(2).pluck(:id)
              @exams_list = Exam.where('subject_id IN(?) and id IN(?)', subject_ids, valid_exams).order(name: :asc, subject_id: :asc)
              @students_list= Student.where(course_id: programme_id).order('matrixno, name asc')
            end
          end
        end
      end
    end
   # Use callbacks to share common setup or constraints between actions.
    def set_exammark
      @exammark = Exammark.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def exammark_params
      params.require(:exammark).permit(:student_id, :exam_id, :total_mcq, marks_attributes: [:id,:exammark_id, :student_mark])
    end
    
end
