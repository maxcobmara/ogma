class UsersController < ApplicationController

 def link
  if user_signed_in?
   @user = current_user
   @entity = Staff.where(coemail: current_user.email).first || Student.where(semail: current_user.email).first
  end
 end

 private
   # Use callbacks to share common setup or constraints between actions.
   def set_user
     @user = User.find(params[:id])
   end

   # Never trust parameters from the scary internet, only allow the white list through.
   def user_params
     params.require(:user).permit(:email)
   end

end
