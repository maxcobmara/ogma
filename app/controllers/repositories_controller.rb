class RepositoriesController < ApplicationController
  #filter_resource_access
  filter_access_to :index, :new, :create, :index2, :new2, :repository_list, :repository_list2, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :download, :attribute_check => true
  before_action :set_repository, only: [:show, :edit, :update, :destroy, :download]
  before_action :set_repositories, only: [:index2, :repository_list2]

  # GET /repositories
  # GET /repositories.xml
  def index
    @search=Repository.where.not(category: nil).search(params[:q])
    @repositories=@search.result.order(category: :asc)
    @repositories=@repositories.page(params[:page]||1)
    @exist_in_syst=Repository.where('title ILIKE(?) OR title ILIKE(?) OR title ILIKE(?) OR title ILIKE(?) OR title ILIKE(?) OR title ILIKE(?) ', '%penilaian diri untuk jurulatih%', '%PENILAIAN ANALISA SKOR PURATA JURULATIH%', '%PENILAIAN PENSYARAH%', '%DATA ANALISA SKOR PURATA PENILAIAN PENSYARAH%', '%KEDIAMAN ASRAMA%', '%MAKLUMAT PERIBADI%')
    @exist_in_syst+=Repository.where('title ILIKE (?) OR title ILIKE(?)', '%PENGGUNAAN PINJAMAN LATIHAN%', '%RANCANGAN LATIHAN MINGGUAN%')
    @access=[staff_instructor_appraisals_path, staff_average_instructors_path, exam_evaluate_courses_path, exam_evaluate_courses_path, student_tenants_path, students_path, asset_loans_path, training_weeklytimetables_path]
  end
  
#   def index2_old
#     @search=Repository.digital_library.search(params[:q])
#     @repositories=@search.result.sort_by{|x|[x.vessel_class, x.document_type, x.document_subtype]}
#     @repositories=Kaminari.paginate_array(@repositories).page(params[:page]).per(20)  #page(params[:page]||1)  
#   end
  
  def index2
    @repositories=Kaminari.paginate_array(@repos).page(params[:page]).per(20)  
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
  
  def new2
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
        doc_title=@repository.data.blank? ? (t 'repositories.title') : (t 'repositories.title2')
        format.html { redirect_to @repository, notice: doc_title+t('actions.created')}
        format.json { render action: 'show', status: :created, location: @repository}
      else

        # NOTE - 20Apr2017 - workaround - to retrieve missing uploaded file when validation fails!  - start ####
        unless params[:repository][:uploaded].blank?                 # File field (uploaded) contains data (submission done with file SELECTION)
          upload_cache = AttachmentUploader.new                      # 1st submission -> save data in AttachmentUploader & set value for 'uploadcache' field
          upload_cache.data = repository_params[:uploaded]      # subsequent submission -> use 'uploadcache' field in form.
          if upload_cache.valid?
            upload_cache.msgnotification_id=0
            upload_cache.upload_for="repository"
            upload_cache.save
          end
          @aa=upload_cache.id
        end
        ######## - workaround ends here - NOTE - to refer model/attachment_uploader.rb & repository.rb, plus repositories/_form

        if @repository.data.blank?
          format.html { render action: 'new' }
          format.json { render json: @repository.errors, status: :unprocessable_entity }
        else
          format.html { render action: 'new2'}
        end

      end
    end
  end

  # PUT /repositories/1
  # PUT /repositories/1.xml
  def update
    @repository=Repository.find(params[:id])
    respond_to do |format|
      if @repository.update(repository_params)
        doc_title=@repository.data.blank? ? (t 'repositories.title') : (t 'repositories.title2')
        format.html { redirect_to @repository, notice: doc_title+t('actions.updated') }
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
    respond_to do |format|
      if @repository.data.blank?
        @repository.destroy
        format.html { redirect_to repositories_url }
      else
        @repository.destroy
        format.html { redirect_to index2_repositories_url }
      end
      format.json { head :no_content }
    end
  end

  def download
    #url=/assets/uploads/1/original/BK-KKM-01-01_BORANG_PENILAIAN_KURSUS.pdf?1474870599
    send_file("#{::Rails.root.to_s}/public#{@repository.uploaded.url.split("?").first}")
  end
  
  
  def repository_list
    @search = Repository.where.not(category: nil).search(params[:q])
    @repositories = @search.result
    respond_to do |format|
      format.pdf do
        pdf = Repository_listPdf.new(@repositories, view_context, current_user.college)
        send_data pdf.render, filename: "repository_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  def repository_list2
    @repositories=@repos
    #unremark below for pagination, otherwise use above
    #@repositories=Kaminari.paginate_array(@repos).page(params[:page]).per(20)  
    respond_to do |format|
      format.pdf do
        pdf = Repository_list2Pdf.new(@repositories, view_context, current_user.college, @per_vessel, @per_vessel_count_arr2)
        send_data pdf.render, filename: "repository_list2-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  def loan 
    @librarytransaction=Librarytransaction.new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end
    
    def set_repositories
      if params[:ids]
        @actual_records=Repository.digital_library.where(id: params[:ids])
        vessel_class_name=[]
        @per_vessel.each{ |vess| vessel_class_name << vess[0]}
      else
        @search=Repository.digital_library.search(params[:q])
        @actual_records=@search.result
        unless @search.vessel_search.blank?
          vessel_class_name=[@search.vessel_search]
        else
          vessel_class_name=Repository.vessel_class_names
          # [ ['KD Jebat', 'KD Lekiu'], ['KD Kasturi', 'KD Lekir'], ['KD Pahang', 'KD Kelantan', 'KD Selangor', 'KD Terengganu', 'KD Kedah','KD Perak'],['KD Mahawangsa'],['KLD Tunas Samudera', 'KD Perantau']]
        end
      end

      @repos=[]
      @rep=[]
      @per_vessel=Hash.new
      @actual_records.group_by{|x|x.vessel_class}.sort.each do |vessel_class, mrepositories|
        unless @search.vessel_search.blank?
          current_vessel_list=vessel_class_name
        else
          current_vessel_list=vessel_class_name[vessel_class.to_i-1]
        end
        per_vessel=Hash[current_vessel_list.map{|x|[x, Hash["master" => [], "specific" =>[] ]]}]        #per_vessel== list of vessel of each VESSEL CLASS
        for a_vessel in current_vessel_list
          spec_arr=[]
          master_arr=[]
          for repository in mrepositories
            unless repository.vessel.blank? #specific
              spec_arr << repository.id if repository.render_vessel==a_vessel
            else #master
              master_arr << repository.id
            end
          end
          per_vessel[a_vessel]["specific"]=spec_arr
          per_vessel[a_vessel]["master"]=master_arr

          @per_vessel=@per_vessel.merge(per_vessel)
        end
        per_vessel.each do |one_vessel, repo_by_cls|
          repo_by_cls.each do |repo_cls|
            @rep << repo_cls[1] 
            @repos +=Repository.where(id: repo_cls[1]).sort_by{|x|[x.document_type, x.document_subtype, x.title, x.refno]} #sort first
          end
        end
      end
    
      #@repositories=Kaminari.paginate_array(@repos).page(params[:page]).per(20)  
      ####
      per_vessel_count2=0
      per_vessel_count_arr=[]
      @per_vessel_count_arr=[]
      @per_vessel_count_arr2=[0]
      @per_vessel.each do |vess, repo_sets|
        per_vessel_count=0
        repo_sets.each do |repo_set|
          per_vessel_count+= repo_set[1].count
          per_vessel_count2+= repo_set[1].count
        end 
        @per_vessel_count_arr << per_vessel_count
        @per_vessel_count_arr2 << per_vessel_count2
      end
      ####
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:id, :title, :staff_id, :category, :created_at, :updated_at, :uploaded, :uploaded_file_name, :uploaded_content_type, :uploaded_file_size, :uploadcache, :uploaded_updated_at, :vessel, :document_type, :document_subtype, :refno, :publish_date, :total_pages, :copies, :location, :classification, :vessel_class, :code, :college_id, {:data => []})
    end
end
