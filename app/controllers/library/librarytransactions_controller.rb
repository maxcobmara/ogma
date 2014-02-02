class Library::LibrarytransactionsController < ApplicationController
  
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
  
end
  