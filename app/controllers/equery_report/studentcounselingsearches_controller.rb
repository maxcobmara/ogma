class EqueryReport::StudentcounselingsearchesController < ApplicationController
  filter_resource_access
  
  def new
    @studentcounselingsearch = Studentcounselingsearch.new
    @searchstudentcounselingtype = params[:searchstudentcounselingtype]
  end

  def create
    @searchstudentcounselingtype = params[:method]
    if (@searchstudentcounselingtype == '1' || @searchstudentcounselingtype == 1)
      @studentcounselingsearch = Studentcounselingsearch.new(params[:studentcounselingsearch])
    end
    if @studentcounselingsearch.save
      redirect_to equery_report_studentcounselingsearch_path(@studentcounselingsearch)
    else
      render :action => 'new'
    end
  end

  def show
    @studentcounselingsearch = Studentcounselingsearch.find(params[:id])
    @studentcounselings=@studentcounselingsearch.studentcounselings.page(params[:page]).per(10)
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def studentcounselingsearch_params
      params.require(:studentcounselingsearch).permit(:matrixno, :case_id, :confirmed_at_start, :confirmed_at_end, :is_confirmed, :name, :college_id, [:data => {}])
    end
    
end
