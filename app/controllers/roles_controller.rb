class RolesController < ApplicationController
  filter_resource_access
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  # GET /roles
  # GET /roles.xml
  def index
    @search = Role.search(params[:q])
    @roles = @search.result
    @roles = @roles.page(params[:page]||1)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @role = Role.find(params[:id])

    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to roles_path, :notice =>t('role.caption')+t('actions.updated')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :authname, :description)
    end
end
