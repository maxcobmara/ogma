class Staff::StaffAppraisalsController < ApplicationController
  def index
    @search = StaffAppraisal.search(params[:q])
    @staff_appraisals = @search.result
    @staff_appraisals = @staff_appraisals.page(params[:page]||1)
  end
  
  def show
  end
  
  def new
  @staff_appraisals = StaffAppraisal.new
  end
  
  def edit
  end
  
  def create
  end
  
  def update
  end
  
  def destroy
  end
  
  def appraisal_form

    @staff_appraisals = StaffAppraisal.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Appraisal_formPdf.new(@staff_appraisals, view_context)
        send_data pdf.render, filename: "appraisal_form-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  
end
