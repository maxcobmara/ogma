class EqueryReport::StudentdisciplinesearchesController < ApplicationController
  
  filter_resource_access
  
  def new
    @searchstudentdisciplinetype = params[:searchstudentdisciplinetype]
    @studentdisciplinesearch = Studentdisciplinesearch.new
  end

  def create
    #raise params.inspect
    @searchstudentdisciplinetype = params[:method]
    if (@searchstudentdisciplinetype == '1' || @searchstudentdisciplinetype == 1)
        @studentdisciplinesearch = Studentdisciplinesearch.new(params[:studentdisciplinesearch])
#         @aa=params[:intake][:"(1i)"] 
#         @bb=params[:intake][:"(2i)"]
#         @cc=params[:intake][:"(3i)"]
#         if @aa!='' && @bb!='' #&& @cc!=''
#             @dadidu=@aa+'-'+@bb+'-'+'01' 
#         else
#             @dadidu=''
#         end
        #@studentdisciplinesearch.intake = params[:intake]#@dadidu
    end
    if @studentdisciplinesearch.save
      #flash[:notice] = "Successfully created studentdisciplinesearch."
      redirect_to equery_report_studentdisciplinesearch_path(@studentdisciplinesearch)
    else
      render :action => 'new'
    end
  end
  
#   def view_intake
#     @programme_id = params[:programmeid]
#     a=StudentDisciplineCase.all.map(&:student_id)
#     @intakes = Student.find(:all, :conditions => ['course_id=? and id IN(?)', @programme_id, a], :order => 'intake ASC', :select => 'distinct intake, course_id')
#     
#     render :partial => 'view_intake', :layout => false
#   end

  def show
    @studentdisciplinesearch = Studentdisciplinesearch.find(params[:id])
    @studentdisciplines=@studentdisciplinesearch.studentdisciplines.page(params[:page]).per(10)
    #render :layout => 'report'
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def studentdisciplinesearch_params
      params.require(:studentdisciplinesearch).permit(:name, :programme, :intake, :matrixno, :icno, :college_id, [:data => {}])
    end
    
end
