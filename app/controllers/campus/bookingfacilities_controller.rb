class Campus::BookingfacilitiesController < ApplicationController
  #filter_resource_access
  filter_access_to :index, :new, :create, :booking_facility, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :approval, :approval_facility, :attribute_check => true
  before_action :set_bookingfacility, only: [:show, :edit, :update, :destroy, :approval, :approval_facility, :booking_facility]

  # GET /bookingfacilities
  # GET /bookingfacilities.xml
  def index
    @search=Bookingfacility.search(params[:q])
    @bookingfacilities=@search.result.order(start_date: :desc)
    @bookingfacilities=@bookingfacilities.page(params[:page]||1)
  end

  # GET /bookingfacilities/1
  # GET /bookingfacilities/1.xml
  def show
  end

  # GET /bookingfacilities/new
  # GET /bookingfacilities/new.xml
  def new
    @bookingfacility=Bookingfacility.new
  end

  # GET /bookingfacilities/1/edit
  def edit
    @bookingfacility=Bookingfacility.find(params[:id])
  end

  # POST /bookingfacilities
  # POST /bookingfacilities.xml
  def create
    @bookingfacility = Bookingfacility.new(bookingfacility_params)
    
    respond_to do |format|
      if @bookingfacility.save
        format.html { redirect_to campus_bookingfacilities_path, notice: t('campus.bookingfacilities.title')+t('actions.created')}
        format.json { render action: 'show', status: :created, location: @bookingfacility}
      else
        format.html { render action: 'new' }
        format.json { render json: @bookingfacility.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bookingfacilities/1
  # PUT /bookingfacilities/1.xml
  def update
    @bookingfacility=Bookingfacility.find(params[:id])
    respond_to do |format|
      if @bookingfacility.update(bookingfacility_params)
        format.html { redirect_to campus_bookingfacility_path(@bookingfacility), notice: t('campus.bookingfacilities.title')+t('actions.updated') }
        format.json { head :no_content }
      else
        if @bookingfacility.approval_date.blank?
           format.html { render action: 'approval' }
           format.json { render json: @bookingfacility.errors, status: :unprocessable_entity }
       elsif @bookingfacility.approval_date2.blank?
           format.html { render action: 'approval_facility' }
           format.json { render json: @bookingfacility.errors, status: :unprocessable_entity }
        else
          format.html { render action: 'edit' }
          format.json { render json: @bookingfacility.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /bookingfacilities/1
  # DELETE /bookingfacilities/1.xml
  def destroy
    @bookingfacility.destroy
    respond_to do |format|
      format.html { redirect_to bookingfacilities_url }
      format.json { head :no_content }
    end
  end
  
  def booking_facility
    @bookingfacility = Bookingfacility.find(params[:id])
    respond_to do |format|
       format.pdf do
         pdf = BookingfacilityPdf.new(@bookingfacility, view_context, current_user.college)
         send_data pdf.render, filename: "booking_facility-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end
  
  def bookingfacilities_report
    @search=Bookingfacility.search(params[:q])
    @bookingfacilities=@search.result.order(start_date: :desc)
    respond_to do |format|
       format.pdf do
         pdf = Bookingfacilities_reportPdf.new(@bookingfacilities, view_context, current_user.college)
         send_data pdf.render, filename: "bookingfacilities_report-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookingfacility
      @bookingfacility = Bookingfacility.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bookingfacility_params
      params.require(:bookingfacility).permit(:id, :location_id, :staff_id, :request_date, :start_date, :end_date, :approver_id, :approval, :approval_date, :remark, :approval2, :approval_date2, :remark2, :total_participant, :purpose, :approver_id2, :college_id, {:data => []})
    end
end
