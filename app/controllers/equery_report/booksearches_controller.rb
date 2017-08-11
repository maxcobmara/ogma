class EqueryReport::BooksearchesController < ApplicationController
  filter_access_to :new, :create, :new_stock_list, :new_book_summary, :attribute_check => false
  filter_access_to :show, :attribute_check => true
  
  def new
    @booksearch = Booksearch.new
  end
  
  def new_stock_list
    @booksearch = Booksearch.new
  end
  
  def new_book_summary
    @booksearch = Booksearch.new
  end

  def create
    @booksearch = Booksearch.new(booksearch_params)
    if @booksearch.save
      redirect_to equery_report_booksearch_path(@booksearch)
    else
      render :action => 'new'
    end
  end

  def show
    @booksearch = Booksearch.find(params[:id])
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def booksearch_params
      params.require(:booksearch).permit(:title, :author, :isbn, :accessionno, :classno, :accessionno_start, :accessionno_end, :stock_summary, :accumbookloan, :publisher, :college_id, [:data => {}])
    end
    
end