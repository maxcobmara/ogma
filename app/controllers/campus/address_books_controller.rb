class Campus::AddressBooksController < ApplicationController
  filter_access_to :index, :new, :create, :address_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  before_action :set_address_book, only: [:show, :edit, :update, :destroy]
  
  def index
    @address_books = AddressBook.where('name ILIKE ?', "#{params[:search]}%")
  end

  def new
  	@address_book = AddressBook.new
  end

  def show
  end

  def edit
  end

  def create 
  	@address_book = AddressBook.new(address_book_params)

    respond_to do |format|
      if @address_book.save
        flash[:notice] = 'Contact successfully created.'
        format.html { redirect_to campus_address_books_path}
        format.json { render action: 'show', status: :created, location: @address_book }
      else
        format.html { render action: 'new' }
        format.json { render json: @address_book.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def address_list
    # TODO - pdf page
  end


	private
	  # Use callbacks to share common setup or constraints between actions.
	  def set_address_book
	    @address_book = AddressBook.find(params[:id])
	  end

	  # Never trust parameters from the scary internet, only allow the white list through.
	  def address_book_params
	    params.require(:address_book).permit(:address, :fax, :mail, :name, :phone, :shortname, :web)
	  end
end