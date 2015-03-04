class UsersController < ApplicationController

 before_action :set_user, only: [:show, :edit, :update, :destroy]
 before_filter :load_userable, only: [:link, :edit, :update]


 def index
   @search = User.search(params[:q])
   @users = @search.result
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
    respond_to do |format|
       if @user.update(user_params)
         format.html { redirect_to "/dashboard", notice: 'User was successfully updated.' }
         format.json { head :no_content }
	 format.js
       else
         format.html { render action: 'link' }
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
     end
 end

 private
   # Use callbacks to share common setup or constraints between actions.
   def set_user
     @user = User.find(params[:id])
   end

   # Never trust parameters from the scary internet, only allow the white list through.
   def user_params
     params.require(:user).permit(:email, :userable_id, :userable_type, {:role_ids => []})
   end

   def load_userable
     resource, id = request.path.split('/')[1, 2]
     #id = @current_user.userable.id #HACK - no idea how to do, this path (index pg) --> http://localhost:3003/users?locale=en --> listing of all record, has no ID
     @userable = resource.singularize.classify.constantize.find(id)
   end


end
