class CollegesController < ApplicationController
 # filter_resource_access
  filter_access_to :index, :new, :create, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  before_action :set_college, only: [:show, :edit, :update]

  respond_to :html

  def index
    if current_user.college.code=="tpsb" || current_user.email.split("@")[1]=="teknikpadu.com"
      @colleges=College.all
    else
      @colleges=College.where(id: current_user.college_id)
    end
    
#     @search = College.search(params[:q])
#     @colleges = @search.result.page(params[:page]).per(5)
    #@active = :college
    #respond_with(@colleges)
  end

  def show
    respond_with(@college)
  end

  def new
    @college = College.new
    respond_with(@college)
  end

  def edit
  end

  def create
    @college = College.new(college_params)
    @college.save
    respond_with(@college)
  end

  def update
    @college.update(college_params)
    respond_with(@college)
  end

  def destroy
    @college=College.find(params[:id])
    respond_to do |format|
       if @college.destroy
         format.html { redirect_to colleges_path, notice: (t 'college.title')+(t 'actions.deleted') }
         format.json { head :no_content }
       else
         format.html { redirect_to college_path(@college), notice: (t 'college.restrict_deletion')}
         format.json { render json: @college.errors, status: :unprocessable_entity }
       end
     end
    
  end

  private
    def set_college
      if current_user.college.code=="tpsb" || current_user.email.split("@")[1]=="teknikpadu.com"
        @college=College.find(params[:id])
      else
        @college = College.find(current_user.college_id)
      end
    end

    def college_params
      params.require(:college).permit(:code, :name,{ :data=>[]}, :address, :phone, :fax, :email, :logo)
    end
end
