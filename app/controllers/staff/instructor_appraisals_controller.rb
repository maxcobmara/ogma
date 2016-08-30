class Staff::InstructorAppraisalsController < ApplicationController
  #filter_access_to :index, :new, :create, :instructorevaluation, :instructorevaluation_report, :attribute_check => false
  #filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  
  before_action :set_instructor_appraisal, only: [:show, :edit, :update, :destroy] 

  respond_to :html

  def index
    @search = InstructorAppraisal.search(params[:q])
    @instructor_appraisals = @search.result
    @instructor_appraisals=@instructor_appraisals.page(params[:page]||1)
    respond_with(@instructor_appraisals)
  end

  def show
    respond_with(@instructor_appraisal)
  end

  def new
    @instructor_appraisal = InstructorAppraisal.new
    respond_with(@instructor_appraisal)
  end

  def edit
  end

  def create
    @instructor_appraisal = InstructorAppraisal.new(instructor_appraisal_params)
    #@instructor_appraisal.save
    #respond_with(staff_instructor_appraisal_path(@instructor_appraisal))
    respond_to do |format|
      if @instructor_appraisal.save
        format.html { redirect_to staff_instructor_appraisals_url, notice: (t 'instructor_appraisal.title')+(t 'actions.updated')  }
        format.json { render action: 'show', status: :created, location: @rank }
      else
        format.html { render action: 'new' }
        format.json { render json: @rank.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @instructor_appraisal.update(instructor_appraisal_params)
    #respond_with(staff_instructor_appraisal_path(@instructor_appraisal))
    respond_to do |format|
      if @instructor_appraisal.update(instructor_appraisal_params)
        format.html { redirect_to staff_instructor_appraisal_path(@instructor_appraisal), notice: (t 'instructor_appraisal.title')+(t 'actions.updated')  }
        format.json { render action: 'show', status: :created, location: @instructor_appraisal }
      else
        format.html { render action: 'new' }
        format.json { render json: @rank.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @instructor_appraisal.destroy
    respond_with(@instructor_appraisal)
  end
  
  def qc_appraisal
    @instructor_appraisal=InstructorAppraisal.find(params[:id])
  end
  
  def instructorevaluation
    @instructor_appraisal = InstructorAppraisal.find(params[:id])
    respond_to do |format|
       format.pdf do
         pdf = InstructorevaluationPdf.new(@instructor_appraisal, view_context, current_user.college)
         send_data pdf.render, filename: "instructorevaluation-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end
  
   def instructorevaluation_report
     @search = InstructorAppraisal.search(params[:q]) 
     @instructor_appraisals = @search.result
     respond_to do |format|
       format.pdf do
         pdf = Instructorevaluation_reportPdf.new(@instructor_appraisals, view_context, current_user.college)
         send_data pdf.render, filename: "instructorevaluation_report-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end

  private
    def set_instructor_appraisal
      @instructor_appraisal = InstructorAppraisal.find(params[:id])
    end

    def instructor_appraisal_params
      params.require(:instructor_appraisal).permit(:staff_id, :appraisal_date, :qc_sent, :q1, :q2, :q3, :q4, :q5, :q6, :q7, :q8, :q9, :q10, :q11, :q12, :q13, :q14, :q15, :q16, :q17, :q18, :q19, :q20, :q21, :q22, :q23, :q24, :q25, :q26, :q27, :q28, :q29, :q30, :q31, :q32, :q33, :q34, :q35, :q36, :q37, :q38, :q39, :q40, :q41, :q42, :q43, :q44, :q45, :q46, :q47, :q48, :total_mark, :check_qc, :check_date, :checked)
    end
end
