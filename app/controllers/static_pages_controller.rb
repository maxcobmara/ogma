class StaticPagesController < ApplicationController
  helper Notifications

  def home
   @bulletins = Bulletin.order(publishdt: :desc).limit(10)
  end

  def help
  end

  def about
  end

  def contact
  end

  def dashboard
   @bulletins = Bulletin.order(publishdt: :desc).limit(10)
    if user_signed_in?
    else
      redirect_to("http://#{request.host}:3003", notice: (t 'user.sign_in_required')) 
    end
  end
end
