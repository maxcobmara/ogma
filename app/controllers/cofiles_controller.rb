class CofilesController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /cofiles
  # GET /cofiles.xml
  
  
  def index
    @cofiles = Cofile.find(:all, :conditions => ['name ILIKE ?', "%#{params[:search]}%"])
    @cofiles_filtered = Cofile.find(:all, :order => sort_column + ' ' + sort_direction ,:conditions => ['name LIKE ? or cofileno ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%"])
  end
  
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @cofiles = Cofile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:cofile).permit(:name, :rank_id, :name)
    end
    
    def sort_column
        Cofile.column_names.include?(params[:sort]) ? params[:sort] : "name" 
    end
    def sort_direction
        %w[asc desc].include?(params[:direction])? params[:direction] : "asc" 
    end
end
