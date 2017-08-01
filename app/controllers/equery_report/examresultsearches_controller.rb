class ExamresultsearchesController < ApplicationController
   filter_resource_access
  
  def new
    @searchexamresulttype = params[:searchexamresulttype]
    @examresultsearch = Examresultsearch.new
  end
  
  def create
    if @examresultsearch.save
        redirect_to equery_report_examresultsearch_path(@examresultsearch)
    else
        render :action => 'new'
    end
  end

  def show
    @examresultsearch = Examresultsearch.find(params[:id])
    @examresults=@examresultsearch.examresults#.page(params[:page]).per(10)
  end
   
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def examresultsearch_params
      params.require(:examresultsearch).permit(:programme_id, :subject_id, :student_id, :semester, :examdts, :examdte, :college_id, [:data => {}])
    end
end
