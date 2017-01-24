class Campus::PagesController < ApplicationController
  #filter_resource_access
  filter_access_to :index, :new, :create, :page_list, :attribute_check => false
  filter_access_to :show, :flexipage, :edit, :update, :destroy, :attribute_check => true
  before_action :set_page, only: [:show, :edit, :update, :destroy,  :flexipage]
  
  def index
#     current_roles=current_user.roles.pluck(:authname)
#     @search=Page.search(params[:q])
#     if current_roles.include?('developer')
#       @search=Page.search(params[:q])
#     else
#       @search=Page.where(admin: true).search(params[:q])
#     end
    @search=Page.search(params[:q])
    @pages= @search.result.order(position: :asc)
    #@pages= @pages.page(params[:page]||1)  # TODO - same parameter name in use  --> :page
  end

  def new
    #@page = Page.new
    @page= Page.new(:parent_id => params[:parent_id])
  end

  def show
  end
  
  def flexipage
  end

  def edit
  end

  def create 
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        flash[:notice] = (t 'campus.pages.title')+(t 'actions.created')
        format.html { redirect_to campus_pages_path}
        format.json { render action: 'show', status: :created, location: @page }
      else
        format.html { render action: 'new' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @page.update(page_params)
        flash[:notice] = (t 'campus.pages.title')+(t 'actions.updated')
        format.html { redirect_to flexipage_campus_page_path(@page)}
        format.json { render action: 'show', status: :created, location: @page }
      else
        format.html { render action: 'new' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  def page_list
#     current_roles=current_user.roles.pluck(:authname)
#     @search=Page.search(params[:q])
#     if current_roles.include?('developer')
#       @search=Page.search(params[:q])
#     else
#       @search=Page.where(admin: true).search(params[:q])
#     end
    @search=Page.search(params[:q])
    @pages= @search.result.order(position: :asc)
    respond_to do |format|
      format.pdf do
        pdf = Page_listPdf.new(@pages, view_context, current_user.college)
        send_data pdf.render, filename: "page_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
	private
	  # Use callbacks to share common setup or constraints between actions.
	  def set_page
	    @page = Page.find(params[:id])
	  end

	  # Never trust parameters from the scary internet, only allow the white list through.
	  def page_params
	    params.require(:page).permit(:name, :title, :body, :body2, :body3, :admin, :parent_id, :navlabel, :position, :redirect, :action_name, :controller_name, :college_id, {:data => []})
	  end
end