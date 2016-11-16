class Exam::ExamanalysesController < ApplicationController
  filter_access_to :index, :new, :create, :analysis_data, :examanalysis_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  
  before_action :set_examanalysis, only: [:show, :edit, :update, :destroy]
  before_action :set_index_new_data, only: [:index, :new, :examanalysis_list]
  
  def index
    respond_to do |format|
      if @examanalyses
        format.html # index.html.erb
        format.xml  { render :xml => @examanalyses }
      else
        format.html { redirect_to(dashboard_url, :notice =>t('positions_required')+(t 'exam.title')+" - "+(t 'exam.examanalysis.title'))}
        format.xml  { render :xml => @examanalyses.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def new
    @examanalysis=Examanalysis.new
    exist=Examanalysis.pluck(:exam_id)
    grades_subject_ids=Grade.where(subject_id: @subject_ids).pluck(:subject_id)
    exist_exammark=Exammark.pluck(:exam_id)
    @exams=Exam.where(name: "F").where(id: exist_exammark).where(subject_id: grades_subject_ids).where.not(id: exist)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @examanalysis }
    end
  end
    
  def create
    @examanalysis = Examanalysis.new(examanalysis_params)
    exist=Examanalysis.pluck(:exam_id)
    grades_subject_ids=Grade.where(subject_id: @subject_ids).pluck(:subject_id)
    exist_exammark=Exammark.pluck(:exam_id)
    @exams=Exam.where(name: "F").where(id: exist_exammark).where(subject_id: grades_subject_ids).where.not(id: exist)
    respond_to do |format|
      if @examanalysis.save
        flash[:notice]=t('exam.examanalysis.analysis_created')
        format.html {render :action => "edit"}
        format.xml  { render :xml => @examanalysis, :status => :created}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @examanalysis.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /examanalyses/1
  # PUT /examanalyses/1.xml
  def update
    @examanalysis = Examanalysis.find(params[:id])
    respond_to do |format|
      if @examanalysis.update(examanalysis_params)
        format.html { redirect_to(exam_examanalysis_path(@examanalysis), :notice => t('exam.examanalysis.title')+t('actions.updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @exammark.errors, :status => :unprocessable_entity }
      end
    end
  end
  
    
  # DELETE /examanalyses/1
  # DELETE /examanalyses/1.xml
  def destroy
    @examanalysis = Examanalysis.find(params[:id])
    @examanalysis.destroy

    respond_to do |format|
      format.html { redirect_to(exam_examanalyses_url) }
      format.xml  { head :ok }
    end
  end
  
  def analysis_data
    @exam_id = params[:exam_id]
    @analysis=Examanalysis.where(exam_id: @exam_id) #result must be in hash/arr

    respond_to do |format|
      format.html
      format.csv { send_data @analysis.to_csv3}
      format.xls { send_data @analysis.to_csv3(col_sep: "\t") } 
    end
  end
  
  def examanalysis_list
    respond_to do |format|
      format.pdf do
        pdf = Examanalysis_listPdf.new(@examanalyses, view_context, current_user.college)
        send_data pdf.render, filename: "examanalysis_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end

  private 
  
  # Use callbacks to share common setup or constraints between actions.
    def set_examanalysis
      @examanalysis = Examanalysis.find(params[:id])
    end
    
    def set_index_new_data
      position_exist = @current_user.userable.positions
      roles= @current_user.roles.pluck(:authname)
      @is_admin=true if roles.include?("developer") || roles.include?("administration") || roles.include?("exam_analysis_module_admin") || roles.include?("exam_analysis_module_viewer") || roles.include?("exam_analysis_module_member")
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
          elsif posbasiks.include?(lecturer_programme) && tasks_main!=nil && lecturer_programme!=''
            allposbasic_prog = Programme.where(course_type: posbasiks).pluck(:name)  #Onkologi, Perioperating, Kebidanan etc
            for basicprog in allposbasic_prog
              lecturer_basicprog_name = basicprog if tasks_main.include?(basicprog)==true
            end
            programme_id=Programme.where(name: lecturer_basicprog_name, ancestry_depth: 0).first.id
          elsif @is_admin==true
            programme_id='0'# if @current_user.roles.pluck(:authname).include?("administration")
          else
            leader_unit=tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if tasks_main!="" && tasks_main.include?('Program')
            if leader_unit
              programme_id = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0).first.id
            end
          end
        end
        if programme_id=='0'
          @subject_ids=Programme.where(course_type: 'Subject').pluck(:id)
	elsif programme_id=='1'
	  @subject_ids=Programme.where(course_type: 'Commonsubject').pluck(:id)
        else
          @subject_ids=Programme.where(id: programme_id).first.descendants.where(course_type: 'Subject').pluck(:id)
        end
	@programme_id= programme_id
        #INDEX use
        @search = Examanalysis.search(params[:q])
        @examanalyses = @search.result.search2(programme_id)
        @examanalyses = @examanalyses.page(params[:page]||1)
      end
    end
    
     # Never trust parameters from the scary internet, only allow the white list through.
    def examanalysis_params
      params.require(:examanalysis).permit(:exam_id, :gradeA, :gradeAminus, :gradeBplus, :gradeB, :gradeBminus, :gradeCplus, :gradeC, :gradeCminus, :gradeDplus, :gradeD, :gradeE, :college_id, {:data => []})
    end
    
end