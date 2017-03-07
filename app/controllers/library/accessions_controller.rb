class Library::AccessionsController < ApplicationController
  
  filter_access_to :index, :new, :create, :reservation, :reservation_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy,  :attribute_check => true
  
  before_action :set_list_data, only: [:index, :reservation_list]
  before_action :set_accession, only: [:show, :edit, :update, :destroy]
  
  def available_autocomplete
    #@available_autocomplete = Accession.joins(:librarytransactions).where("librarytransactions.returneddate IS ?", nil).order(:accession_no)
  end
  
  def index
    @accessions=@search.result
    @accessions=@accessions.page(params[:page]||1) 
    @librarytransaction=Librarytransaction.new
  end
  
  def reservation
    @accession=Accession.find(params[:id])
  end
  
  def update
    @accession =Accession.find(params[:id])

    respond_to do |format|
      if @accession.update(accession_params)
        if @accession.activate_date==Date.today.strftime('%d-%m-%Y') 
          #remove reservation
          format.html { redirect_to library_accession_path(@accession), notice: (t 'library.reservation.successful_reservation_removal')}
          format.xml  { head :ok }
        else
          #new reservation
          format.html { redirect_to library_accession_path(@accession), notice: (t 'library.reservation.successful_reservation')}
          format.xml  { head :ok }
        end
      else
	@errors_line=""
	@accession.errors.each{|k,v| errors_line+="<li>#{v}</li>"}
        format.html { render :action => "reservation", notice: ("<span style='color: red;'>"+"<ol>"+errors_line+"</ol></span>").html_safe}
        format.xml  { render :xml => @accession.errors, :status => :unprocessable_entity }
      end
      format.js
    end
  end
  
  def show
    @librarytransaction=Librarytransaction.new
  end
  
  def reservation_list
    @accessions=@search.result
    respond_to do |format|
      format.pdf do
        pdf = Reservation_listPdf.new(@accessions, view_context, current_user.college)
        send_data pdf.render, filename: "reservation_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accession
      @accession = Accession.find(params[:id])
    end
    
    def set_list_data
      roles = current_user.roles.pluck(:authname)
      @is_admin = roles.include?("developer") || roles.include?("administration") || roles.include?("librarian") || roles.include?("library_books_module_admin") || roles.include?("library_books_module_user")
      if @is_admin
        @search=Accession.where.not(data: nil).search(params[:q])
      else
        @search = Accession.where.not(data: nil).search2(current_user.id).search(params[:q])
      end 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def accession_params
      params.require(:accession).permit(:book_id, :accession_no, :order_no, :purchase_price, :received, :received_by, :supplied_by, :college_id, :status, { :data=>[]}).tap do |whitelisted|
        whitelisted[:reservations]=params[:accession][:reservations]
	whitelisted[:activate_date]=params[:accession][:activate_date]
      end# <-- insert editable fields here inside here e.g (:date, :name)
    end
  
end