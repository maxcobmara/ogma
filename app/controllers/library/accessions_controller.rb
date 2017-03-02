class Library::AccessionsController < ApplicationController
  
  filter_access_to :index, :new, :create, :reservation, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy,  :attribute_check => true
  
  before_action :set_accession, only: [:show, :edit, :update, :destroy]
  
  def available_autocomplete
    #@available_autocomplete = Accession.joins(:librarytransactions).where("librarytransactions.returneddate IS ?", nil).order(:accession_no)
  end
  
  def reservation
    #@book = Book.find(params[:book_id])
    @accession=Accession.find(params[:id])
  end
  
  def index
  end
  
  def update
    @accession =Accession.find(params[:id])

    respond_to do |format|
      if @accession.update(accession_params)
        format.html { redirect_to library_book_path(@accession.book) , notice: "yea book da"}
        format.xml  { head :ok }
      else
        format.html { render :action => "reservation" }
        format.xml  { render :xml => @accession.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accession
      @accession = Accession.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def accession_params
      params.require(:accession).permit(:book_id, :accession_no, :order_no, :purchase_price, :received, :received_by, :supplied_by, :college_id, :status, { :data=>[]}).tap do |whitelisted|
        whitelisted[:reservations]=params[:accession][:reservations]
      end# <-- insert editable fields here inside here e.g (:date, :name)
    end
  
end