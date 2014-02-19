class CofilesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  # GET /cofiles
  # GET /cofiles.xml

  def index
    @search = Cofile.search(params[:q])
    @cofiles = @search.result
    @cofiles = @cofiles.page(params[:page]||1)
    #previous
    #@staff_filtered = Staff.with_permissions_to(:edit).find(:all, :order => sort_column + ' ' + sort_direction ,:conditions => ['icno LIKE ? or name ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%"])
    @cofiles_filtered = Cofile.find(:all, :order => sort_column + ' ' + sort_direction ,:conditions => ['cofileno LIKE ? or name ILIKE ? ', "%#{params[:search]}%", "%#{params[:search]}%"])

  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @cofile = Cofile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:cofile).permit(:cofileno, :name, :location, :owner)
    end
    
    def sort_column
        Cofile.column_names.include?(params[:sort]) ? params[:sort] : "cofileno" 
    end
    def sort_direction
        %w[asc desc].include?(params[:direction])? params[:direction] : "asc" 
    end
end