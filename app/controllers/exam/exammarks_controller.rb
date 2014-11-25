class Exam::ExammarksController < ApplicationController
  filter_resource_access
  before_action :set_exammark, only: [:show, :edit, :update, :destroy]

  # GET /exammarks
  # GET /exammarks.xml
  def index
    @position_exist = @current_user.userable.positions
    if @position_exist  
      @lecturer_programme = @current_user.userable.positions[0].unit
      unless @lecturer_programme.nil?
        @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0)
      end
      unless @programme.nil? || @programme.count==0
        @programme_id = @programme.try(:first).try(:id)
      else
        if @lecturer_programme == 'Commonsubject'
          @programme_id ='1'
        else
          @programme_id='0'
        end
      end
      @search = Exammark.search(params[:q])
      @exammarks = @search.result.search2(@programme_id)
      @exammarks = @exammarks.page(params[:page]||1)
      @exammarks_group = @exammarks.group_by{|x|x.exam_id}
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @exammarks }
    end
  end

  # GET /exammarks/1
  # GET /exammarks/1.xml
  def show
    @exammark = Exammark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @exammark }
    end
  end
  
  private
   # Use callbacks to share common setup or constraints between actions.
    def set_exammark
      @exammark = Exammark.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def exammark_params
      params.require(:exammark).permit(:student_id, :exam_id, :total_mcq)
    end
end
