class Staff::MentorsController < ApplicationController
  filter_resource_access
  before_action :set_mentor, only: [:show, :edit, :update, :destroy]
  # GET /mentors
  # GET /mentors.xml

  def index
    @search = Mentor.search(params[:q])
    @mentors = @search.result
    @mentors = @mentors.page(params[:page]||1)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mentors }
    end
  end

  def new
    @mentor=Mentor.new
    #@mentor.mentees.build
  end
  
  def create
    @mentor=Mentor.new(mentor_params)
    respond_to do |format|
      if @mentor.save
        format.html { redirect_to staff_mentors_path, :notice =>t('staff.mentors.title')+t('actions.created')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mentor.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /mentors/1/edit
  def edit
    @mentor = Mentor.find(params[:id])
  end

  # PUT /mentors/1
  # PUT /mentors/1.xml
  def update
    @mentor = Mentor.find(params[:id])

    respond_to do |format|
      if @mentor.update(mentor_params)
        format.html { redirect_to staff_mentors_path, :notice =>t('staff.mentors.title')+t('actions.updated')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mentor.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @mentor = Mentor.find(params[:id])
  end
  
  def destroy
    @mentor = Mentor.find(params[:id])
    @mentor.destroy

    respond_to do |format|
      format.html { redirect_to(staff_mentors_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
    def set_mentor
      @mentor = Mentor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mentor_params
      params.require(:mentor).permit(:staff_id, :mentor_date, :remark, :college_id, {:data => []}, mentees_attributes: [:id, :_destroy, :student_id, :mentor_id])
    end

end
