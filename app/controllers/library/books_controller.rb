class Library::BooksController < ApplicationController
  
  filter_access_to :index, :new, :create, :import_excel, :import, :download_excel_format, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  before_action :set_book, only: [:show, :edit, :update, :destroy]
 
  # GET /books
  # GET /books.xml
  def index
    @search = Book.search(params[:q])
    @media=params[:q][:mediatype_search] if params[:q]
    @status=params[:q][:status_search] if params[:q]
    @books2 = @search.result
    @books2 = @books2.mediatype_search(@media.to_i) if @media
    @books2 = @books2.status_search(@status.to_i) if @status
    @books = @books2.order(title: :asc).page(params[:page]||1)
    @result_by_accession=Accession.where('accession_no ILIKE (?)', "%#{@search.accessionno_search}%").pluck(:accession_no)  if @search.accessionno_search 
   
    @searched_accession = Accession.where('book_id IN (?)', @books2.pluck(:id))				#3 (Book id 1298 ) 10003, 10004, 10005 
    @all_accessions = @searched_accession.sort_by(&:accession_no).sort_by(&:book_id)		#pg 3 consist of 7 records only --> 3 accession records w/o book (25+25+7)
    #@all_accessions = Accession.all.sort_by(&:accession_no)							#pg 3 consist of 10 records (25+25+10)
    #@accessions_by_book =@all_accessions.group_by(&:book_id)						#dah paginate yg asal - group by book id	#just for checking
    @accessions = Kaminari.paginate_array(@all_accessions).page(params[:page]||1)    
    @acc_by_book = @accessions.group_by(&:book_id)
    
    #retrieve book without accession no
    @book_wo_acc=Book.where('id NOT IN(?)', Accession.all.pluck(:book_id).uniq)

    respond_to do |format|
      format.html # index.html.erb
      format.js #1Apr2013
      format.xml  { render :xml => @books }
    end
  end

  #start - import excel
  def import_excel
  end
  
  def import
      a=Book.import(params[:file]) 
      msg=Book.messages(a)
      msg2=Book.messages2(a)      
      msg3=I18n.t'library.book.book_wo_acc' if a[:bwoacc].count>0
      if a[:svb].count>0 || a[:sva].count>0 || a[:rmb].count>0 || a[:wpt].count>0 || a[:bwoacc].count>0
	respond_to do |format|
	   flash[:notice] = msg
	   flash[:error] = msg2
	   flash[:error] = msg3
	   format.html {redirect_to library_books_url}
	   #flash.discard
	end
      else
	respond_to do |format|
          flash[:notice] = "Nothing Imported"
          format.html { render action: 'import_excel' }
          flash.discard
        end
      end
  end
  
  def download_excel_format
    send_file ("#{::Rails.root.to_s}/public/excel_format/book_import.xls")
  end
  #end - import excel
  
  # GET /books/1
  # GET /books/1.xml
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/new
  # GET /books/new.xml
  def new
    @book = Book.new
    5.times { @book.accessions.build }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.xml
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        flash[:notice] =  (t 'library.book.book2')+(t 'actions.created')
        format.html { redirect_to library_book_path(@book) }
        format.xml  { render :xml => @book, :status => :created, :location => @book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update(book_params)
        flash[:notice] = (t 'library.book.book2')+(t 'actions.updated')
        format.html { redirect_to library_book_path(@book) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.xml
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to library_books_path }
      format.xml  { head :ok }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:tagno, :controlno,:isbn,:bookcode,:accessionno,:catsource,:classlcc,:classddc,:title,:author,:publisher,:description, :loantype,:mediatype,:status,:series,:location,:topic,:orderno,:purchaseprice,:purchasedate,:receiveddate,:receiver_id,:supplier_id,:issn, :edition, :photo_file_name, :photo_content_type,:photo_file_size,:photo_updated_at, :publish_date,:publish_location, :language, :links, :subject, :quantity, :roman, :size, :pages, :bibliography,:indice,:notes,:backuproman,:finance_source, accessions_attributes: [:id, :_destroy, :accession_no])
    end
  
end