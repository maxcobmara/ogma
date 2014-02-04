class Library::LibrarytransactionsController < ApplicationController
  
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  
  def index
    @filters = Librarytransaction::FILTERS
    if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
      @librarytransactions = Librarytransaction.with_permissions_to.send(params[:show])
    else
      @librarytransactions = Librarytransaction.all
    end
    @paginated_transaction = @librarytransactions.order(checkoutdate: :desc).page(params[:page]).per(15)
    @libtran_days = @paginated_transaction.group_by {|t| t.checkoutdate}
  end
  

  # GET /librarytransactions/new
  # GET /librarytransactions/new.xml
  def new
    @librarytransaction = Librarytransaction.new
    @librarytransactions = Array.new(4) #{ Libraryransaction.new }
    #-----trial----
    @aaa = params[:librarytransactions]
    @staff1 = params[:stafffirst]
    @student1 = params[:studentfirst]
    #-----trial----
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @librarytransaction }
    end
  end
  
  def check_status
    @librarytransactions = []
    
    
    
    
  
    if params[:search].present? && params[:search][:staff_name].present?
      @staff_name = params[:search][:staff_name]
      @staff_list = Staff.where("name ILIKE ?", "%#{@staff_name}%").pluck(:id)
      scope = Librarytransaction.where("staff_id IN (?) AND returneddate IS ?", @staff_list, nil)
      @searches = scope.all
      @searches.each do |t|
        @librarytransactions << t
      end
    end 
  end  
  
  
  
  def extend
    @librarytransaction = Librarytransaction.find(params[:id])
  end
  
  def extend2
    @librarytransaction = Librarytransaction.find(params[:id])
    render :layout => false
  end
  
  def return
    @librarytransaction = Librarytransaction.find(params[:id])
  end
  
  def return2
    @librarytransaction = Librarytransaction.find(params[:id])
    render :layout => false
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_librarytransaction
      @librarytransaction = Librarytransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:librarytransaction).permit()# <-- insert editable fields here inside here e.g (:date, :name)
    end
  
end
  