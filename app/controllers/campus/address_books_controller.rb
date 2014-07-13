class Campus::AddressBooksController < ApplicationController
  
  def index
    @search = params[:search]
    @address_books = AddressBook.where('name ILIKE ?', "#{@search}%")
  end
end