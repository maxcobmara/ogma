class Exam::ExammarksController < ApplicationController
  filter_resource_access
  before_action :set_exammark, only: [:show, :edit, :update, :destroy]

  # GET /exammarks
  # GET /exammarks.xml
  def index
    @position_exist = @current_user.userable.positions
    if @position_exist  
      @lecturer_programme = @current_user.userable.positions[0].unit
      unless @lecturer_programme.nil?
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0)
      end
      unless @programme.nil? || @programme.count==0
        @programme_id = @programme.try(:first).try(:id)
      else
        if @lecturer_programme == 'Commonsubject'
          @programme_id ='1'
        else
          @programme_id='0'
        end
      end
      @search = Exammark.search(params[:q])
      @exammarks = @search.result.search2(@programme_id)
      @exammarks = @exammarks.page(params[:page]||1)
      @exammarks_group = @exammarks.group_by{|x|x.exam_id}
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @exammarks }
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
    @position_exist = @current_user.userable.positions
    if @position_exist  
      @lecturer_programme = @current_user.userable.positions[0].unit
      unless @lecturer_programme.nil?
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0)
      end
      unless @programme.nil? || @programme.count==0
        @programme_id = @programme.first.id
        @students_list = Student.where(course_id: @programme_id).order(matrixno: :asc)
        subjects_ids = Programme.where(id: @programme_id).first.descendants.at_depth(2).pluck(:id)
        @exams_list = Exam.where('subject_id IN(?)', subjects_ids).order(name: :asc, subject_id: :asc)
      else
        @students_list = Student.all.order(matrixno: :asc)
        @exams_list = Exam.all.order(name: :asc, subject_id: :asc)
      end
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @exammark }
    end
  end
  
  def edit
    @position_exist = @current_user.userable.positions
    if @position_exist  
      @lecturer_programme = @current_user.userable.positions[0].unit
      unless @lecturer_programme.nil?
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0)
      end
      unless @programme.nil? || @programme.count==0
        @programme_id = @programme.first.id
        @students_list = Student.where(course_id: @programme_id).order(matrixno: :asc)
        subjects_ids = Programme.where(id: @programme_id).first.descendants.at_depth(2).pluck(:id)
        @exams_list = Exam.where('subject_id IN(?)', subjects_ids).order(name: :asc, subject_id: :asc)
      else
        @students_list = Student.all.order(matrixno: :asc)
        @exams_list = Exam.all.order(name: :asc, subject_id: :asc)
      end
    end
  end
  
  def create
    @exammark = Exammark.new(exammark_params)
    examid = params[:exammark][:exam_id]
    questions_count = Exam.where(id: examid).first.examquestions.count
    0.upto(questions_count-1) do
      @exammark.marks.build
    end
    
    @position_exist = @current_user.userable.positions
    if @position_exist  
      @lecturer_programme = @current_user.userable.positions[0].unit
      unless @lecturer_programme.nil?
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0)
      end
      unless @programme.nil? || @programme.count==0
        @programme_id = @programme.first.id
        @students_list = Student.where(course_id: @programme_id).order(matrixno: :asc)
        subjects_ids = Programme.where(id: @programme_id).first.descendants.at_depth(2).pluck(:id)
        @exams_list = Exam.where('subject_id IN(?)', subjects_ids).order(name: :asc, subject_id: :asc)
      else
        @students_list = Student.all.order(matrixno: :asc)
        @exams_list = Exam.all.order(name: :asc, subject_id: :asc)
      end
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
      format.html { redirect_to(exam_exammarks_url) }
      format.xml  { head :ok }
    end
  end
  
  private
   # Use callbacks to share common setup or constraints between actions.
    def set_exammark
      @exammark = Exammark.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def exammark_params
      params.require(:exammark).permit(:student_id, :exam_id, :total_mcq, marks_attributes: [:id,:exammark_id, :student_mark])
    end
end
