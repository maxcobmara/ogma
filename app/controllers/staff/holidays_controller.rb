class Staff::HolidaysController < ApplicationController
  before_action :set_holiday, only: [:show, :edit, :update, :destroy]


  # GET /holidays
  # GET /holidays.json
  def index
    @search = Holiday.search(params[:q])
    @holidays = @search.result.order(hdate: :desc)
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def holiday_params
      params.require(:holiday).permit(:hname, :hdate, :college_id, {:data => []})
    end
end



