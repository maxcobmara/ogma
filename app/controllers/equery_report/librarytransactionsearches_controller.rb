class EqueryReport::LibrarytransactionsearchesController < ApplicationController
  def new
    @searchlibrarytransactiontype = params[:searchlibrarytransactiontype]
    @librarytransactionsearch = Librarytransactionsearch.new
  end

  def create
    #raise params.inspect
    @searchlibrarytransactiontype = params[:method]
    if @searchlibrarytransactiontype == '1' || @searchlibrarytransactiontype == 1
        @librarytransactionsearch = Librarytransactionsearch.new(librarytransactionsearch_params)
#         #--yearstat---
#         @aa=params[:yearstat][:"(1i)"] 
#         @bb=params[:yearstat][:"(2i)"]
#         @cc=params[:yearstat][:"(3i)"]
#         if @aa!=''    #&& @bb!='' && @cc!=''
#             @dadidu=@aa+'-'+'01'+'-'+'01'        #@bb+'-'+@cc  
#         else
#             @dadidu=''
#         end
#         @librarytransactionsearch.yearstat = @dadidu
#         #--yearstat---
    end 
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
