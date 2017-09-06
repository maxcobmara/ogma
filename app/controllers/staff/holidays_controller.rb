class Staff::HolidaysController < ApplicationController
  filter_access_to :index, :new, :create, :holiday_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  
  before_action :set_holiday, only: [:show, :edit, :update, :destroy]
  before_action :set_holidays, only: [:index, :holiday_list]

  # GET /holidays
  # GET /holidays.json
  def index
    @holidays = @holidays.page(params[:page]||1)
  end
  
  # GET /holidays/1
  # GET /holidays/1.json
  def show
  end

  # GET /holidays/new
  def new
    @holiday = Holiday.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @info }
    end
  end

  # GET /holidays/1/edit
  def edit
    @holiday = Holiday.find(params[:id])
  end

  # POST /holidays
  # POST /holidays.json
 def create
  @holiday= Holiday.new(holiday_params)
  respond_to do |format|
    if @holiday.save
      format.html { redirect_to staff_holidays_url, notice: (t 'holiday.title')+(t 'actions.created')  }
      format.json { render action: 'show', status: :created, location: @holiday }
    else
      format.html { render action: 'new' }
      format.json { render json: @holiday.errors, status: :unprocessable_entity }
    end
  end
end

  # PATCH/PUT /holidays/1
  # PATCH/PUT /holidays/1.json
  def update
    @holiday = Holiday.find(params[:id])
    respond_to do |format|
      if @holiday.update(holiday_params)
        format.html { redirect_to staff_holiday_path, notice: (t 'holiday.title')+(t 'actions.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /holidays/1
  # DELETE /holidays/1.json
  def destroy
    @holiday.destroy
    respond_to do |format|
      format.html { redirect_to staff_holidays_url}
      format.json { head :no_content }
    end
  end
  
  def holiday_list
    respond_to do |format|
      format.pdf do
        pdf = Holiday_listPdf.new(@holidays, view_context, current_user.college)
        send_data pdf.render, filename: "holiday_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end
    
    def set_holidays
      @search = Holiday.search(params[:q])
      @holidays = @search.result.order(hdate: :desc)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def holiday_params
      params.require(:holiday).permit(:hname, :hdate, :college_id, {:data => []})
    end
end



