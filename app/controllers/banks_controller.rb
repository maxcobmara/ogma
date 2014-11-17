class BanksController < ApplicationController
  before_action :set_bank, only: [:show, :edit, :update, :destroy]
  # GET /banks
  # GET /banks.xml
  def index
    @search = Bank.search(params[:q])
    @bank = @search.result
    @bank = @bank.page(params[:page]||1)
    @banks = Bank.order(short_name: :asc)
  end

  # GET /banks/1
  # GET /banks/1.xml
  def show
  end

  # GET /banks/new
  # GET /banks/new.xml
  def new
    @bank = Bank.new
  end

  # GET /banks/1/edit
  def edit
    @bank = Bank.find(params[:id])
  end

  # POST /banks
  # POST /banks.xml
  def create
    @bank = Bank.new(bank_params)
    
    respond_to do |format|
      if @bank.save
        format.html { redirect_to @bank, notice:t('banks.new_flash')}
        format.json { render action: 'show', status: :created, location: @bank }
      else
        format.html { render action: 'new' }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /banks/1
  # PUT /banks/1.xml
  def update
    @bank = Bank.find(params[:id])

    respond_to do |format|
      if @bank.update(bank_params)
        format.html { redirect_to @bank, notice:t('banks.update_flash') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banks/1
  # DELETE /banks/1.xml
  def destroy
    @bank.destroy
    respond_to do |format|
      format.html { redirect_to banks_url }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank
      @bank = Bank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_params
      params.require(:bank).permit(:active, :created_at, :id, :long_name, :short_name, :updated_at)
    end
end
