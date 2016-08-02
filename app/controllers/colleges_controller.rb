class CollegesController < ApplicationController
  filter_resource_access
  before_action :set_college, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @colleges=College.all
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
    @college.destroy
    respond_with(@college)
  end

  private
    def set_college
      @college = College.find(params[:id])
    end

    def college_params
      params.require(:college).permit(:code, :name,{ :data=>[]}, :address, :phone, :fax, :email, :logo)
    end
end
