class StaffTraining::PtschedulesController < ApplicationController
  
  before_action :set_ptschedule, only: [:show, :edit, :update, :destroy]

  def index
    @ptschedules = Ptschedule.where('start >= ?', Date.today).order("start ASC")
  end
  
  def show
  end
  
  def new
    @ptcourse = Ptcourse.new
  end
  
  def edit
  end
  
  def create
    @ptcourse = Ptcourse.new(compound_params)

    respond_to do |format|
      if @ptcourse.save
        format.html { redirect_to @ptcourse, notice: 'Course was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ptcourse }
      else
        format.html { render action: 'new' }
        format.json { render json: @ptcourse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /compounds/1
  # PATCH/PUT /compounds/1.json
  def update
    respond_to do |format|
      if @ptcourse.update(compound_params)
        format.html { redirect_to @ptcourse, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ptcourse.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compounds/1
  # DELETE /compounds/1.json
  def destroy
    @ptcourse.destroy
    respond_to do |format|
      format.html { redirect_to compounds_url }
      format.json { head :no_content }
    end
  end
  
  
  private
      # Use callbacks to share common setup or constraints between actions.
      def set_ptcourse
        @ptcourse = Ptcourse.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def ptcourse_params
        params.require(:ptcourse).permit(:fiscalstart, :budget, :used_budget, :budget_balance)
      end
  
  
end