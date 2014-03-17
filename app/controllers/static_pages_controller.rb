class StaticPagesController < ApplicationController
  def home
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
