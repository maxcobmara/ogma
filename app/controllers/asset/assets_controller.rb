class Asset::AssetsController < ApplicationController
  filter_access_to :index, :new, :create, :kewpa2, :kewpa3, :kewpa4, :kewpa5, :kewpa6, :kewpa8, :kewpa13, :kewpa14, :loanables, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  before_action :set_asset, only: [:show, :edit, :update, :destroy]
  
  def index
    #all staff @ user w menu(index) access; can view full list of asset w 'purchase details' hidden
    #in index & show - 'purchase detail' visible to admin & asset admin (w access to : manage, kewpa2 ..etc)
    #show - link for creating asset defect
    @search = Asset.search(params[:q])
    @assets = @search.result
    @fa = @assets.where(assettype: 1).sort_by{|x|[x.assetcode.split("/")[3], (x.assetcode.split("/")[4]).to_i, (x.assetcode.split("/")[5]).to_i]}
    @inv = @assets.where(assettype: 2).sort_by{|x|[x.assetcode.split("/")[3], (x.assetcode.split("/")[4]).to_i, (x.assetcode.split("/")[5]).to_i]}
    @fixed_assets = Kaminari.paginate_array(@fa).page(params[:page]||1) 
    @inventories  = Kaminari.paginate_array(@inv).page(params[:page]||1)
  end
  
  def show
  end
  
  def update
    respond_to do |format|
      if @asset.update(asset_params)
        format.html { redirect_to asset_asset_path(@asset), notice: (t 'asset.title')+(t 'actions.updated')  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def new
    @asset = Asset.new
  end

  def create
    @asset = Asset.new(asset_params)

    respond_to do |format|
      if @asset.save
        format.html { redirect_to asset_asset_path(@asset), notice: 'A new asset was successfully created.' }
        format.json { render action: 'show', status: :created, location: @asset }
      else
        format.html { render action: 'new' }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to(asset_assets_url) }
      format.xml  { head :ok }
    end
  end
  
  def kewpa2
    #@lead = Position.find(1).try(:staff).try(:name)
    @lead = Position.find(1)
    @asset = Asset.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa2Pdf.new(@asset, view_context, @lead, current_user.college)
        send_data pdf.render, filename: "kewpa2-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  
  def kewpa3
    @lead = Position.find(1)
    @asset = Asset.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa3Pdf.new(@asset, view_context, @lead, current_user.college)
        send_data pdf.render, filename: "kewpa3-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa4
    if params[:search_year]
      begin_year=Date.new(params[:search_year].to_i, 1, 1)
      end_year=Date.new(params[:search_year].to_i, 12, 31)
      @assets=Asset.hm.where('receiveddate >=? and receiveddate <=?', begin_year, end_year)
    elsif params[:ids]
      @assets=Asset.where(id: params[:ids])
    else
      @search=Asset.search(params[:q])
      @assets=@search.result.hm #where(assettype: 1)
    end
    respond_to do |format|
      format.pdf do
        pdf = Kewpa4Pdf.new(@assets, view_context)
        send_data pdf.render, filename: "kewpa4-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end  
  
  def kewpa5
    if params[:search_year]
      begin_year=Date.new(params[:search_year].to_i, 1, 1)
      end_year=Date.new(params[:search_year].to_i, 12, 31)
      @assets=Asset.inv.where('receiveddate >=? and receiveddate <=?', begin_year, end_year)
    elsif params[:ids]
      @assets=Asset.where(id: params[:ids])
    else
      @search=Asset.search(params[:q])
      @assets=@search.result.inv #where(assettype: 2)
    end
    respond_to do |format|
      format.pdf do
        pdf = Kewpa5Pdf.new(@assets, view_context)
        send_data pdf.render, filename: "kewpas-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa6
    @asset = Asset.find(params[:id])
    @loanable = AssetLoan.where('asset_id=? AND is_approved!=?',params[:id], false)#.order(assetcode: :asc)
    respond_to do |format|
      format.pdf do
        pdf = Kewpa6Pdf.new(@loanable, view_context)
        send_data pdf.render, filename: "kewpa6-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa8
    if params[:search_year]
      begin_year=Date.new(params[:search_year].to_i, 1, 1)
      end_year=Date.new(params[:search_year].to_i, 12, 31)
#       if current_user.college.code=='amsas'
        @fa=Asset.hm.where('receiveddate >=? and receiveddate <=?', begin_year, end_year)
        @inv=Asset.inv.where('receiveddate >=? and receiveddate <=?', begin_year, end_year)
#       else
#         @fa=Asset.hm.where('purchasedate >=? and purchasedate <=?', begin_year, end_year)
#         @inv=Asset.inv.where('purchasedate >=? and purchasedate <=?', begin_year, end_year)
#       end
    else
#       if current_user.college.code=='amsas' 
        @fa = Asset.where(assettype: 1).where('receiveddate <=?', Date.today)
        @inv =  Asset.where(assettype: 2).where('receiveddate <=?', Date.today)
#       else
#         @fa = Asset.where(assettype: 1).where('purchasedate <=?', Date.today)
#         @inv =  Asset.where(assettype: 2).where('purchasedate <=?', Date.today)
#       end
    end
    respond_to do |format|
      format.pdf do
        pdf = Kewpa8Pdf.new(@fa, @inv, view_context, current_user.college)
        send_data pdf.render, filename: "kewpa8-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa13
    if params[:ids]
      @assets=Asset.where(id: params[:ids]).order(assetcode: :asc)
    else
      @assets = Asset.where('is_maintainable = ?', true).order(assetcode: :asc)
    end
    respond_to do |format|
      format.pdf do
        pdf = Kewpa13Pdf.new(@assets, view_context)
        send_data pdf.render, filename: "kewpa13-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def kewpa14
    @asset = Asset.find(params[:id])#  Asset.find(10) #.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa14Pdf.new(@asset, view_context)
        send_data pdf.render, filename: "kewpa14-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end  
  
  def loanables
   loaned = AssetLoan.where('is_returned IS NOT true').pluck(:asset_id)
   loaned = [0] if loaned == []    
   @search = Asset.search(params[:q])
   @loanables = @search.result.where('assignedto_id is not null and bookable = ? and assets.id NOT IN (?) ', true, loaned)
   @loanables = @loanables.order(assetcode: :asc).page(params[:page]||1)    
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset
      @asset = Asset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_params
      params.require(:asset).permit(:assetcode, :assettype, :assignedto_id, :bookable, :cardno, :cardno2,  :category_id, :engine_no, :engine_type_id, :is_maintainable, 
        :locassigned, :location_id, :manufacturer_id, :country_id, :mark_as_lost, :mark_disposal, :modelname, :name, :purchasedate, :purchaseprice, :quantity, :quantity_type, 
        :receiveddate, :receiver_id, :registration, :serialno, :status, :subcategory, :supplier_id, :typename, :warranty_length, :warranty_length_type, :college_id, {:data=>[]}, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id], asset_placements_attributes: [:id, :_destroy, :location_id, :staff_id, :reg_on, :quantity])
    end
end


# == Schema Information
#
# Table name: assets
#
#  assetcode            :string(255)
#  assettype            :integer
#  assignedto_id        :integer
#  bookable             :boolean
#  cardno               :string(255)
#  category_id          :integer
#  country_id           :integer
#  created_at           :datetime
#  engine_no            :string(255)
#  engine_type_id       :integer
#  id                   :integer          not null, primary key
#  is_disposed          :boolean
#  is_maintainable      :boolean
#  locassigned          :boolean
#  location_id          :integer
#  manufacturer_id      :integer
#  mark_as_lost         :boolean
#  mark_disposal        :boolean
#  modelname            :string(255)
#  name                 :string(255)
#  nationcode           :string(255)
#  orderno              :string(255)
#  otherinfo            :text
#  purchasedate         :date
#  purchaseprice        :decimal(, )
#  quantity             :integer
#  quantity_type        :string(255)
#  receiveddate         :date
#  receiver_id          :integer
#  registration         :string(255)
#  serialno             :string(255)
#  status               :integer
#  subcategory          :string(255)
#  supplier_id          :integer
#  typename             :string(255)
#  updated_at           :datetime
#  warranty_length      :integer
#  warranty_length_type :integer
#