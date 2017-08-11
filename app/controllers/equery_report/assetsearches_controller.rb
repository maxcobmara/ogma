class EqueryReport::AssetsearchesController < ApplicationController
  filter_access_to :new, :create, :new_hm, :new_inv, :new_loan, :new_location, :new_yearly_report, :new_defect, :new_maintenance_list, :new_maintenance, :new_pep, :new_examiner_report, :new_destroy_certificate, :new_destroy_witness, :new_yearly_destroy, :new_initial_loss, :new_final_loss, :new_writeoff_certificate, :attribute_check => false
  filter_access_to :show, :attribute_check => true
  
  def new
    @assetsearch = Assetsearch.new
  end
  
  def new_hm
    @assetsearch = Assetsearch.new
  end
  
  def new_inv
    @assetsearch = Assetsearch.new
  end
  
  def new_loan
    @assetsearch = Assetsearch.new
  end

  def new_location
    @assetsearch = Assetsearch.new
  end
  #6
  def new_yearly_report
    @assetsearch = Assetsearch.new
  end
  
  def new_defect
    @assetsearch = Assetsearch.new
  end
  #8
  def new_maintenance_list
    @assetsearch = Assetsearch.new
  end
  #9
  def new_maintenance
    @assetsearch = Assetsearch.new
  end
  
  def new_pep
    @assetsearch = Assetsearch.new
  end
  #11
  def new_examiner_report
    @assetsearch = Assetsearch.new
  end
  #12
  def new_destroy_certificate
    @assetsearch = Assetsearch.new
  end
  #13  
  def new_destroy_witness
    @assetsearch = Assetsearch.new
  end
  
  def new_yearly_destroy
    @assetsearch = Assetsearch.new
  end
  #15
  def new_initial_loss
    @assetsearch = Assetsearch.new
  end
  
  def new_final_loss
    @assetsearch = Assetsearch.new
  end
  
  def new_writeoff_certificate
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
    if @assetsearch.search_type==6
      #kewpa 8 (group by year)
      @assets_by_year=(@assetsearch.assets.sort_by{|x|x.receiveddate}.group_by{|d|d.receiveddate.strftime('%Y-%m-%d').split("-")[0]}).to_a
      @assets=Kaminari.paginate_array(@assets_by_year).page(params[:page]).per(20)
    elsif @assetsearch.search_type==17 #kewpa31
      @assets_by_treasury=AssetLoss.joins(:asset).where(asset_id: @assetsearch.assets.pluck(:id)).group_by{|x|x.document}.to_a
      @assets=Kaminari.paginate_array(@assets_by_treasury).page(params[:page]).per(2)
    else
      @assets=@assetsearch.assets.order(assettype: :asc, assetcode: :asc).page(params[:page]).per(20)
    end
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def assetsearch_params
      params.require(:assetsearch).permit(:assetcode, :assettype, :name, :purchaseprice, :purchasedate, :startdate, :enddate, :category, :assignedto, :bookable, :loandate, :returndate, :location, :defect_asset, :defect_reporter, :defect_processor, :defect_process, :maintainable, :maintname, :maintcode, :disposal, :disposaltype, :discardoption, :disposalreport_start, :disposalreport_end, :examine_start, :examine_end, :disposalcert, :loss_start, :loss_end, :loss_cert, :loanedasset, :alldefectasset, :purchaseprice2, :purchasedate2, :receiveddate, :receiveddate2, :loandate2, :returndate2, :expectedreturndate, :expectedreturndate2, :search_type, :college_id, [:data => {}])
    end
    
    #:assetcode, :assettype, :name, :purchaseprice, :purchasedate, :startdate, :enddate, :category, :assignedto, :bookable, :loandate, :returndate, :location, :defect_asset, :defect_reporter, :defect_processor, :defect_process, :maintainable, :maintname, :maintcode, :disposal, :disposaltype, :discardoption, :disposalreport, :disposalcert, :disposalreport2, :loss_start, :loss_end, :loss_cert, :loanedasset, :alldefectasset, :purchaseprice2, :purchasedate2, :receiveddate, :receiveddate2, :loandate2, :returndate2, :expectedreturndate, :expectedreturndate2
    
end
