class StudentsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  #filter_resource_access
  #filter_access_to :all
  # GET /students
  # GET /students.xml

  def index
    @search = Student.search(params[:q])
    @students = @search.result
    @students = @students.page(params[:page]||1)
    #@students_filtered = Student.find(:all, :order => sort_column + ' ' + sort_direction ,:conditions => ['formatted_mykad LIKE ? or name ILIKE ? ', "%#{params[:search]}%", "%#{params[:search]}%"])
  end

  # GET /students/1
  # GET /students/1.xml
  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erbS
      format.xml  { render :xml => @student }
    end
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
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        flash[:notice] = 'Student was successfully created.'
        format.html { redirect_to(@student) }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.xml
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        flash[:notice] = 'Student was successfully updated.'
        format.html { redirect_to(@student) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
    
    
    private
        # Use callbacks to share common setup or constraints between actions.
        def set_student
          @student = Student.find(params[:id])
        end

        # Never trust parameters from the scary internet, only allow the white list through.
        def student_params
          params.require(:student).permit(:formatted_mykad)
        end
    
        def sort_column
            Student.column_names.include?(params[:sort]) ? params[:sort] : "formatted_mykad" 
        end
    
        def sort_direction
            %w[asc desc].include?(params[:direction])? params[:direction] : "asc" 
        end
    end
  end




