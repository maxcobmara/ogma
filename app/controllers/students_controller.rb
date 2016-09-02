class StudentsController < ApplicationController
  #filter_access_to :all
  filter_access_to :index, :new, :create, :borang_maklumat_pelajar, :import_excel, :import, :download_excel_format, :report, :kumpulan_etnik, :kumpulan_etnik_main, :kumpulan_etnik_excel, :student_report, :students_quantity_sponsor, :students_quantity_report, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.xml

  def index
    #scope - student of college - based on current_user.college_id?
    @search = Student.where(college_id: current_user.college_id).search(params[:q])
    @students_all = @search.result.order(intake: :asc, course_id: :asc)
    @students = @students_all.page(params[:page]||1)
    respond_to do |format|
      format.html
      format.csv { send_data @students_all.to_csv2 }
      format.xls { send_data @students_all.to_csv2(col_sep: "\t") } 
    end
  end

  def auto_complete
    @students = Student.order(:icno).where("icno like ?", "#{params[:term]}")
    render json: @students.map(&:icno)
  end

  #start - import excel
  def import_excel
  end
  
  def import
    unless params[:file].nil? || params[:file].blank?
      
      a=Student.import(params[:file]) 
      msg=Student.messages(a)
      msg2=Student.messages2(a)      
      
      if a[:svs].count>0 && a[:ine].count==0 && a[:stnv].count==0 && a[:spnv].count==0
        respond_to do |format|
          flash[:notice]= msg
          format.html {redirect_to students_url}
        end
      else
        respond_to do |format|
          flash[:notice]= msg if a[:svs].count>0
          flash[:error] = msg2
          format.html { redirect_to import_excel_students_url}
          #flash.discard
        end
      end
      
    else
      respond_to do |format|
        format.html { redirect_to import_excel_students_url, :notice => (t 'select_excel_file')}
      end
    end
  end
  
  def download_excel_format
    send_file ("#{::Rails.root.to_s}/public/excel_format/student_import.xls")
  end
  
  def download_excel_format_amsas
    send_file ("#{::Rails.root.to_s}/public/excel_format/student_import_amsas.xls")
  end
  #end - import excel
  
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
        format.html { redirect_to @student, notice: (t 'student.title')+(t 'actions.created') }
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
        flash[:notice] = (t 'student.title')+(t 'actions.updated')
        format.html { redirect_to(@student) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def kumpulan_etnik_main
    commit = params[:list_submit_button]
    programme_id = params[:programme]
    if commit == t('actions.print')
      redirect_to  kumpulan_etnik_students_path(:format => 'pdf', :programme => programme_id)
    elsif commit == t('actions.export_excel')
      redirect_to  kumpulan_etnik_excel_students_path(:format => 'xls', :programme => programme_id)
    end
  end

  def kumpulan_etnik
    @programme_id = params[:programme].to_i
    students_all_6intakes = Student.get_student_by_6intake(@programme_id)
    @students_6intakes_ids = students_all_6intakes.map(&:id)
    students_all_6intakes_count = students_all_6intakes.count
    @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',@programme_id, @students_6intakes_ids)
    @student = Student.all
    @preparedby=current_user.userable
    respond_to do |format|
      format.pdf do
        pdf = Kumpulan_etnikPdf.new(@student, view_context, @programme_id, @students_6intakes_ids, @valid, @preparedby)
        send_data pdf.render, filename: "kumpulan_etnik-{Date.today}",
        type: "application/pdf",
        disposition: "inline"
      end
    end
  end
  
  def kumpulan_etnik_excel
    @programme_id = params[:programme].to_i
    @student=Student.where(course_id: @programme_id)
    respond_to do |format|
      #format.html
      format.csv { send_data @student.to_csv }
      format.xls { send_data @student.to_csv(col_sep: "\t") } 
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to(students_url) }
      format.xml  { head :ok }
    end
  end

  def borang_maklumat_pelajar
    @student= Student.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Borang_maklumat_pelajarPdf.new(@student, view_context, current_user.college)
        send_data pdf.render, filename: "borang_maklumat_pelajar-{Date.today}",
        type: "application/pdf",
        disposition: "inline"
      end
    end
  end

  def reports
  end
  
  def student_report
    @programme_id=params[:programme_id].to_i
    if current_user.college.code=="kskbjb"
      @students = Student.where(sstatus: ['Current', 'Repeat'], course_id: @programme_id).order(intake: :asc, course_id: :asc)
    else
      @students=Student.where(course_id: @programme_id).order(intake: :asc, course_id: :asc) #.where(college_id: current_user.college.id)
    end
    respond_to do |format|
      format.pdf do
        pdf = Student_reportPdf.new(@students, view_context, @programme_id, current_user.college)
        send_data pdf.render, filename: "student-list-{Date.today}",
        type: "application/pdf",
        disposition: "inline"
      end
    end
  end
  
  def students_quantity_sponsor
    @students_kkm=Student.where(sstatus: ['Current', 'Repeat'], ssponsor: "KKM")
    @students_kkm_male=Student.where(sstatus: ['Current', 'Repeat'], gender: 1, ssponsor: "KKM")
    @students_kkm_female=Student.where(sstatus: ['Current', 'Repeat'], gender: 2, ssponsor: "KKM")
    @students_spa=Student.where(sstatus: ['Current', 'Repeat'], ssponsor: "SPA")
    @students_spa_male=Student.where(sstatus: ['Current', 'Repeat'], gender: 1, ssponsor: "SPA")
    @students_spa_female=Student.where(sstatus: ['Current', 'Repeat'], gender: 2, ssponsor: "SPA")
    @students_swasta=Student.where(sstatus: ['Current', 'Repeat'], ssponsor: "swasta")
    @students_swasta_male=Student.where(sstatus: ['Current', 'Repeat'], gender: 1, ssponsor: "swasta")
    @students_swasta_female=Student.where(sstatus: ['Current', 'Repeat'], gender: 2, ssponsor: "swasta")
    @students_sendiri=Student.where(sstatus: ['Current', 'Repeat'], ssponsor: "FaMa")
    @students_sendiri_male=Student.where(sstatus: ['Current', 'Repeat'], gender: 1, ssponsor: "FaMa")
    @students_sendiri_female=Student.where(sstatus: ['Current', 'Repeat'], gender: 2, ssponsor: "FaMa")
    @programmes=Programme.roots
    @students=Student.where(sstatus: ['Current', 'Repeat'])
    @preparedby=current_user.userable
    respond_to do |format|
      format.pdf do
        pdf = Students_quantity_sponsorPdf.new(@students_kkm, @students_kkm_male, @students_kkm_female, @students_spa, @students_spa_male, @students_spa_female, @students_swasta, @students_swasta_male, @students_swasta_female, @students_sendiri, @students_sendiri_male, @students_sendiri_female, @programmes, @students, @preparedby, view_context)
        send_data pdf.render, filename: "student-list-{Date.today}",
        type: "application/pdf",
        disposition: "inline"
      end
    end
  end
  
  def students_quantity_report
    @programmes=Programme.roots
    @students = Student.where(sstatus: ['Current', 'Repeat'])
    respond_to do |format|
      format.pdf do
        pdf = Students_quantity_reportPdf.new(@programmes, @students, view_context)
        send_data pdf.render, filename: "student-list-{Date.today}",
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
      params.require(:student).permit(:address, :address_posbasik, :allergy, :bloodtype, :course_id, :course_remarks, :created_at, :disease, :end_training, :gender, :group_id, :icno, :id, :intake, :intake_id, :matrixno, :medication, :mrtlstatuscd, :name, :offer_letter_serial, :photo, :photo_content_type, :photo_file_name, :photo_file_size, :photo_updated_at, :physical, :race, :race2, :regdate, :remarks, :sbirthdt, :semail, :specialisation, :specilisation, :ssponsor, :sstatus, :stelno, :updated_at, :sstatus_remark, :position, :department, :vehicle_no, :vehicle_type, :college_id, {:data=>[]}, :rank_id, kins_attributes: [:id,:_destroy, :kintype_id,  :name, :mykadno, :phone, :profession, :kinaddr], qualifications_attributes:[:id,:_destroy, :level_id, :qname, :institute], spmresults_attributes: [:id, :_destroy, :spm_subject, :grade])
    end

    def sort_column
        Student.column_names.include?(params[:sort]) ? params[:sort] : "formatted_mykad"
    end

    def sort_direction
        %w[asc desc].include?(params[:direction])? params[:direction] : "asc"
    end
end
