class EqueryReport::DocumentsearchesController < ApplicationController
  filter_resource_access
  
  def new
    @documentsearch = Documentsearch.new
  end

  def create
    @documentsearch = Documentsearch.new(params[:documentsearch])
    if @documentsearch.save
      redirect_to equery_report_documentsearch_path(@documentsearch)
    else
      render :action => 'new'
    end
  end

  def show
    @documentsearch = Documentsearch.find(params[:id])
    @documents=@documentsearch.documents.page(params[:page]).per(10)
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def documentsearch_params
      params.require(:documentsearch).permit(:refno, :category, :title, :letterdt, :letterxdt, :sender, :file_id, :closed, :letterdtend, :letterxdtend, :from, :method, :college_id, [:data => {}])
    end
    
    #from - '1' for select all record, from - '0' for search w status: (true or false)
    #method - use to send @searchdoctype value, should form validation fails

end
