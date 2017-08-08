class EqueryReport::PersonalizetimetablesearchesController < ApplicationController
  filter_resource_access
    
  def new
    @searchpersonalizetimetabletype = params[:searchpersonalizetimetabletype]
    @personalizetimetablesearch = Personalizetimetablesearch.new
  end
  
  def create
    if @personalizetimetablesearch.save
      redirect_to equery_report_personalizetimetablesearch_path(@personalizetimetablesearch)
    else
      render :action => 'new'
    end
  end

  def show
    @personalizetimetablesearch = Personalizetimetablesearch.find(params[:id])
    arr=[]
    @personalizetimetablesearch.personalizetimetables.group_by{|x|[x.weeklytimetable.startdate]}.each do |wtid, pwts|
      arr << pwts
    end
    @personalizetimetables=Kaminari.paginate_array(arr).page(params[:page]||1) 
    #@personalizetimetables=@personalizetimetablesearch.personalizetimetables.page(params[:page]).per(2)
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def personalizetimetablesearch_params
      params.require(:personalizetimetablesearch).permit(:lecturer, :programme_id, :startdate, :enddate,  :college_id, [:data => {}])
    end
end
