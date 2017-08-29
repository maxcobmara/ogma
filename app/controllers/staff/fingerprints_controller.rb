class Staff::FingerprintsController < ApplicationController
  filter_access_to :index, :index_admin, :index_admin_list, :new, :create, :attribute_check => false
  filter_access_to :show, :edit, :update, :approval, :destroy, :attribute_check => true
  before_action :set_fingerprint, only: [:show, :edit, :update, :destroy]
  before_action :set_index_admin, only: [:index_admin, :index_admin_list]
  
  def index
    @fingerprint = Fingerprint.new
    @fingerprints = Fingerprint.find_mystatement(current_user.userable.thumb_id)
    @approvefingerprints = Fingerprint.find_approvestatement(current_user)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fingerprints }
    end
  end
  
  def index_admin
    @fingerprints = @fingerprints.page(params[:page]||1)
  end
  
  def show
    @fingerprint = Fingerprint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fingerprint }
    end
  end

  # GET /fingerprints/new
  # GET /fingerprints/new.xml
  def new
    @finger_date=params[:finger_date]
    @fingerprint = Fingerprint.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fingerprint }
    end
  end

  # GET /fingerprints/1/edit
  def edit
    @fingerprint = Fingerprint.find(params[:id])
  end

  # POST /fingerprints
  # POST /fingerprints.xml
  def create
    #raise params.inspect
    @fingerprint = Fingerprint.new(fingerprint_params)

    respond_to do |format|
      if @fingerprint.save
        format.html {redirect_to(edit_staff_fingerprint_path(@fingerprint))}
        format.xml  { render :xml => @fingerprint, :status => :created, :location => @fingerprint }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fingerprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /fingerprints/1
  # PUT /fingerprints/1.xml
  def update
    @fingerprint = Fingerprint.find(params[:id])

    respond_to do |format|
      if @fingerprint.update(fingerprint_params)
        format.html { redirect_to(staff_fingerprint_path(@fingerprint, :ftype2 => @fingerprint.type_val(current_user)), :notice => (t 'fingerprint.title')+(t 'actions.updated'))}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fingerprint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /fingerprints/1
  # DELETE /fingerprints/1.xml
  def destroy
    @fingerprint = Fingerprint.find(params[:id])
    respond_to do |format|
      if @fingerprint.destroy
        format.html {redirect_to(staff_fingerprints_url, :notice =>(t 'fingerprint.title')+(t 'actions.removed'))}
        format.xml  { head :ok }
      else
        format.html { redirect_to(staff_fingerprint_path(@fingerprint))}
        format.xml  { head :ok }
      end
    end
  end
  
  def approval
    @fingerprint = Fingerprint.find(params[:id])
  end
  
  def index_admin_list
    respond_to do |format|
      format.pdf do
        pdf = Index_admin_listPdf.new(@fingerprints, view_context, current_user.college)
        send_data pdf.render, filename: "fingerprint_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fingerprint
      @fingerprint = Fingerprint.find(params[:id])
    end
    
    def set_index_admin
      @search = Fingerprint.search(params[:q])
      @fingerprints = @search.result
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fingerprint_params
      params.require(:fingerprint).permit(:thumb_id, :fdate, :ftype, :reason, :approved_by, :is_approved, :approved_on, :status)
    end
end