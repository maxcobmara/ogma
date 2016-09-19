# class Staff::ShiftHistoriesController < ApplicationController
#   filter_resource_access
#   before_action :set_title, only: [:show, :edit, :update, :destroy]
#   # GET /titles
#   # GET /titles.xml
#   def index
#     @search = ShiftHistory.search(params[:q])
#     @shift_histories = @search.result
#     @shift_histories = @shift_histories.page(params[:page]||1)
#     
#     respond_to do |format|
#       format.html # index.html.erb
#       format.xml  { render :xml => @shift_histories }
#     end
#   end
# 
#   def new
#     @shift_history=ShiftHistory.new
#   end
#   
#   def create
#     @staff_history=ShiftHistory.new(shift_history_params)
#     respond_to do |format|
#       if @staff_history.save
#         format.html { redirect_to staff_title_path(@shift_history), :notice =>t('staff.titles.title')+t('actions.created')}
#         format.xml  { head :ok }
#       else
#         format.html { render :action => "edit" }
#         format.xml  { render :xml => @shift_history.errors, :status => :unprocessable_entity }
#       end
#     end
#   end
#   
#   # GET /titless/1/edit
#   def edit
#     @shift_history = ShiftHistory.find(params[:id])
#   end
# 
#   # PUT /titles/1
#   # PUT /titles/1.xml
#   def update
#     @shift_history = ShiftHistory.find(params[:id])
# 
#     respond_to do |format|
#       if @shift_history.update(title_params)
#         format.html { redirect_to staff_title_path(@shift_history), :notice =>t('staff.staff_history.title')+t('actions.updated')}
#         format.xml  { head :ok }
#       else
#         format.html { render :action => "edit" }
#         format.xml  { render :xml => @shift_history.errors, :status => :unprocessable_entity }
#       end
#     end
#   end
#   
#   def show
#     @shift_history = ShiftHistory.find(params[:id])
#   end
#   
#   def destroy
#     @shift_history = ShiftHistory.find(params[:id])
#     @shift_history.destroy
# 
#     respond_to do |format|
#       format.html { redirect_to(staff_shift_histories_url) }
#       format.xml  { head :ok }
#     end
#   end
#   
#   private
#   # Use callbacks to share common setup or constraints between actions.
#     def set_shift_history
#       @shift_history = ShiftHistory.find(params[:id])
#     end
# 
#     # Never trust parameters from the scary internet, only allow the white list through.
#     def shift_history_params
#       params.require(:title).permit(:name, :start_at, :end_at, :college_id, {:data => []})
#     end
# end
