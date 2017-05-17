class EqueryReport::AssetsearchesController < ApplicationController
  filter_resource_access
  
  def new
    @searchtype = params[:searchtype]
    @assetsearch = Assetsearch.new
  end

  def create
    @assetsearch = Assetsearch.new(assetsearch_params)
    if @assetsearch.save
      redirect_to equery_report_assetsearch_path(@assetsearch)
    else
      render :action => 'new'
    end
  end

  def show
    @assetsearch = Assetsearch.find(params[:id])
    @assets=@assetsearch.assets.order(assetcode: :asc).page(params[:page]).per(20)
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def assetsearch_params
      params.require(:assetsearch).permit(:assetcode, :assettype, :name, :purchaseprice, :purchasedate, :startdate, :enddate, :category, :assignedto, :bookable, :loandate, :returndate, :location, :defect_asset, :defect_reporter, :defect_processor, :defect_process, :maintainable, :maintname, :maintcode, :disposal, :disposaltype, :discardoption, :disposalreport, :disposalcert, :disposalreport2, :loss_start, :loss_end, :loss_cert, :loanedasset, :alldefectasset, :purchaseprice2, :purchasedate2, :receiveddate, :receiveddate2, :loandate2, :returndate2, :expectedreturndate, :expectedreturndate2, :search_type, :college_id, [:data => {}])
    end
    
    #:assetcode, :assettype, :name, :purchaseprice, :purchasedate, :startdate, :enddate, :category, :assignedto, :bookable, :loandate, :returndate, :location, :defect_asset, :defect_reporter, :defect_processor, :defect_process, :maintainable, :maintname, :maintcode, :disposal, :disposaltype, :discardoption, :disposalreport, :disposalcert, :disposalreport2, :loss_start, :loss_end, :loss_cert, :loanedasset, :alldefectasset, :purchaseprice2, :purchasedate2, :receiveddate, :receiveddate2, :loandate2, :returndate2, :expectedreturndate, :expectedreturndate2
    
end
