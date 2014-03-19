class BulletinsController < ApplicationController
  before_action :set_bulletin, only: [:show, :edit, :update, :destroy]
  
  # GET /bulletins
  # GET /bulletins.xml
  def index
    @search = Bulletin.search(params[:q])
    @bulletins = @search.result
    @bulletins = @bulletins.page(params[:page]||1)
  end

  # GET /bulletins/1
  # GET /bulletins/1.xml
  def show
  end

  # GET /bulletins/new
  # GET /bulletins/new.xml
  def new
    @bulletin = Bulletin.new
  end

  # GET /bulletins/1/edit
  def edit
  end

  # POST /bulletins
  # POST /bulletins.xml
  def create
    @bulletin = Bulletin.new(bulletin_params)

    respond_to do |format|
      if @bulletin.save
        format.html { redirect_to @bulletin, notice: 'Bulletin was successfully created.' }
        format.json { render action: 'show', status: :created, location: @bulletin }
      else
        format.html { render action: 'new' }
        format.json { render json: @bulletin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bulletins/1
  # PUT /bulletins/1.xml
  def update
    respond_to do |format|
      if @bulletin.update(bulletin_params)
        format.html { redirect_to bulletin_path, notice:  'Bulletin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bulletin.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /bulletins/1
  # DELETE /bulletins/1.xml
  def destroy
    @bulletin.destroy

    respond_to do |format|
      format.html { redirect_to(bulletins_url) }
      format.json { head :no_content }
    end
  end

  
private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulletin
      @bulletin = Bulletin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bulletin_params
      params.require(:bulletin).permit(:headline, :content, :postedby_id, :publishdt )
    end
    
end

