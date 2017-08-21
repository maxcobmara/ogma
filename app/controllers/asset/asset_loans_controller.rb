class Asset::AssetLoansController < ApplicationController
  filter_access_to :index, :new, :create, :lampiran_a, :loan_list, :attribute_check => false
  filter_access_to :edit, :show, :update, :destroy, :approval, :vehicle_endorsement, :vehicle_approval, :vehicle_return, :vehicle_reservation, :attribute_check => true
  before_action :set_asset_loan, only: [:show, :edit, :update, :destroy, :vehicle_endorsement, :vehicle_approval, :vehicle_return]
  before_action :set_asset_loans, only: [:index, :loan_list]

  # GET /asset_loans
  # GET /asset_loans.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @asset_loans }
    end
  end

  # GET /asset_loans/1
  # GET /asset_loans/1.xml
  def show
    @asset_loan = AssetLoan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asset_loan }
    end
  end

  # GET /asset_loans/new
  # GET /asset_loans/new.xml
  def new
    @asset_loan = AssetLoan.new(:asset_id => params[:asset_id])
    @current_asset=Asset.where(id: params[:asset_id]).first

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset_loan }
    end
  end

  # GET /asset_loans/1/edit
  def edit
    @asset_loan = AssetLoan.find(params[:id])
  end

  # POST /asset_loans
  # POST /asset_loans.xml
  def create
    @asset_loan = AssetLoan.new(asset_loan_params)
    @current_asset=@asset_loan.asset
    respond_to do |format|
      if @asset_loan.save
        format.html { redirect_to @asset_loan, :notice => t('asset.loan.title')+t('actions.created') }
        format.xml  { render :xml => @asset_loan, :status => :created, :location => @asset_loan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @asset_loan.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # PUT /asset_loans/1
  # PUT /asset_loans/1.xml
  def update
    #raise params.inspect
    @asset_loan = AssetLoan.find(params[:id])

    respond_to do |format|
      if @asset_loan.update_attributes(asset_loan_params)
        format.html { redirect_to(@asset_loan, :notice => t('asset.loan.title')+t('actions.updated')) }
        format.xml  { head :ok }
      else
	  if @asset_loan.is_returned==true && (@asset_loan.returned_on.blank? || @asset_loan.received_officer.blank?) && Asset.vehicle.include?(@asset_loan.asset) 
	     format.html { render :action => "vehicle_return" }
	     format.xml  { render :xml => @asset_loan.errors, :status => :unprocessable_entity }
	  elsif @asset_loan.is_approved==true && (@asset_loan.approved_date.blank? || @asset_loan.hod.blank?) && Asset.vehicle.include?(@asset_loan.asset) 
	     format.html { render :action => "vehicle_approval" }
	     format.xml  { render :xml => @asset_loan.errors, :status => :unprocessable_entity }
	  elsif @asset_loan.is_endorsed==true && (@asset_loan.endorsed_date.blank? || @asset_loan.loan_officer.blank?) && Asset.vehicle.include?(@asset_loan.asset) 
	     format.html { render :action => "vehicle_endorsement" }
	     format.xml  { render :xml => @asset_loan.errors, :status => :unprocessable_entity }
	  elsif @asset_loan.is_approved==true && (@asset_loan.approved_date.blank? || @asset_loan.loan_officer.blank?) && Asset.otherasset.include?(@asset_loan.asset) 
	     format.html { render :action => "approval" }
	     format.xml  { render :xml => @asset_loan.errors, :status => :unprocessable_entity }   
	  else
	     format.html { render :action => "edit" }
	     format.xml  { render :xml => @asset_loan.errors, :status => :unprocessable_entity }
	  end 
      end
    end
  end

  # DELETE /asset_loans/1
  # DELETE /asset_loans/1.xml
  def destroy
    @asset_loan = AssetLoan.find(params[:id])
    @asset_loan.destroy

    respond_to do |format|
      format.html { redirect_to(asset_loans_url) }
      format.xml  { head :ok }
    end
  end
  
  def approval
    @asset_loan = AssetLoan.find(params[:id])
  end
  
  def vehicle_endorsement
  end
  
  def vehicle_approval
  end
  
  def vehicle_return
  end
  
  def vehicle_reservation
    @asset_loan = AssetLoan.find(params[:id])
    respond_to do |format|
       format.pdf do
         pdf = BookingvehiclePdf.new(@asset_loan, view_context, current_user.college)
         send_data pdf.render, filename: "booking_vehicle-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end
  
  def lampiran_a
    @asset_loan = AssetLoan.find(params[:id]) 
     respond_to do |format|
         format.pdf do
           pdf = Lampiran_aPdf.new(@asset_loan, view_context)
           send_data pdf.render, filename: "lampiran_a-{Date.today}",
                                 type: "application/pdf",
                                 disposition: "inline"
         end
     end 
  end
  
  def loan_list
    respond_to do |format|
       format.pdf do
         pdf = Loan_listPdf.new(@asset_loans, view_context, current_user.college)
         send_data pdf.render, filename: "loan_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset_loan
      @asset_loan = AssetLoan.find(params[:id])
    end
    
    def set_asset_loans
      roles = @current_user.roles.pluck(:authname)
      @is_admin = true if roles.include?("developer") || roles.include?("administration") || roles.include?("asset_administrator") || roles.include?("asset_loans_module")
      if @is_admin
        @search = AssetLoan.search(params[:q])
      else
        @search = AssetLoan.sstaff2(current_user.userable.id).search(params[:q])
      end 
      @asset_loans = @search.result
      @asset_loans = @asset_loans.order(created_at: :desc).page(params[:page]||1)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_loan_params
      params.require(:asset_loan).permit(:asset_id, :staff_id, :reasons, :loaned_by, :is_approved, :approved_date, :loaned_on, :expected_on, :is_returned, :returned_on, :remarks, :loan_officer, :hod, :hod_date, :loantype, :received_officer, :driver_id, :is_endorsed, :endorsed_date, :endorsed_note, :approved_note, :college_id, {:data => []})
    end
  
end
