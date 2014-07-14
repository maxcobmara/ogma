class Campus::AddressBooksController < ApplicationController
  
  def index
    @address_books = AddressBook.where(name: params[:search])
  end

  def new
  	@address_book = AddressBook.new
  end
end