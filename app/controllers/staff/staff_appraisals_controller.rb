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
end
