class Campus::AddressBooksController < ApplicationController
  
  def index
    @address_books = AddressBook.search(params[:search])
  end
end