class EqueryReport::StudentattendancesearchesController < ApplicationController
  filter_resource_access
  
  def new
      @studentattendancesearch = Studentattendancesearch.new
      @searchstudentattendancetype = params[:searchstudentattendancetype]
  end

  def create
      #raise params.inspect
      @searchstudentattendancetype = params[:method]
      if (@searchstudentattendancetype == '1' || @searchstudentattendancetype == 1)
          @studentattendancesearch = Studentattendancesearch.new(params[:studentattendancesearch])
      end
      if @studentattendancesearch.save
          redirect_to equery_report_studentattendansearch_path(@studentattendancesearch)
      else
          render :action => 'new'
      end
  end

  def show
    @studentattendancesearch = Studentattendancesearch.find(params[:id])
    @studentattendances=@studentattendancesearch.studentattendances.page(params[:page]).per(10)
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def studentattendancesearch_params
      params.require(:studentattendancesearch).permit(:schedule_id, :student_id, :intake_id, :course_id, :college_id, [:data => {}])
    end
    
end
