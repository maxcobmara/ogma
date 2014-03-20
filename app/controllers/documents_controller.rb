class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  #filter_access_to :all#filter_resource_access #temp 5Apr2013
  # GET /documents
  # GET /documents.xml
  def index
    @search = Document.search(params[:q])
    @documents = @search.result
    @documents_pagi = @documents.page(params[:page]||1) 
  end

  # GET /documents/1
   # GET /documents/1.xml
   def show
   end

   # GET /documents/new
   # GET /documents/new.xml
   def new
     @document = Document.new
   end

   # GET /documents/1/edit
   def edit
   end
  
   def download
     @document = Document.find(params[:id])
     send_file @document.data.path, :type => @document.data_content_type
   end

   def generate_report
       @bb = params[:locals][:class_type]
       @bob = params[:locals][:dodo]
       @bob2 = params[:locals][:dudu].to_s
       @sd = params[:locals][:startdate]
       @ed = params[:locals][:enddate]
       if @bb == '1'
           if (@bob2 == nil || @bob2 == '') && (@sd=='' && @ed=='')
             @documents = Document.search(@bob)
           elsif (@bob==nil || @bob == '') && (@sd=='' && @ed=='')
             @documents = Document.search2(@bob2)
           elsif  (@bob2 == nil || @bob2 == '') &&  (@bob==nil || @bob == '')  
               #----------this part is for record selection by date-----------------------
               if @sd=='' && @ed=='' 
                   @documents = Document.find(:all)
               elsif @sd!='' && @ed ==''
                   @documents = Document.find(:all, :conditions=> ['letterxdt=?',"#{@sd}"])
               elsif @ed!='' && @sd ==''
                   @documents = Document.find(:all, :conditions=> ['letterxdt=?',"#{@ed}"])
               elsif @sd!='' && @ed!=''
                   @documents = Document.find(:all, :conditions=> ["letterxdt>=? AND letterxdt<=?","#{@sd}","#{@ed}"])
                   #@documents = Document.find(:all, :conditions=> ['letterdt=?',"2013-04-01"])  #for testing
               end
               #----------this part is for record selection by date-----------------------
           end
       end
       render :layout => 'report'
   end


   # POST /documents
   # POST /documents.xml
   def create
     @document = Document.new(document_params)

     respond_to do |format|
       if @document.save
         format.html { redirect_to @document, notice: 'Document was successfully created.' }
         format.json { render action: 'show', status: :created, location: @document }
       else
         format.html { render action: 'new' }
         format.json { render json: @document.errors, status: :unprocessable_entity }
       end
     end
   end

   # PUT /documents/1
   # PUT /documents/1.xml
   def update
     respond_to do |format|
       if @document.update(document_params)
         format.html { redirect_to document_path, notice: 'Document was successfully updated.' }
         format.json { head :no_content }
       else
         format.html { render action: 'edit' }
         format.json { render json: @document.errors, status: :unprocessable_entity }
       end
     end
   end
   
   # DELETE /documents/1
   # DELETE /documents/1.xml
  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    respond_to do |format|
      
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end
   
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:serialno, :refno, :category, :title, :from, :stafffiled_id, :letterdt, :letterxdt, :sender, :circulate_to)
    end

end
