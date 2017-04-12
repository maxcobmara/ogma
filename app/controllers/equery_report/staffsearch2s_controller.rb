class EqueryReport::Staffsearch2sController < ApplicationController
  filter_resource_access
  before_action :set_staffsearch2, only: [:show]
  # GET /titles
  # GET /titles.xml
  
  def new
    @staffsearch2 = Staffsearch2.new
  end
  
  def create
    @staffsearch2 = Staffsearch2.new(staffsearch2_params)
    if @staffsearch2.save
      redirect_to equery_report_staffsearch2_path(@staffsearch2)
    else
      render :action => 'new'
    end
  end
  
  def show
    @staffsearch2 = Staffsearch2.find(params[:id])
  end

   private
   
   # Use callbacks to share common setup or constraints between actions.
    def set_staffsearch2
      @title = Title.find(params[:id])
    end

     # Never trust parameters from the scary internet, only allow the white list through.
     def staffsearch2_params
       params.require(:staffsearch2).permit(:keywords, :position, :staff_grade, :position2, :position3, :blank_post, :college_id, {:data => []})
     end
end
