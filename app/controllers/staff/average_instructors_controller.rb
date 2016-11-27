class Staff::AverageInstructorsController < ApplicationController
  filter_access_to :index, :new, :create, :averageinstructor_evaluation, :averageinstructor_list, :attribute_check => false 
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  
  before_action :set_index_list, only: [:index, :averageinstructor_list]
  before_action :set_average_instructor, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @average_instructors=@average_instructors.page(params[:page]||1)
    respond_with(@average_instructors)
  end

  def show
    respond_with(@average_instructor)
  end

  def new
    @average_instructor = AverageInstructor.new
    respond_with(@average_instructor)
  end

  def edit
  end

  def create
    @average_instructor = AverageInstructor.new(average_instructor_params)
    #@average_instructor.save
    #respond_with(@average_instructor)
    respond_to do |format|
      if @average_instructor.save
        format.html { redirect_to staff_average_instructors_url, notice: (t 'average_instructor.title')+(t 'actions.updated')  }
        format.json { render action: 'show', status: :created, location: @average_instructor}
      else
        format.html { render action: 'new' }
        format.json { render json: @average_instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
#     @average_instructor.update(average_instructor_params)
#     respond_with(@average_instructor)
    respond_to do |format|
      if @average_instructor.update(average_instructor_params)
        format.html { redirect_to staff_average_instructor_path(@average_instructor), notice: (t 'average_instructor.title')+(t 'actions.updated')  }
        format.json { render action: 'show', status: :created, location: @average_instructor}
      else
        format.html { render action: 'edit' }
        format.json { render json: @average_instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @average_instructor.destroy
    respond_with(@average_instructor)
  end
  
  def averageinstructor_evaluation
    @average_instructor= AverageInstructor.find(params[:id])
    respond_to do |format|
       format.pdf do
         pdf = Averageinstructor_evaluationPdf.new(@average_instructor, view_context, current_user.college)
         send_data pdf.render, filename: "averageinstructor_evaluation-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end
  
  def averageinstructor_list
    respond_to do |format|
      format.pdf do
        pdf = Averageinstructor_listPdf.new(@average_instructors, view_context, current_user.college)
        send_data pdf.render, filename: "averageinstructor_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end

  private
    def set_average_instructor
      @average_instructor = AverageInstructor.find(params[:id])
    end
    
    def set_index_list
      current_roles=current_user.roles.pluck(:authname)
      admin_roles=['developer', 'administration', 'average_instructors_module_admin', 'average_instructors_module_viewer', 'average_instructors_module_user']
      adm=[]
      current_roles.each{|e|adm << admin_roles.include?(e)}
      @search=AverageInstructor.search(params[:q])
      if adm.count(true) > 0
        @average_instructors = @search.result
      else
        @average_instructors = @search.result.search2(current_user.userable_id)
      end
    end

    def average_instructor_params
      params.require(:average_instructor).permit(:programme_id, :instructor_id, :evaluate_date, :title, :objective, :start_at, :end_at, :delivery_type, :pbq1, :pbq2, :pbq3, :pbq4, :pbq1review, :pbq2review, :pbq3review, :pbq4review, :pdq1, :pdq2, :pdq3, :pdq4, :pdq5, :pdq1review, :pdq2review, :pdq3review, :pdq4review, :pdq5review, :dq1, :dq2, :dq3, :dq4, :dq5, :dq6, :dq7, :dq8, :dq9, :dq10, :dq11, :dq12, :dq1review, :dq2review, :dq3review, :dq4review, :dq5review, :dq6review, :dq7review, :dq8review, :dq9review, :dq10review, :dq11review, :dq12review, :uq1, :uq2, :uq3, :uq4, :uq1review, :uq2review, :uq3review, :uq4review, :vq1, :vq2, :vq3, :vq4, :vq5, :vq1review, :vq2review, :vq3review, :vq4review, :vq5review, :gttq1, :gttq2, :gttq3, :gttq4, :gttq5, :gttq6, :gttq7, :gttq8, :gttq9, :gttq1review, :gttq2review, :gttq3review, :gttq4review, :gttq5review, :gttq6review, :gttq7review, :gttq8review, :gttq9review, :review, :evaluator_id, :college_id,{ :data => []})
    end
end
