class CofilesController < ApplicationController
  before_action :set_cofile, only: [:show, :edit, :update, :destroy]
  # GET /cofiles
  # GET /cofiles.xml

  def index
    @search = Cofile.search(params[:q])
    @cofiles = @search.result
    @cofiles = @cofiles.page(params[:page]||1)
    #previous
    #@staff_filtered = Staff.with_permissions_to(:edit).find(:all, :order => sort_column + ' ' + sort_direction ,:conditions => ['icno LIKE ? or name ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%"])
    #@cofiles_filtered = Cofile.find(:all, :order => sort_column + ' ' + sort_direction ,:conditions => ['cofileno LIKE ? or name ILIKE ? ', "%#{params[:search]}%", "%#{params[:search]}%"])

  end
  
  def new
    @cofile = Cofile.new
  end  
  
  def update
    respond_to do |format|
      if @cofile.update(cofile_params)
        format.html { redirect_to @cofile, notice: 'File Registry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cofile.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def edit
    @cofile = Cofile.find(params[:id])
  end


  def create
    @cofile = Cofile.new(cofile_params)

    respond_to do |format|
      if @cofile.save
        format.html { redirect_to @cofile, notice: 'File Registry was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cofile }
      else
        format.html { render action: 'new' }
        format.json { render json: @cofile.errors, status: :unprocessable_entity }
      end
    end
  end
 
  
  def destroy
    @cofile.destroy
    respond_to do |format|
      
      format.html { redirect_to cofiles_url }
      format.json { head :no_content }
    end
  end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_cofile
      @cofile = Cofile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cofile_params
      params.require(:cofile).permit(:cofileno, :name, :location, :owner_id, :staffloan_id, :onloan, :onloandt, :onloanxdt)
    end

end