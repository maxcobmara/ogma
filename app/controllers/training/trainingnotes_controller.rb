 class Training:: TrainingnotesController < ApplicationController
   #filter_resource_access
   filter_access_to :index, :new, :create, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :download, :attribute_check => true
   before_action :set_trainingnote, only: [:show, :edit, :update, :destroy, :download]
   before_action :set_data_index_new_edit, only: [:index, :new, :edit, :create, :update] #create & update - if validations failed
   before_action :set_data_new_edit, only: [:new, :edit, :create, :update]

  # GET /trainingnotes
  # GET /trainingnotes.xml
  def index    
    @search = Trainingnote.search(params[:q])
    @trainingnotes2 = @search.result.search2(@programme_id)
    #@trainingnotes3 = @trainingnotes2.order(:topicdetail_id)
                
    by_subject  =@trainingnotes2.where('topicdetail_id is not null').group_by{|x|x.topicdetail.subject_topic}  
    arr_w_topic=[]
    by_subject.each do |tns|
      arr_w_topic<< tns
    end
    wo_topic = @trainingnotes2.where('topicdetail_id is null')
    combine = arr_w_topic+wo_topic
    @trainingnotes_lala = Kaminari.paginate_array(combine).page(params[:page]||1) 
    #@trainingnotes =  Kaminari.paginate_array(@trainingnotes3).page(params[:page]||1) 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trainingnotes }
    end
  end

  # GET /trainingnotes/1
  # GET /trainingnotes/1.xml
  def show
    @trainingnote = Trainingnote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trainingnote }
    end
  end

  # GET /trainingnotes/new
  # GET /trainingnotes/new.xml
  def new
    @trainingnote = Trainingnote.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trainingnote }
    end
  end

  # GET /trainingnotes/1/edit
  def edit
    @trainingnote = Trainingnote.find(params[:id])
  end

  # POST /trainingnotes
  # POST /trainingnotes.xml
  def create
    @trainingnote = Trainingnote.new(trainingnote_params)

    respond_to do |format|
      if @trainingnote.save
        flash[:notice] = t('training.trainingnote.title2')+t('actions.created')
        format.html { redirect_to training_trainingnote_path(@trainingnote) }
        format.xml  { render :xml => @trainingnote, :status => :created, :location => @trainingnote }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trainingnote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trainingnotes/1
  # PUT /trainingnotes/1.xml
  def update
    @trainingnote = Trainingnote.find(params[:id])

    respond_to do |format|
      if @trainingnote.update(trainingnote_params)
        flash[:notice] =  t('training.trainingnote.title2')+t('actions.updated')
        format.html { redirect_to training_trainingnote_path(@trainingnote) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trainingnote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trainingnotes/1
  # DELETE /trainingnotes/1.xml
  def destroy
    @trainingnote = Trainingnote.find(params[:id])
    @trainingnote.destroy

    respond_to do |format|
      format.html { redirect_to(training_trainingnotes_url) }
      format.xml  { head :ok }
    end
  end
  
  def download
    #url=/assets/notes/1/original/BK-KKM-01-01_BORANG_PENILAIAN_KURSUS.pdf?1474870599
    send_file("#{::Rails.root.to_s}/public#{@trainingnote.document.url.split("?").first}")
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trainingnote
      @trainingnote= Trainingnote.find(params[:id])
    end
    
    #set programme
    def set_data_index_new_edit
      @position_exist = @current_user.userable.positions
      if @position_exist     
        @lecturer_programme = @current_user.userable.positions.first.unit
        unless @lecturer_programme.nil? 
          @programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0).first
        end
        unless @programme.nil?
          @programme_id = @programme.id
        else
          if @lecturer_programme != 'Pos Basik' && @position_exist.first.name=='Pengajar' #== 'Commonsubject' 
            @programme_id = '1'
          else
            @programme_id = '0'
          end
        end
      end 
    end
    
    #set appropiate data
    def set_data_new_edit
      if @programme_id == '1' #common_subject
        commonsubject_ids= Programme.where(course_type: "Commonsubject").pluck(:id)
        topicids_of_commonsubject = []
        for commons_id in commonsubject_ids
          topicids_of_commonsubject +=Programme.where(id:commons_id).first.descendants.pluck(:id)
        end
        @topicids_of_programme =  topicids_of_commonsubject 
      elsif @programme_id =='0' #admin
        @topicids_of_programme = Programme.where('course_type=? or course_type=?', "Topic", "Subtopic").pluck(:id)
      else
        @topicids_of_programme = Programme.where(id: @programme_id).first.descendants.where('course_type=? or course_type=?', "Topic", "Subtopic").pluck(:id)
      end
      @semester_subject_topic_list_bytopicdetail = Topicdetail.joins(:subject_topic).where('(course_type=? OR course_type=?) AND topic_code IN(?)', "Topic", "Subtopic", @topicids_of_programme).sort_by{|x| x.subject_topic.combo_code}
                  
      user_w_adminrole =Role.joins(:users).where(id:2).pluck(:user_id)
      @staff_w_adminrole=User.where('id IN(?)', user_w_adminrole).pluck(:userable_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trainingnote_params
      params.require(:trainingnote).permit(:timetable_id, :title, :reference, :version, :staff_id, :release, :document, :topicdetail_id)
       #params.require(:trainingnote).permit(:timetable_id, :reference, :version, :staff_id, :release, :document_file_name, :document_content_type, :document_file_size, :document_updated_at, :topicdetail_id)
    end
end
