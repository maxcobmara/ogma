class StaffTraining::PtcoursesController < ApplicationController
  
  before_action :set_ptcourse, only: [:show, :edit, :update, :destroy]

  def index
    @ptcourses = Ptcourse.all
  end
  
  def show
  end
  
  def new
    @ptcourse = Ptcourse.new
  end
  
  def edit
  end
  
  def create
    @ptcourse = Ptcourse.new(ptcourse_params)

    respond_to do |format|
      if @ptcourse.save
        format.html { redirect_to staff_training_ptcourse_path(@ptcourse), notice: 'Course was successfully created.' }
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
      if @ptcourse.update(ptcourse_params)
        format.html { redirect_to staff_training_ptcourse_path(@ptcourse), notice: 'Course was successfully updated.' }
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
      flash[:notice] = 'Course is deleted'
      format.html { redirect_to staff_training_ptcourses_path }
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
        params.require(:ptcourse).permit(:cost, :course_type, :description, :duration, :duration_type, :name, :provider_id, :approved, :training_classification)
      end
  
  
end


#  approved      :boolean
#  cost          :decimal(, )
#  course_type   :integer
#  created_at    :datetime
#  description   :text
#  duration      :decimal(, )
#  duration_type :integer
#  id            :integer          not null, primary key
#  name          :string(255)
#  proponent     :string(255)
#  provider_id   :integer
#  updated_at    :datetime