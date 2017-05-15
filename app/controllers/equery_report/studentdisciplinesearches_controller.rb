class EqueryReport::StudentdisciplinesearchesController < ApplicationController
  
  filter_resource_access
  
  def new
    @searchstudentdisciplinetype = params[:searchstudentdisciplinetype]
    @studentdisciplinesearch = Studentdisciplinesearch.new
  end

  def create
    @searchstudentdisciplinetype = params[:method]
    if (@searchstudentdisciplinetype == '1' || @searchstudentdisciplinetype == 1)
        @studentdisciplinesearch = Studentdisciplinesearch.new(params[:studentdisciplinesearch])
    end
      if @studentdisciplinesearch.save
        redirect_to equery_report_studentdisciplinesearch_path(@studentdisciplinesearch)
      else
        render :action => 'new'
      end
   
  end

  def show
    @studentdisciplinesearch = Studentdisciplinesearch.find(params[:id])
    @studentdisciplines=@studentdisciplinesearch.studentdisciplines.page(params[:page]).per(10)
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def studentdisciplinesearch_params
      params.require(:studentdisciplinesearch).permit(:name, :programme, :intake, :matrixno, :icno, :college_id, [:data => {}])
    end
    
end
