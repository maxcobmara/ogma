class Asset::AssetLoansController < ApplicationController
  filter_access_to :index, :new, :create, :lampiran_a, :attribute_check => false
  filter_access_to :edit, :show, :update, :destroy, :approval, :attribute_check => true
  before_action :set_asset_loan, only: [:show, :edit, :update, :destroy]

  # GET /asset_loans
  # GET /asset_loans.xml
  def index
    roles = @current_user.roles.pluck(:authname)
    @is_admin = true if roles.include?("administration") || roles.include?("asset_administrator") || roles.include?("asset_loans_module")
    if @is_admin
      @search = AssetLoan.search(params[:q])
    else
      @search = AssetLoan.sstaff2(current_user.userable.id).search(params[:q])
    end 
    @asset_loans = @search.result
    @asset_loans = @asset_loans.order(created_at: :desc).page(params[:page]||1)
    
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
    @asset_loan = AssetLoan.find(params[:id])

    respond_to do |format|
      if @asset_loan.update_attributes(asset_loan_params)
        format.html { redirect_to(@asset_loan, :notice => t('asset.loan.title')+t('actions.updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @asset_loan.errors, :status => :unprocessable_entity }
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
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset_loan
      @asset_loan = AssetLoan.find(params[:id])
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_loan_params
      params.require(:asset_loan).permit(:asset_id, :staff_id, :reasons, :loaned_by, :is_approved, :approved_date, :loaned_on, :expected_on, :is_returned, :returned_on, :remarks, :loan_officer, :hod, :hod_date, :loantype, :received_officer)
    end
  
end
