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
  end
end
