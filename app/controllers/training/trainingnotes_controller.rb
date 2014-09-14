 class Training:: TrainingnotesController < ApplicationController
   before_action :set_trainingnote, only: [:show, :edit, :update, :destroy]
  # GET /trainingnotes
  # GET /trainingnotes.xml
  def index
    #@trainingnotes = Trainingnote.all.order(:topicdetail_id)#:order => 'topic_id')
    
    @search = Trainingnote.search(params[:q])
    @trainingnotes2 = @search.result
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
        flash[:notice] = t('training.trainingnote.title')+t('actions.created')
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
        flash[:notice] =  t('training.trainingnote.title')+t('actions.updated')
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
  
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_trainingnote
      @trainingnote= Trainingnote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trainingnote_params
      params.require(:trainingnote).permit(:timetable_id, :title, :reference, :version, :staff_id, :release, :document, :topicdetail_id)
       #params.require(:trainingnote).permit(:timetable_id, :reference, :version, :staff_id, :release, :document_file_name, :document_content_type, :document_file_size, :document_updated_at, :topicdetail_id)
    end
end
