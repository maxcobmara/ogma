class Staff::StaffAppraisalsController < ApplicationController
  def index
    @search = StaffAppraisal.search(params[:q])
  end
  
  def show
  end
  
  def new
  @staff_appraisal = StaffAppraisal.new
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
