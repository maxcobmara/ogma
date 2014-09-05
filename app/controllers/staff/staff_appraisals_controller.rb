class StaffAppraisalsController < ApplicationController
  # GET /staff_appraisals
  # GET /staff_appraisals.xml
  
  def index

    @search = Staff_appraisal.search(params[:q])
    @staff_appraisals = @search.result
    @staff_appraisals = @staff_appraisals.page(params[:page]||1)
    end
  end