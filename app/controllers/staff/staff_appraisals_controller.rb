class Staff::StaffAppraisalsController < ApplicationController
  def index
    @search = StaffAppraisal.search(params[:q])
    @staff_appraisals = @search.result
    @staff_appraisals = @staff_appraisals.page(params[:page]||1)
  end
  

  def show
    @staff_appraisal = StaffAppraisal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @staff_appraisal }
      format.js
    end
  end

  
  def new
    @staff_appraisal = StaffAppraisal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @staff_appraisal }
    end
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

    @staff_appraisal = StaffAppraisal.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Appraisal_formPdf.new(@staff_appraisal, view_context)
        send_data pdf.render, filename: "appraisal_form-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  
end
