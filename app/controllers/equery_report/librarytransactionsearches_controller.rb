class EqueryReport::LibrarytransactionsearchesController < ApplicationController
  def new
    @searchlibrarytransactiontype = params[:searchlibrarytransactiontype]
    @librarytransactionsearch = Librarytransactionsearch.new
  end

  def create
    @searchlibrarytransactiontype = params[:method]
    @librarytransactionsearch = Librarytransactionsearch.new(librarytransactionsearch_params)
    if @librarytransactionsearch.save
      redirect_to equery_report_librarytransactionsearch_path(@librarytransactionsearch)
    else
      render :action => 'new'
    end
  end

  def show
    @librarytransactionsearch = Librarytransactionsearch.find(params[:id])
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def librarytransactionsearch_params
      params.require(:librarytransactionsearch).permit(:accumbookloan, :programme, :fines, :bookloans, :yearstat, :details, :college_id, [:data => {}])
    end
    
end 
