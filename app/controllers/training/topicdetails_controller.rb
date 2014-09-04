class Training::TopicdetailsController < ApplicationController
  # GET /topicdetails
  # GET /topicdetails.xml
  def index 
    #@topicdetails = Topicdetail.all.order(updated_at: :desc)
    #@topicdetails2 = Topicdetail.where('topic_code IS NULL')    
    @search =Topicdetail.search(params[:q])
    @topicdetails = @search.result
    @topicdetails = @topicdetails.where('topic_code IN(?)',Programme.all.pluck(:id)).sort_by{|x|x.subject_topic.parent_id}
    @topicdetails = Kaminari.paginate_array(@topicdetails).page(params[:page]||1)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topicdetails }
    end
  end

  # GET /topicdetails/1
  # GET /topicdetails/1.xml
  def show
    @topicdetail = Topicdetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topicdetail }
    end
  end

  # GET /topicdetails/new
  # GET /topicdetails/new.xml
  def new
    @topicdetail = Topicdetail.new
    @lecturer_programme = current_user.staff.position.unit
    unless @lecturer_programme.nil?
      @programme = Programme.find(:first,:conditions=>['name ILIKE (?) AND ancestry_depth=?',"%#{@lecturer_programme}%",0])
    end
    unless @programme.nil?
      @programme_id = @programme.id 
      @topic_programme = Programme.find(@programme_id).descendants.at_depth(3)
      @subtopic_programme = Programme.find(@programme_id).descendants.at_depth(4)
      @topic_subtopic = @topic_programme + @subtopic_programme
      @semester_subject_topic_list = Programme.find(:all,:conditions=>['id IN(?) AND id NOT IN(?)',@topic_subtopic, Topicdetail.all.map(&:topic_code).compact.uniq], :order=>:combo_code)
    else
      @semester_subject_topic_list = Programme.find(:all,:conditions=>['ancestry_depth=? OR ancestry_depth=?',3,4], :order=>:combo_code)
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topicdetail }
    end
  end

  # GET /topicdetails/1/edit
  def edit
    @topicdetail = Topicdetail.find(params[:id])
  end

  # POST /topicdetails
  # POST /topicdetails.xml
  def create
    @topicdetail = Topicdetail.new(topicdetail_params)

    respond_to do |format|
      if @topicdetail.save
        format.html { redirect_to(training_topicdetail_path(@topicdetail), :notice => t('training.topicdetail.title')+t('actions.created')) }
        format.xml  { render :xml => @topicdetail, :status => :created, :location => @topicdetail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topicdetail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topicdetails/1
  # PUT /topicdetails/1.xml
  def update
    @topicdetail = Topicdetail.find(params[:id])

    respond_to do |format|
      if @topicdetail.update(topicdetail_params)
        format.html { redirect_to(training_topicdetail_url, :notice => t('training.topicdetail.title')+t('actions.created')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topicdetail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topicdetails/1
  # DELETE /topicdetails/1.xml
  def destroy
    @topicdetail = Topicdetail.find(params[:id])
    @topicdetail.destroy

    respond_to do |format|
      format.html { redirect_to(training_topicdetails_url) }
      format.xml  { head :ok }
    end
  end
  
   
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topicdetail
      @topicdetail = Topicdetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topicdetail_params
      params.require(:topicdetail).permit(:topic_name, :topic_code, :duration, :version_no, :objctives, :contents, :theory, :tutorial, :practical, :prepared_by)
    end
    
end
