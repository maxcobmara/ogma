class EqueryReport::StaffattendancesearchesController < ApplicationController
  filter_resource_access
  
  def new
    @searchstaffattendancetype = params[:searchattendancetype]
    @staffattendancesearch = Staffattendancesearch.new
  end

  def create
    @staffattendancesearch = Staffattendancesearch.new(params[:staffattendancesearch])
    if !@staffattendancesearch.department.blank? && !@staffattendancesearch.thumb_id.blank? && !@staffattendancesearch.logged_at.blank?
      if @staffattendancesearch.save
        redirect_to equery_report_staffattendancesearch_path(@staffattendancesearch)
      else
        render :action => 'new'
      end
    else
      flash[:notice] = t('equery.staffattendance.select_all_fields')
      redirect_to new_equery_report_staffattendancesearch_path(@staffattendancesearch,  :searchattendancetype =>1)
    end
  end
 
  def show
    @staffattendancesearch = Staffattendancesearch.find(params[:id])
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def staffattendancesearch_params
      params.require(:staffattendancesearch).permit(:department, :thumb_id, :logged_at, :college_id, [:data => {}])
    end
 
end