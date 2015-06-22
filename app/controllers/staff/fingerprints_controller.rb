class Staff::FingerprintsController < ApplicationController
  before_action :set_fingerprint, only: [:show, :edit, :update, :destroy]

  #filter_resource_access
  def index
    @fingerprint = Fingerprint.new
    @fingerprints = Fingerprint.find_mystatement(current_user.userable.thumb_id)
    @approvefingerprints = Fingerprint.find_approvestatement(current_user)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fingerprints }
    end
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
        format.html { redirect_to(staff_fingerprint_path(@fingerprint), :notice => (t 'fingerprint.title')+(t 'actions.updated'))}
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
    @fingerprint.destroy
  end
  
  def approval
    @fingerprint = Fingerprint.find(params[:id])
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fingerprint
      @fingerprint = Fingerprint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fingerprint_params
      params.require(:fingerprint).permit(:thumb_id, :fdate, :ftype, :reason, :approved_by, :is_approved, :approved_on, :status)
    end
end