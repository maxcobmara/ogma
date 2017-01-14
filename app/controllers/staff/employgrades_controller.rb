class Staff::EmploygradesController < ApplicationController
  filter_access_to :index, :new, :create, :employgrade_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  
  before_action :set_employgrade, only: [:show, :edit, :update, :destroy]
  before_action :set_sorted_grade, only: [:index, :employgrade_list]
  # GET /employgrades
  # GET /employgrades.xml

  def index
    if current_user.college.code=='amsas'
      @employgrades = Kaminari.paginate_array(@egrades).page(params[:page]||1)
    else
      @employgrades = @employgrades.page(params[:page]||1)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @employgrades }
    end
  end

  def new
    @employgrade=Employgrade.new
  end
  
  def create
    @employgrade=Employgrade.new(employgrade_params)
    respond_to do |format|
      if @employgrade.save
        format.html { redirect_to staff_employgrades_path, :notice =>t('staff.employgrades.title')+t('actions.created')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employgrade.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /employgrades/1/edit
  def edit
    @employgrade = Employgrade.find(params[:id])
  end

  # PUT /employgrades/1
  # PUT /employgrades/1.xml
  def update
    @employgrade = Employgrade.find(params[:id])

    respond_to do |format|
      if @employgrade.update(employgrade_params)
        format.html { redirect_to staff_employgrades_path, :notice =>t('staff.employgrades.title')+t('actions.updated')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employgrade.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @employgrade = Employgrade.find(params[:id])
  end
  
  def destroy
    respond_to do |format|
      if @employgrade.destroy
        format.html { redirect_to(staff_employgrades_url) }
      else
        errors_line=""
        @employgrade.errors.each{|k,v| errors_line+="<li>#{v}</li>"}
        format.html { redirect_to staff_employgrade_path(@employgrade), notice: ("<span style='color: red;'>"+ I18n.t('activerecord.errors.invalid_removal')+"<ol>"+errors_line+"</ol></span>").html_safe}
      end
      format.xml  { head :ok }
    end
  end
  
  def employgrade_list
    if current_user.college.code=='amsas'
      @employgrades=@egrades
    else
      @employgrades=@employgrades
    end
    respond_to do |format|
      format.pdf do
        pdf = Employgrade_listPdf.new(@employgrades, view_context, current_user.college)
        send_data pdf.render, filename: "employgrade_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
    def set_employgrade
      @employgrade = Employgrade.find(params[:id])
    end
    
    def set_sorted_grade
        @search = Employgrade.search(params[:q])
        @employgrades = @search.result           #@search.result.sort_by{|t|@arr3.find_all{|u|t.id==u}}
        @egrades=Employgrade.sorted_grades(@employgrades)  
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employgrade_params
      params.require(:employgrade).permit(:name, :group_id, :college_id, {:data => []})
    end

end
