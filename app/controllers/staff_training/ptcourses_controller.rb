class StaffTraining::PtcoursesController < ApplicationController
  filter_access_to :index, :new, :create, :ptcourse_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  
  before_action :set_ptcourse, only: [:show, :edit, :update, :destroy]

  def index
    @search = Ptcourse.search(params[:q])
    @ptcourses = @search.result
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
  
  def ptcourse_list
    @search = Ptcourse.search(params[:q])
    @ptcourses = @search.result
    respond_to do |format|
      format.pdf do
        pdf = Ptcourse_listPdf.new(@ptcourses, view_context, current_user.college)
        send_data pdf.render, filename: "ptcourse_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  private
      # Use callbacks to share common setup or constraints between actions.
      def set_ptcourse
        @ptcourse = Ptcourse.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def ptcourse_params
        params.require(:ptcourse).permit(:cost, :course_type, :description, :duration, :duration_type, :name, :provider_id, :approved, :training_classification, :level, :college_id, {:data => []})
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