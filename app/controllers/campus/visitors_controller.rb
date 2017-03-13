class Campus::VisitorsController < ApplicationController
  filter_access_to :index, :new, :create, :visitor_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  
  before_action :set_visitor, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @search = Visitor.search(params[:q])
    @visitors = @search.result
    @visitors = @visitors.page(params[:page]||1)
    respond_with(@visitors)
  end

  def show
    respond_with(@visitor)
  end

  def new
    @visitor = Visitor.new
    respond_with(@visitor)
  end

  def edit
  end

  def create
    @visitor = Visitor.new(visitor_params)

    respond_to do |format|
      if @visitor.save
        format.html { redirect_to campus_visitors_path, notice:  (t 'campus.visitors.title')+(t 'actions.created')}
        format.json { render action: 'show', status: :created, location: @visitor }
      else
        format.html { render action: 'new' }
        format.json { render json: @visitor.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @visitor.update(visitor_params)
    respond_to do |format|
      if @visitor.save
        format.html { redirect_to campus_visitor_path(@visitor), notice:  (t 'campus.visitors.title')+(t 'actions.updated')}
        format.json { render action: 'show', status: :created, location: @visitor }
      else
        format.html { render action: 'edit' }
        format.json { render json: @visitor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @visitor.destroy
    respond_to do |format|
      format.html { redirect_to campus_visitors_path, notice: (t 'campus.visitors.title')+(t 'actions.removed') }
      format.json { head :no_content }
    end
  end
  
  def visitor_list
    @search = Visitor.search(params[:q])
    @visitors = @search.result
    respond_to do |format|
      format.pdf do
        pdf = Visitor_listPdf.new(@visitors, view_context, current_user.college)
        send_data pdf.render, filename: "visitor_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end

  private
    def set_visitor
      @visitor = Visitor.find(params[:id])
    end
      
    def visitor_params
      params.require(:visitor).permit(:name, :icno, :rank_id, :position, :title_id, :phoneno, :hpno, :email, :expertise, :corporate, :department, :address_book_id)
    end
end
