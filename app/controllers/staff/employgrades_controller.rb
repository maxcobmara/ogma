class Staff::EmploygradesController < ApplicationController
  filter_resource_access
  before_action :set_employgrade, only: [:show, :edit, :update, :destroy]
  # GET /employgrades
  # GET /employgrades.xml

  def index
    @search = Employgrade.search(params[:q])
    @employgrades = @search.result           #@search.result.sort_by{|t|@arr3.find_all{|u|t.id==u}}  #@search.result.sort_by{|t|@arr3.each{|u|  t.id==u }}
    
    # TODO refactor this - START - 13Jan2017-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    maritim = [     24, 22, 20,  18,     16,  14, 13, 12, 10,   8,  [5,6],   nil,  4,    2,    1]             #-refer ..Home/Desktop/APMM Kuantan ICMS/[0] Format, Ref/Gred.pdf
    non_maritim=[54, 52, 48, "46A", 44,  41, 41, 38, 36,  32,    29,   27,  22,  20,  17]

    @ahash={}
    0.upto(maritim.size-1).each{|cnt| @ahash[cnt]=[maritim[cnt], non_maritim[cnt]]}
    #{0=>[24, 54], 1=>[22, 52], 2=>[20, 48], 3=>[18, "46A"], 4=>[16, 44], 5=>[14, 41], 6=>[13, 41], 7=>[12, 38], 8=>[10, 36], 9=>[8, 32], 10=>[[5, 6], 29], 11=>[4, 22], 12=>[2, 20], 13=>[1, 17]} 

    m_gradesets=Employgrade.where('name ILIKE(?) or name ILIKE(?)', "xa%", "XA%").select(:id, :name)                      #.pluck(:name)             #[20,16,24,14]
    nm_gradesets=Employgrade.where.not('name ILIKE(?) or name ILIKE(?)', "x%", "X%").select(:id, :name)                  #.pluck(:name)       #[48, 41, 44, 17, 32]
    m_grds=@employgrades.where('name ILIKE(?) or name ILIKE(?)', "xa%", "XA%")           #Employgrade.where('name ILIKE(?) or name ILIKE(?)', "xa%", "XA%")
    nm_grds=@employgrades.where.not('name ILIKE(?) or name ILIKE(?)', "x%", "X%")       #Employgrade.where.not('name ILIKE(?) or name ILIKE(?)', "x%", "X%")
    arr=[]
    arr2=[]
    arr3=[]
    arr4=[]
    cntt=0
    cntt2=0
    cntt_nm=Employgrade.where.not('name ILIKE(?) or name ILIKE(?)', "x%", "X%").where('name ilike(?)', "%41").count
    @ahash.each do |k, v|
        #############
      
        for m_gradeset in m_gradesets.sort_by(&:name)
          x=m_gradeset.name.gsub(/[^0-9]/, "").to_i
          if x==v[0]   
            arr << m_gradeset.name
	    arr3 << m_gradeset.id
	  end
	  if k==10
	    if v[0].include?(x)
	      arr << m_gradeset.name
	      arr3 << m_gradeset.id
	    end
	  end
        end
	for nm_gradeset in nm_gradesets.sort_by(&:name)
	  y=nm_gradeset.name.gsub(/[^0-9]/, "").to_i
	  if y==v[1] && (y !=41 || (y==41 && cntt < cntt_nm))    
	    arr2 << nm_gradeset.name
	    arr3 << nm_gradeset.id
	    cntt+=1 if v[1]==41
	  end
	end
	#############
	for m_grd in m_grds.sort_by(&:name)
	  be4slash, afterslash=m_grd.name.split("/")
	  x=be4slash.gsub(/[^0-9]/, "").to_i							#m_grd.name.gsub(/[^0-9]/, "").to_i
          if x==v[0]   
            arr4 << m_grd
	  end
	  if k==10
	    if v[0].include?(x)
	      arr4 << m_grd
	    end
	  end
	end
	for nm_grd in nm_grds.sort_by(&:name)
	  be4slash, afterslash=nm_grd.name.split("/")
	  y=be4slash.gsub(/[^0-9]/, "").to_i							#nm_grd.name.gsub(/[^0-9]/, "").to_i
          if y==v[1] && (y !=41 || (y==41 && cntt2 < cntt_nm))    
            arr4 << nm_grd
	    cntt2+=1 if v[1]==41
	  end
	end
	#############
#         cntt+=1 if v[1]==41
    end
    
    @arr=arr
    @arr2=arr2
    @arr3=arr3
    @arr4=arr4
    # TODO refactor this - END - 13Jan2017-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ##########

    @employgrades = Kaminari.paginate_array(@arr4).page(params[:page]||1) #@employgrades.page(params[:page]||1)

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
  
  private
  # Use callbacks to share common setup or constraints between actions.
    def set_employgrade
      @employgrade = Employgrade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employgrade_params
      params.require(:employgrade).permit(:name, :group_id, :college_id, {:data => []})
    end

end
