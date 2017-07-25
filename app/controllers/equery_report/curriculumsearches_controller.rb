class EqueryReport::CurriculumsearchesController < ApplicationController
  filter_resource_access
  
  def new
    @searchcurriculumtype = params[:searchcurriculumtype]
    @curriculumsearch = Curriculumsearch.new
  end

#   def create
#     #raise params.inspect
#     @searchstudenttype = params[:method]
#     if (@searchstudenttype == '1' || @searchstudenttype == 1)
#         @studentsearch = Studentsearch.new(params[:studentsearch])
#     end
#     
#     if @studentsearch.save
#         redirect_to equery_report_studentsearch_path(@studentsearch)
#     else
#         render :action => 'new'
#     end
#   end
# 
#   def show
#     @studentsearch = Studentsearch.find(params[:id])
#     @students=@studentsearch.students.page(params[:page]).per(10)
#   end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def curriculumsearch_params
      params.require(:curriculumsearch).permit(:programme_id, :semester, :subject, :topic, :college_id, [:data => {}])
    end
end
