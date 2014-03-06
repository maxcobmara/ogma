class DocumentsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  #filter_access_to :all#filter_resource_access #temp 5Apr2013
  # GET /documents
  # GET /documents.xml
  def index

    @search = Document.search(params[:q])
    @documents = @search.result
    @documents_pagi = @documents.page(params[:page]||1)
    @current_user = current_user.staff_id || '' 
  
    respond_to do |format|
      format.html # index.html.erb
      format.js   #{ render :js => @documents }
      format.xml  { render :xml => @documents }
    end
  end

  # GET /documents/1
   # GET /documents/1.xml
   def show
     @document = Document.find(params[:id])

     respond_to do |format|
       format.html # show.html.erb
       format.xml  { render :xml => @document }
     end
   end

   # GET /documents/new
   # GET /documents/new.xml
   def new
     @document = Document.new

     respond_to do |format|
       format.html # new.html.erb
       format.xml  { render :xml => @document }
     end
   end

   # GET /documents/1/edit
   def edit
     @document = Document.find(params[:id])
   end
  
   def download
     @document = Document.find(params[:id])
     send_file @document.data.path, :type => @document.data_content_type
   end

   # POST /documents
   # POST /documents.xml
   def create
     @document = Document.new
     @document.staff_ids = []
     @document.staff_ids = Document.set_recipient(params[:document][:to_name])
     @document.serialno= params[:document][:serialno]
     @document.refno = params[:document][:refno]
     @document.category = params[:document][:category]
     @document.title = params[:document][:title]
     #-------this part for all dates---------http://accidentaltechnologist.com/ruby-on-rails/damn-you-rails-multiparameter-attributes/
     @document.letterdt = Date.new(params[:document][:"letterdt(1i)"].to_i,params[:document][:"letterdt(2i)"].to_i,params[:document][:"letterdt(3i)"].to_i)
     @document.letterxdt = Date.new(params[:document][:"letterxdt(1i)"].to_i,params[:document][:"letterxdt(2i)"].to_i,params[:document][:"letterxdt(3i)"].to_i)
     @document.cc1date = Date.new(params[:document][:"cc1date(1i)"].to_i,params[:document][:"cc1date(2i)"].to_i,params[:document][:"cc1date(3i)"].to_i)
     #-------this part for all dates---------http://accidentaltechnologist.com/ruby-on-rails/damn-you-rails-multiparameter-attributes/
     @document.from = params[:document][:from]
     @document.stafffiled_id = params[:document][:stafffiled_id]
     @document.file_id = params[:document][:file_id]
     @document.closed = params[:document][:closed]
     @document.data_file_name = params[:document][:data_file_name]
     @document.data_content_type = params[:document][:data_content_type]
     @document.data_file_size = params[:document][:data_file_size]
     @document.data_updated_at = params[:document][:data_updated_at]
     @document.otherinfo = params[:document][:otherinfo]
     @document.cctype_id= params[:document][:cctype_id]
     @document.prepared_by = params[:document][:prepared_by]
    
     respond_to do |format|
       if @document.save
         flash[:notice] = 'Document was successfully created.'
         format.html { redirect_to(@document) }
         format.xml  { render :xml => @document, :status => :created, :location => @document}
       else
         format.html { render :action => "new" }
         format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
       end
     end
    
   end

   # PUT /documents/1
   # PUT /documents/1.xml
   def update
     	 @document = Document.find(params[:id])
       @document.staff_ids = []
       @document.staff_ids = Document.set_recipient(params[:document][:to_name])
       @document.serialno= params[:document][:serialno]
       @document.refno = params[:document][:refno]
       @document.category = params[:document][:category]
       @document.title = params[:document][:title]
       #-------this part for all dates---------http://accidentaltechnologist.com/ruby-on-rails/damn-you-rails-multiparameter-attributes/
       @document.letterdt = Date.new(params[:document][:"letterdt(1i)"].to_i,params[:document][:"letterdt(2i)"].to_i,params[:document][:"letterdt(3i)"].to_i)
       @document.letterxdt = Date.new(params[:document][:"letterxdt(1i)"].to_i,params[:document][:"letterxdt(2i)"].to_i,params[:document][:"letterxdt(3i)"].to_i)
       @document.cc1date = Date.new(params[:document][:"cc1date(1i)"].to_i,params[:document][:"cc1date(2i)"].to_i,params[:document][:"cc1date(3i)"].to_i)
       #-------this part for all dates---------http://accidentaltechnologist.com/ruby-on-rails/damn-you-rails-multiparameter-attributes/
       @document.from = params[:document][:from]
       @document.stafffiled_id = params[:document][:stafffiled_id]
       @document.file_id = params[:document][:file_id]
       @document.closed = params[:document][:closed]
       @document.data_file_name = params[:document][:data_file_name]
       @document.data_content_type = params[:document][:data_content_type]
       @document.data_file_size = params[:document][:data_file_size]
       @document.data_updated_at = params[:document][:data_updated_at]
       @document.otherinfo = params[:document][:otherinfo]
       @document.cctype_id= params[:document][:cctype_id]
       @document.prepared_by = params[:document][:prepared_by]
      
         respond_to do |format|
     	  if @document.update_attributes(:staff_ids => @document.staff_ids, :serialno => @document.serialno, :refno => @document.refno,:category => @document.category,
 :title => @document.title,:letterdt => @document.letterdt,:letterxdt => @document.letterxdt,:cc1date => @document.cc1date,:from => @document.from,:stafffiled_id => @document.stafffiled_id,
 :file_id => @document.file_id,:closed => @document.closed,:data_file_name => @document.data_file_name, :data_content_type => @document.data_content_type,:data_file_size => @document.data_file_size,
 :data_updated_at => @document.data_updated_at,:otherinfo => @document.otherinfo,:cctype_id => @document.cctype_id,:prepared_by => @document.prepared_by)	
             flash[:notice] = 'Document was successfully updated.'
             format.html { redirect_to(@document) }
             format.xml  { head :ok }
           else
             format.html { render :action => "edit" }
             format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
           end
         end
   
   end

   # DELETE /documents/1
   # DELETE /documents/1.xml
   def destroy
     @document = Document.find(params[:id])
     @document.destroy

     respond_to do |format|
       format.html { redirect_to(documents_url) }
       format.xml  { head :ok }
     end
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
   
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @documents = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:serialno, :refno, :category, :title, :from, :stafffiled_id, :letterdt, :letterxdt, :sender)
    end
end
