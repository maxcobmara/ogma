class UsersController < ApplicationController
#  filter_resource_access
 filter_access_to :index, :link, :user_list, :attribute_check => false
 filter_access_to :edit, :update, :destroy, :attribute_check => true
  
 before_action :set_user, only: [:show, :edit, :update, :destroy]
 before_action :set_index_list, only: [:index, :user_list]
 before_filter :load_userable, only: [:link, :edit, :update]

 def index
   @all=@users
   @users = @users.page(params[:page]||1)
   @user_by_type = @users.group_by(&:userable_type)
 end

 def link
  if user_signed_in?
   @user = current_user
   @entity = Staff.where(coemail: current_user.email).first || Student.where(semail: current_user.email).first
  end
 end

 def edit
 end

 def update
    @user.roles << Role.find(3) if params[:user][:userable_type]=="Student" && @user.roles.count==0 
    respond_to do |format|
       if @user.update(user_params)
         format.html { redirect_to "/dashboard", notice: (t 'user.title')+(t 'actions.updated') }
         format.json { head :no_content }
	 format.js
       else
         format.html { render action: 'link' }
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
     end
 end
 
 def destroy
   respond_to do |format|
     if @user.destroy
       format.html { redirect_to users_path, notice: (t 'user.title')+(t 'actions.deleted') }
       format.json { head :no_content }
     else
       format.html { render users_path }
       format.json { render json: @user.errors, status: :unprocessable_entity }
     end
   end
 end
 
 def user_list
   respond_to do |format|
      format.pdf do
        pdf = User_listPdf.new(@users, view_context, current_user)
        send_data pdf.render, filename: "user_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
 end

 private
   # Use callbacks to share common setup or constraints between actions.
   def set_user
     @user = User.find(params[:id])
   end
   
   def set_index_list
     roles=current_user.roles.map(&:authname)
     if roles.include?('developer') || (roles.include?('administration') && User.icms_acct.include?(current_user.id))
       @search = User.search(params[:q])
     else
       @search = current_user.college.users.where.not(id: User.icms_acct).search(params[:q])  #http://stackoverflow.com/questions/32300349/restrict-index-view-to-users-records NOTE-0 voted
     end
     @users = @search.result
   end

   # Never trust parameters from the scary internet, only allow the white list through.
   def user_params
     params.require(:user).permit(:email, :userable_id, :userable_type, {:role_ids => []}, :college_id, {:data => []})
   end

   def load_userable
     resource, id = request.path.split('/')[1, 2]
     #id = @current_user.userable.id #HACK - no idea how to do, this path (index pg) --> http://localhost:3003/users?locale=en --> listing of all record, has no ID
     @userable = resource.singularize.classify.constantize.find(id)
   end


end
