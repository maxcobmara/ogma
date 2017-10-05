class GroupsController < ApplicationController
  filter_access_to :index, :new, :create, :group_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
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
  
  def group_list
    @search = Group.search(params[:q])
    @groups = @search.result
    respond_to do |format|
      format.pdf do
        pdf = Group_listPdf.new(@groups, view_context, current_user)
        send_data pdf.render, filename: "group_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
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
