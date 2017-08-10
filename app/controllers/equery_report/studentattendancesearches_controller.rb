class EqueryReport::StudentattendancesearchesController < ApplicationController
  filter_resource_access
  
  def new
    @studentattendancesearch = Studentattendancesearch.new
  end

  def create
    @studentattendancesearch = Studentattendancesearch.new(params[:studentattendancesearch])
    if @studentattendancesearch.save
      redirect_to equery_report_studentattendancesearch_path(@studentattendancesearch)
    else
      render :action => 'new'
    end
  end

  def show
    @studentattendancesearch = Studentattendancesearch.find(params[:id])
    @studentattendances=@studentattendancesearch.studentattendances.page(params[:page]).per(30)
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def studentattendancesearch_params
      params.require(:studentattendancesearch).permit(:schedule_id, :student_id, :intake_id, :course_id, :college_id, [:data => {}])
    end
    
end
