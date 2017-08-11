class EqueryReport::ExamsearchesController < ApplicationController
   filter_resource_access
  
  def new
    @examsearch = Examsearch.new
  end
  
  def create
    if @examsearch.save
        redirect_to equery_report_examsearch_path(@examsearch)
    else
        render :action => 'new'
    end
  end

  def show
    @examsearch = Examsearch.find(params[:id])
    @exams=@examsearch.exams.page(params[:page]).per(10)
  end
   
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def examsearch_params
      params.require(:examsearch).permit(:programme_id, :subject_id, :examtype, :created_by, :klass_id, :examdate, :valid_papertype, :programme_details, :college_id, [:data => {}])
    end
end
