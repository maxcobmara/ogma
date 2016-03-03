class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @search = Group.search(params[:q])
    @groups = @search.result.page(params[:page]).per(5)
    @active = :group
    #respond_with(@groups)
  end

  def show
    respond_with(@group)
  end

  def new
    @group = Group.new
    respond_with(@group)
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.save
    respond_with(@group)
  end

  def update
    @group.update(group_params)
    respond_with(@group)
  end

  def destroy
    @group.destroy
    respond_with(@group)
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      # TODO
      #params.require(:group).permit(:name, :description, :members)
      #params.require(:exam_template).permit(:name, :created_by, :deleted_at, {:question_count => @allowed_types})
      params.require(:group).permit!
    end
end
