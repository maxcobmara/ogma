class StaffTraining::PtschedulesController < ApplicationController
  filter_access_to :index, :new, :create, :participants_expenses, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  before_action :set_ptschedule, only: [:show, :edit, :update, :destroy]

  def index
    @ptschedules = Ptschedule.all#where('start >= ?', Date.today).order("start ASC")
  end
  
  def show
  end
  
  def new
    @ptcourse = Ptcourse.find(params[:ptcourse_id])
    @ptschedule = @ptcourse.scheduled.new(params[:ptschedule])
    #3@ptschedule.save
    #@ptcourse = Ptcourse.new
    @@ptschedule = @ptschedule
  end
  
  def edit
  end
  
  def create
    @ptschedule = Ptschedule.new(ptschedule_params)

    respond_to do |format|
      if @ptschedule.save
        format.html { redirect_to staff_training_ptschedules_path, notice: 'Course was successfully scheduled.' }
        format.json { render action: 'show', status: :created, location: @ptschedule }
      else
        format.html { render action: 'new' }
        format.json { render json: @ptschedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /compounds/1
  # PATCH/PUT /compounds/1.json
  def update
    respond_to do |format|
      if @ptschedule.update(ptschedule_params)
        format.html { redirect_to staff_training_ptschedule_path(@ptschedule), notice: (t 'staff.training.schedule.title_schedule')+" "+(t 'actions.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ptschedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compounds/1
  # DELETE /compounds/1.json
  def destroy
    @ptschedule.destroy
    respond_to do |format|
      format.html { redirect_to staff_training_ptschedules_url }
      format.json { head :no_content }
    end
  end
  
  def participants_expenses
    @search = Ptschedule.search(params[:q])
    @ptschedules = @search.result.where(budget_ok: true).page(params[:page]||1) 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ptschedules }
    end
  end
  
  private
      # Use callbacks to share common setup or constraints between actions.
      def set_ptschedule
        @ptschedule = Ptschedule.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def ptschedule_params
        params.require(:ptschedule).permit(:location, :max_participants, :min_participants, :ptcourse_id, :start, :final_price, :budget_ok, :payment, :remark, :college_id, {:data => []})
      end
  
  
end

