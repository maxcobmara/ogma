class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_locale
  before_filter { |c| Authorization.current_user = c.current_user }
  helper :bootstrap_icon, :devise
  helper_method :mailbox, :conversation

  #set current user for development
  #def current_user
    #Login.first
  #end
  
  #http://rails-bestpractices.com/posts/47-fetch-current-user-in-models (sample:travel_requests)
  def set_current_user
    User.current = current_user
  end
  
  ### http://stackoverflow.com/questions/19861067/activemodelforbiddenattributeserror-in-commentscontrollercreate?rq=1
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  ###

  def after_sign_in_path_for(resource)
   '/dashboard'
  end
  
  def after_sign_out_path_for(resource)
    "http://#{request.host}:3000/logout"
  end
  

  private

    def set_locale
      I18n.locale = params[:locale] if params[:locale].present?
      # current_user.locale
      # request.subdomain
      # request.env["HTTP_ACCEPT_LANGUAGE"]
      # request.remote_ip
    end

    def default_url_options(options = {})
      {locale: I18n.locale}
    end

    def permission_denied
      flash[:error] = "Sorry, you are not allowed to access that page."
      redirect_to dashboard_path
    end
    
    def mailbox
      @mailbox ||= current_user.mailbox
    end
    def conversation
      @conversation ||= mailbox.conversations.find(params[:id])
    end
end
