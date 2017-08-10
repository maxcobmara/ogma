class EqueryReport::CurriculumsearchesController < ApplicationController
  filter_resource_access
  
  def new
    @curriculumsearch = Curriculumsearch.new
  end
  
  def create
    if @curriculumsearch.save
        redirect_to equery_report_curriculumsearch_path(@curriculumsearch)
    else
        render :action => 'new'
    end
  end

  def show
    @curriculumsearch = Curriculumsearch.find(params[:id])
    @curriculums=@curriculumsearch.curriculums
  end
   
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def curriculumsearch_params
      params.require(:curriculumsearch).permit(:programme_id, :semester, :subject, :topic, :college_id, [:data => {}])
    end
end
