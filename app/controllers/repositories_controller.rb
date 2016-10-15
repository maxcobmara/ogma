class RepositoriesController < ApplicationController
  #filter_resource_access
  filter_access_to :index, :new, :create, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :download, :attribute_check => true
  before_action :set_repository, only: [:show, :edit, :update, :destroy, :download]

  # GET /repositories
  # GET /repositories.xml
  def index
    @search=Repository.search(params[:q])
    @repositories=@search.result.order(category: :asc)
    @repositories=@repositories.page(params[:page]||1)
    @exist_in_syst=Repository.where('title ILIKE(?) OR title ILIKE(?) OR title ILIKE(?) OR title ILIKE(?) OR title ILIKE(?) OR title ILIKE(?) ', '%penilaian diri untuk jurulatih%', '%PENILAIAN ANALISA SKOR PURATA JURULATIH%', '%PENILAIAN PENSYARAH%', '%DATA ANALISA SKOR PURATA PENILAIAN PENSYARAH%', '%KEDIAMAN ASRAMA%', '%MAKLUMAT PERIBADI%')
    @exist_in_syst+=Repository.where('title ILIKE (?) OR title ILIKE(?)', '%PENGGUNAAN PINJAMAN LATIHAN%', '%RANCANGAN LATIHAN MINGGUAN%')
    @access=[staff_instructor_appraisals_path, staff_average_instructors_path, exam_evaluate_courses_path, exam_evaluate_courses_path, student_tenants_path, students_path, asset_loans_path, training_weeklytimetables_path]
  end

  # GET /repositories/1
  # GET /repositories/1.xml
  def show
  end

  # GET /repositories/new
  # GET /repositories/new.xml
  def new
    @repository=Repository.new
  end

  # GET /repositories/1/edit
  def edit
    @repository=Repository.find(params[:id])
  end

  # POST /repositories
  # POST /repositories.xml
  def create
    @repository = Repository.new(repository_params)
    
    respond_to do |format|
      if @repository.save
        format.html { redirect_to @repository, notice: t('repositories.title')+t('actions.created')}
        format.json { render action: 'show', status: :created, location: @repository}
      else
        format.html { render action: 'new' }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /repositories/1
  # PUT /repositories/1.xml
  def update
    @repository=Repository.find(params[:id])
    respond_to do |format|
      if @repository.update(repository_params)
        format.html { redirect_to @repository, notice: t('repositories.title')+t('actions.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.xml
  def destroy
    @repository.destroy
    respond_to do |format|
      format.html { redirect_to repositories_url }
      format.json { head :no_content }
    end
  end

  def download
    #url=/assets/uploads/1/original/BK-KKM-01-01_BORANG_PENILAIAN_KURSUS.pdf?1474870599
    send_file("#{::Rails.root.to_s}/public#{@repository.uploaded.url.split("?").first}")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:id, :title, :staff_id, :category, :created_at, :updated_at, :uploaded, :uploaded_file_name, :uploaded_content_type, :uploaded_file_size, :uploaded_updated_at, :college_id, {:data => []})
    end
end
