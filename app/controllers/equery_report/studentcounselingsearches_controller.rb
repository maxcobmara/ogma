class EqueryReport::StudentcounselingsearchesController < ApplicationController
  filter_resource_access
  
  def new
    @studentcounselingsearch = Studentcounselingsearch.new
  end

  def create
    @studentcounselingsearch = Studentcounselingsearch.new(params[:studentcounselingsearch])
    if @studentcounselingsearch.save
      redirect_to equery_report_studentcounselingsearch_path(@studentcounselingsearch)
    else
      render :action => 'new'
    end
  end

  def show
    @studentcounselingsearch = Studentcounselingsearch.find(params[:id])
    @studentcounselings=@studentcounselingsearch.studentcounselings#.page(params[:page]).per(10)
    counselings_bycase=[]
    @studentcounselingsearch.studentcounselings.group_by(&:case_id).each do |caseid, counselings|
      counselings_bycase << caseid
    end
    @bycases=Kaminari.paginate_array(counselings_bycase).page(params[:page]).per(5)
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def studentcounselingsearch_params
      params.require(:studentcounselingsearch).permit(:matrixno, :case_id, :confirmed_at_start, :confirmed_at_end, :is_confirmed, :name, :college_id, [:data => {}])
    end
    
end
