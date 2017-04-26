class EqueryReport::StudentsearchesController < ApplicationController
  filter_resource_access
  
  def new
    @searchstudenttype = params[:searchstudenttype]
    @studentsearch = Studentsearch.new
  end

  def create
    #raise params.inspect
    @searchstudenttype = params[:method]
    if (@searchstudenttype == '1' || @searchstudenttype == 1)
        @studentsearch = Studentsearch.new(params[:studentsearch])
    end
    
    if @studentsearch.save
        redirect_to equery_report_studentsearch_path(@studentsearch)
    else
        render :action => 'new'
    end
  end

  def show
    @studentsearch = Studentsearch.find(params[:id])
    @students=@studentsearch.students.page(params[:page]).per(10)
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def studentsearch_params
      params.require(:studentsearch).permit(:icno, :name, :matrixno, :ssponsor, :mrtlstatuscd, :course_id, :physical, :end_training, :intake, :gender, :race, :bloodtype, :sstatus, :end_training2, :college_id, [:data => {}])
    end
    
end
