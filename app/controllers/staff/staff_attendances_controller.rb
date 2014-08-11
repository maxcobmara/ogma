class Staff::StaffAttendancesController < ApplicationController
  before_action :set_staff_attendance, only: [:show, :edit, :update, :destroy]
  
  # GET /staff_attendances
  # GET /staff_attendances.xml
  def index 
    @mylate_attendances = StaffAttendance.find_mylate
    @approvelate_attendances = StaffAttendance.find_approvelate
    
    @thumb_ids =  StaffAttendance.get_thumb_ids_unit_names(1)
    @unit_names = StaffAttendance.get_thumb_ids_unit_names(2)

    @all_thumb_ids = []
    @thumb_ids.each do |thumb_ids|
      @all_thumb_ids+= thumb_ids
    end  
	
    @search = StaffAttendance.search(params[:q])
    @staff_attendances2 = @search.result
    
    #hack for ALL unit
    if params[:q]==nil || (params[:q][:keyword_search]==nil)
      #@staff_attendances2 = @staff_attendances2.where('logged_at >? and logged_at<? and thumb_id IN(?)','2012-09-30','2012-11-01',@all_thumb_ids)
      #@staff_attendances2 = StaffAttendance.where('logged_at >? and logged_at<? and thumb_id IN(?)','2012-12-31','2014-12-01', @all_thumb_ids)
      @startdate = (Date.today.end_of_year-3.year).strftime('%Y-%m-%d')		#'2011-12-31'
      @enddate = (Date.today+1.day).strftime('%Y-%m-%d')				#'2014-08-10'					
      @staff_attendances2 = @staff_attendances2.where('logged_at >? and logged_at<? and thumb_id IN(?)',@startdate,@enddate,@all_thumb_ids)
    end
    
    @groupped_by_date = @staff_attendances2.group_by{|r|r.group_by_thingy}	#Active Records : relations
    @lookup={}
    @all_thumb_ids.each_with_index do |item, index|
	@lookup[item]=index
    end
    @dategroup_then_unit=[]
    @groupped_by_date.sort.reverse.each do |date2,sas2|
      sort_unit=sas2.sort_by{|item2| @lookup.fetch(item2.thumb_id)}
      @dategroup_then_unit<< sort_unit
    end
    @keluar_balik=[]
    @dategroup_then_unit.each do |sorted_date|
	sorted_date.each do |sorted_unit|
	  @keluar_balik<< sorted_unit
	end
    end
        
    @staff_attendances = Kaminari.paginate_array(@keluar_balik).page(params[:page]||1)    
    @ooo = @staff_attendances.group_by {|t| t.group_by_thingy }

    #Normal Array (diff fr @gropped_by_date)
    #group all attendances by DATE first for use - to determine last SA record of the day
    @group_sa_by_day=@keluar_balik.group_by{|t|t.group_by_thingy}	
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @staff_attendances }
    end
  end
   
  #start - import excel
  def import_excel
  end
  
  def import
      a=StaffAttendance.import(params[:file]) 
      msg=StaffAttendance.messages(a)     
      if a[:sye].count>0 || a[:ser].count>0 || a[:snu].count>0
	@invalid_year = a[:sye]
	@exist_records = a[:ser]
	@no_user = a[:snu]
        respond_to do |format|
          flash[:notice] = msg
          format.html { render action: 'import_excel' }
          flash.discard
        end
      else
	respond_to do |format|
	  format.html {redirect_to staff_staff_attendances_url, notice: msg}
	end
      end
  end
  
  def download_excel_format
    send_file ("#{::Rails.root.to_s}/public/excel_format/staff_attendance_import.xls")
  end
  #end - import excel
  
  # GET /staff_attendances/1
  # GET /staff_attendances/1.xml
  def show
    @staff_attendance = StaffAttendance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @staff_attendance }
    end
  end

  # GET /staff_attendances/new
  # GET /staff_attendances/new.xml
  def new
    @staff_attendance = StaffAttendance.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @staff_attendance }
    end
  end

  # GET /staff_attendances/1/edit
  def edit
    @staff_attendance = StaffAttendance.find(params[:id])
  end

  # POST /staff_attendances
  # POST /staff_attendances.xml
  def create
    @staff_attendance = StaffAttendance.new(params[:staff_attendance])

    respond_to do |format|
      if @staff_attendance.save
        format.html { redirect_to(@staff_attendance, :notice => 'StaffAttendance was successfully created.') }
        format.xml  { render :xml => @staff_attendance, :status => :created, :location => @staff_attendance }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @staff_attendance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /staff_attendances/1
  # PUT /staff_attendances/1.xml
  def update
    @staff_attendance = StaffAttendance.find(params[:id])

    respond_to do |format|
      if @staff_attendance.update_attributes(params[:staff_attendance])
        format.html { redirect_to(@staff_attendance, :notice => 'StaffAttendance was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @staff_attendance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /staff_attendances/1
  # DELETE /staff_attendances/1.xml
  def destroy
    @staff_attendance = StaffAttendance.find(params[:id])
    @staff_attendance.destroy

    respond_to do |format|
      format.html { redirect_to(staff_attendances_url) }
      format.xml  { head :ok }
    end
  end
  
  def manage
    @mylate_attendances = StaffAttendance.find_mylate
    @myearly_attendances = StaffAttendance.find_myearly
    @approvelate_attendances = StaffAttendance.find_approvelate
    @approveearly_attendances = StaffAttendance.find_approveearly

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @staff_attendances }
    end  
  end
  
  def approve
    @staff_attendance = StaffAttendance.find(params[:id])
  end
  
  
  
  def actionable
    StaffAttendance.update_all(["trigger=?", true], :id => params[:triggers])
    StaffAttendance.update_all(["trigger =?", false], :id => params[:ignores])
    redirect_to :back
  end
  
  def status
    @thismonthreds = StaffAttendance.this_month_red
    @lastmonthreds = StaffAttendance.last_month_red
    @prevmonthreds = StaffAttendance.previous_month_red
    
    @thismonthgreens = StaffAttendance.this_month_green
    @lastmonthgreens = StaffAttendance.last_month_green
    @prevmonthgreens = StaffAttendance.previous_month_green
  end
  
  def report
    #@dept_names=["Teknologi Maklumat","Perhotelan","Perpustakaan","Kaunter","Pembangunan","Kewangan & Stor","Perkhidmatan","Pentadbiran Am","Radiografi","Kejururawatan","Jurupulih Perubatan Anggota (Fisioterapi)","Jurupulih Perubatan Cara Kerja","Penolong Pegawai Perubatan","Pos Basik","Sains Perubatan Asas","Anatomi & Fisiologi","Sains Tingkahlaku","Komunikasi & Sains Pengurusan","Pembangunan Pelatih","Khidmat Sokongan Pelatih","Kokurikulum","Ketua Unit Penilaian & Kualiti"]
    @dept_names=["Teknologi Maklumat","Perhotelan","Perpustakaan","Kaunter","Kejuruteraan","Kewangan & Stor","Perkhidmatan","Pentadbiran Am","Radiografi","Kejururawatan","Jurupulih Perubatan Anggota (Fisioterapi)","Jurupulih Perubatan Cara Kerja","Penolong Pegawai Perubatan","Pengkhususan","Sains Perubatan Asas","Anatomi & Fisiologi","Sains Tingkahlaku","Komunikasi & Sains Pengurusan","Pembangunan Pelatih","Khidmat Sokongan Pelatih","Kokurikulum","Ketua Unit Penilaian & Kualiti"]   
    @dept_superiors = []
    @position_staff_ids = []
    @staff_in_department = []
    0.upto(21) do |count|
      @dept_superiors << Position.find(:first, :conditions=>['unit=?',@dept_names[count]])  #starting 23Feb2014-no changes-unit @ dept superior-usually w HIGHEST@FIRSTLY INSERTED
    end
    0.upto(21) do |countt|
        #@position_staff_ids << Position.find(:first, :conditions=>['unit=?',@dept_names[countt]], :order=>'id ASC').subtree.map(&:staff_id).uniq.delete_if{|x|x==nil}   
        #starting 23Feb2014 - Positon table - unit value - compulsory for staff (which work) under unit? (task & responsibilites format change)
        @position_staff_ids << Position.find(:all, :conditions=>['unit=?',@dept_names[countt]], :order=>'id ASC').map(&:staff_id).uniq.delete_if{|x|x==nil} 
    end
    0.upto(21) do |countt2|
        @staff_in_department << Staff.find(:all,:select=>:thumb_id,:conditions=>['id in (?)',@position_staff_ids[countt2]]).map(&:thumb_id)
    end
  end
  
  def monthly_weekly_report
    if request.post?
          #raise params.inspect
          @find_type = params[:list_submit_button]
          @superior_position_id = params[:superior_position_id]
          @dept_name = Position.find(:first, :conditions=>['id=?',@superior_position_id]).unit
    		  if @find_type == "Monthly Report"
    		      @aa=params[:month_year2][:"(1i)"]  #year
              @bb=params[:month_year2][:"(2i)"]  #month
              @cc='01'                      #params[:month_year][:"(3i)"] #day
              if @aa!='' && @bb!='' && @cc!=''
                  if @bb=='1'||@bb=='2'||@bb=='3'||@bb=='4'||@bb=='5'||@bb=='6'||@bb=='7'||@bb=='8'||@bb=='9'
                      @bb='0'+@bb
                  end
                  @dadidu=@aa+'-'+@bb+'-'+@cc
              else
                  @dadidu=''
              end
    		      @next_date = @dadidu.to_date+1.month  #(next month)
          elsif @find_type == "Weekly Report"    #  "Report for 2 Week" 
              @aa=params[:month_year1][:"(1i)"]  #year
              @bb=params[:month_year1][:"(2i)"]  #month
     		      @cc=params[:month_year1][:"(3i)"]      #day
              if @aa!='' && @bb!='' && @cc!=''
                  if @cc=='1'||@cc=='2'||@cc=='3'||@cc=='4'||@cc=='5'||@cc=='6'||@cc=='7'||@cc=='8'||@cc=='9'
                      @cc='0'+@cc
                  end
                  if @bb=='1'||@bb=='2'||@bb=='3'||@bb=='4'||@bb=='5'||@bb=='6'||@bb=='7'||@bb=='8'||@bb=='9'
                      @bb='0'+@bb
                  end
                  @dadidu=@aa+'-'+@bb+'-'+@cc
              else
                  @dadidu=''
              end
              @next_date = @dadidu.to_date+1.week  #(next week)
           elsif @find_type == "Daily Report"    
              @aa=params[:month_year3][:"(1i)"]  #year
              @bb=params[:month_year3][:"(2i)"]  #month
    		      @cc=params[:month_year3][:"(3i)"]      #day
              if @aa!='' && @bb!='' && @cc!=''
                 if @cc=='1'||@cc=='2'||@cc=='3'||@cc=='4'||@cc=='5'||@cc=='6'||@cc=='7'||@cc=='8'||@cc=='9'
                     @cc='0'+@cc
                 end
                 if @bb=='1'||@bb=='2'||@bb=='3'||@bb=='4'||@bb=='5'||@bb=='6'||@bb=='7'||@bb=='8'||@bb=='9'
                     @bb='0'+@bb
                 end
                 @dadidu=@aa+'-'+@bb+'-'+@cc
             else
                 @dadidu=''
             end
              @next_date = @dadidu.to_date+1.day 
           end
           #====refer model --> self.peep method==
           @hisstaff = Position.find(@superior_position_id).child_ids
           @hisstaffids = Position.find(:all, :select => "staff_id", :conditions => ["id IN (?)", @hisstaff]).map(&:staff_id)
           @thumbs = Staff.find(:all, :select => :thumb_id, :conditions => ["id IN (?)", @hisstaffids]).map(&:thumb_id)
           #======================================
           #*******************refer model --> self.find_approveearly --(is_approved==false)
           #@notapproved_lateearly=StaffAttendance.find(:all, :conditions => ["trigger=? AND is_approved =? AND thumb_id IN (?) ", true, true, @thumbs], :order => 'logged_at DESC').group_by {|t| t.thumb_id }
           #NOT APPROVED....
           @notapproved_lateearly=StaffAttendance.find(:all, :conditions => ["trigger=? AND is_approved =? AND thumb_id IN (?) AND logged_at>=? AND logged_at<?", true, false, @thumbs, @dadidu, @next_date], :order => 'logged_at DESC').group_by {|t| t.thumb_id }
           #LATE EARLY....regardless of APPROVAL status....
           @lateearly=StaffAttendance.find(:all, :conditions => ["trigger=? AND thumb_id IN (?) AND logged_at>=? AND logged_at<?", true, @thumbs, @dadidu, @next_date], :order => 'logged_at DESC').group_by {|t| t.thumb_id }
           #27June2013-display colour card STATUS accordingly
           
           #@color_status = 
           #**************************************
           #-------for reference-------
            #d1 = d.logged_at.in_time_zone('UTC').strftime('%Y-%m-%d').to_s  # logged_at.in_time_zone('UTC').strftime('%Y-%m-%d').to_s - 21June2013 - ADDED
		          #if d1 == @loop_date
           #-------for reference-------
           render :layout => 'report'
      end   #end for - if request.post?
  end
  
  def monthly_listing
    if request.post?
          @find_type = params[:list_submit_button]
    		  if @find_type == "Monthly Listing"
    		      #---------
    		      @dept_select = params[:dept_select]
              if @dept_select == "Teknologi Maklumat"
                  @staffthumb = params[:staffthumb1] 
              elsif @dept_select == "Perhotelan" 
                  @staffthumb = params[:staffthumb2] 
              elsif @dept_select == "Perpustakaan"
                  @staffthumb = params[:staffthumb3] 
              elsif @dept_select == "Kaunter"
                  @staffthumb = params[:staffthumb4] 
              elsif @dept_select == "Kejuruteraan"     #elsif @dept_select == "Pembangunan"
                  @staffthumb = params[:staffthumb5] 
              elsif @dept_select == "Kewangan & Stor"
                  @staffthumb = params[:staffthumb6] 
              elsif @dept_select == "Perkhidmatan"
                  @staffthumb = params[:staffthumb7] 
              elsif @dept_select == "Pentadbiran Am"
                  @staffthumb = params[:staffthumb8] 
              elsif @dept_select == "Radiografi"
                  @staffthumb = params[:staffthumb9] 
              elsif @dept_select == "Kejururawatan"
                  @staffthumb = params[:staffthumb10] 
              elsif @dept_select == "Jurupulih Perubatan Anggota (Fisioterapi)"
                  @staffthumb = params[:staffthumb11] 
              elsif @dept_select == "Jurupulih Perubatan Cara Kerja"
                  @staffthumb = params[:staffthumb12] 
              elsif @dept_select == "Penolong Pegawai Perubatan"
                  @staffthumb = params[:staffthumb13] 
              elsif @dept_select == "Pengkhususan"      #elsif @dept_select == "Pos Basik"
                  @staffthumb = params[:staffthumb14] 
              elsif @dept_select == "Sains Perubatan Asas"
                  @staffthumb = params[:staffthumb15] 
              elsif @dept_select == "Anatomi & Fisiologi"
                  @staffthumb = params[:staffthumb16] 
              elsif @dept_select == "Sains Tingkahlaku"
                  @staffthumb = params[:staffthumb17] 
              elsif @dept_select == "Komunikasi & Sains Pengurusan"
                  @staffthumb = params[:staffthumb18] 
              elsif @dept_select == "Pembangunan Pelatih"
                  @staffthumb = params[:staffthumb19] 
              elsif @dept_select == "Khidmat Sokongan Pelatih"
                  @staffthumb = params[:staffthumb20] 
              elsif @dept_select == "Kokurikulum"
                  @staffthumb = params[:staffthumb21] 
              elsif @dept_select == "Ketua Unit Penilaian & Kualiti"  
                  @staffthumb = params[:staffthumb22] 
              end 
    		      #---------
    		      @aa=params[:month_year4][:"(1i)"]  #year
              @bb=params[:month_year4][:"(2i)"]  #month
              @cc='01'                      #params[:month_year][:"(3i)"] #day
              if @aa!='' && @bb!='' && @cc!=''
                  if @bb=='1'||@bb=='2'||@bb=='3'||@bb=='4'||@bb=='5'||@bb=='6'||@bb=='7'||@bb=='8'||@bb=='9'
                      @bb='0'+@bb
                  end
                  @dadidu=@aa+'-'+@bb+'-'+@cc
              else
                  @dadidu=''
              end
    		      @next_date = @dadidu.to_date+1.month  #(next month)
    		      
    		      #-refer - add extra 1 day before & 1 day after - to synchronize with timing zone
              @dadidu_ori= @dadidu
              @next_date_ori= @next_date
              @dadidu = (@dadidu.to_date-1.day).to_s
              @next_date = (@next_date.to_date+1.day).to_s
              #-refer
              
              @monthly_list=StaffAttendance.find(:all, :conditions => ["thumb_id=? AND logged_at>=? AND logged_at<?", @staffthumb, @dadidu, @next_date], :order => 'logged_at ASC')
    		  end
    	end
    	render :layout =>'report'
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff_attendance
      @staff_attendance = StaffAttendance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staff_attendance_params
      params.require(:staff_attendance).permit(:thumb_id, :logged_at, :log_type, :reason, :trigger, :approved_by, :is_approved, :approved_on, :status, :review)
    end
end
