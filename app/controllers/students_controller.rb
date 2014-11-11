class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  #filter_resource_access
  #filter_access_to :all
  # GET /students
  # GET /students.xml

  def index
    @search = Student.search(params[:q])
    @students = @search.result
    @students = @students.page(params[:page]||1)  
  end
  
  def auto_complete
    @students = Student.order(:icno).where("icno like ?", "#{params[:term]}")
    render json: @students.map(&:icno)
  end

  # GET /students/1
  # GET /students/1.xml
  def show
  end


  # GET /students/new
  # GET /students/new.xml
  def new
    @student = Student.new
    @student.qualifications.build
    @student.kins.build
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
  end
  
  def formforstudent
     @student = Student.find(params[:id])  
     #@students = Student.search(params[:search])
     render :layout => 'report'
     #respond_to do |format|
         #format.html # index.html.erb  { render :action => "report.css" }
         #format.xml  { render :xml => @staffs }
     #end
  end

  def report  
    @students = Student.search(params[:all])
    @students = Student.find(:all)
    render :layout => 'report'
    
  end
 
  # POST /students
  # POST /students.xml
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'A new student was successfully created.' }
        format.json { render action: 'show', status: :created, location: @student }
      else
        format.html { render action: 'new' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.xml
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(student_params)
        flash[:notice] = 'Student was successfully updated.'
        format.html { redirect_to(@student) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def borang_maklumat_pelajar

    @student= Student.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Borang_maklumat_pelajarPdf.new(@student, view_context)
        send_data pdf.render, filename: "borang_maklumat_pelajar-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

    
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:address, :address_posbasik, :allergy, :bloodtype, :course_id, :course_remarks, :created_at, :disease, :end_training, :gender, :group_id, :icno, :id, :intake, :intake_id, :matrixno, :medication, :mrtlstatuscd, :name, :offer_letter_serial, :photo_content_type, :photo_file_name, :photo_file_size, :photo_updated_at, :physical, :race, :race2, :regdate, :remarks, :sbirthdt, :semail, :specialisation, :specilisation, :ssponsor, :sstatus, :stelno, :updated_at)
    end

    def sort_column
        Student.column_names.include?(params[:sort]) ? params[:sort] : "formatted_mykad" 
    end

    def sort_direction
        %w[asc desc].include?(params[:direction])? params[:direction] : "asc" 
    end
end




