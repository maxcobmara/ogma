class Library::LibrarytransactionsController < ApplicationController

  before_action :set_librarytransaction, only: [:show, :edit, :update, :destroy]
  filter_access_to :manager, :require => :manage,  :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :late_books, :extending, :returning, :attribute_check => true
  filter_access_to :index, :new, :create, :check_status, :analysis_statistic, :analysis_statistic_main, :analysis, :analysis_book, :general_analysis, :general_analysis_ext,:attribute_check => false

  def index
#     @filters = Librarytransaction::FILTERS
#     if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
#       @librarytransactions = Librarytransaction.with_permissions_to.send(params[:show])
#     else
#       @librarytransactions = Librarytransaction.all
#     end
    #@librarytransactions=Librarytransaction.borrowed
    @search=Librarytransaction.borrowed.search(params[:q])
    @librarytransactions=@search.result
    @paginated_transaction = @librarytransactions.order(checkoutdate: :desc).page(params[:page]).per(15)
    @libtran_days = @paginated_transaction.group_by {|t| t.checkoutdate}
  end


  # GET /librarytransactions/new
  # GET /librarytransactions/new.xml
  def new
    @checked_out = Librarytransaction.where("returneddate IS ?", nil).pluck(:accession_id)

    @librarytransaction = Librarytransaction.new
    if @@selected_staff
      @librarytransaction.ru_staff = true
      @librarytransaction.staff_id = @@selected_staff.id
    elsif @@selected_student
      @librarytransaction.ru_staff = false
      @librarytransaction.student_id = @@selected_student.id
    end

    #@librarytransaction.accession_id = 1
    @librarytransaction.checkoutdate = Date.today().strftime('%d-%m-%Y')
    if @librarytransaction.ru_staff == true
      @librarytransaction.returnduedate = (Date.today() + 21.days).strftime('%d-%m-%Y')
    elsif @librarytransaction.ru_staff == false
      @librarytransaction.returnduedate = (Date.today() + 14.days).strftime('%d-%m-%Y')
    end
  end

  def show
  end

  def create
    @librarytransaction = Librarytransaction.create!(librarytransaction_params)
    respond_to do |format|
      format.html { redirect_to manager_library_librarytransactions_path }
      format.js
    end
  end
  
  def destroy
    @librarytransaction=Librarytransaction.destroy(params[:id])
    respond_to do |format|
      format.html { redirect_to manager_library_librarytransactions_path }
      format.js
    end
  end

  def update
    respond_to do |format|
      if @librarytransaction.update(librarytransaction_params)
        #format.html { redirect_to library_librarytransaction_path(@librarytransaction), notice: (t 'location.title')+(t 'actions.updated')  }
        format.html {redirect_to library_librarytransactions_path}
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @librarytransaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def manager
    #set person
    @existing_library_transactions = []
    if params[:search].present? && params[:search][:staff_name].present?
      @staff_name = params[:search][:staff_name].strip
      @staff_name = @staff_name.split("(M)")[1].strip if @staff_name.include?("(M)")
      @selected_staff = Staff.where("name = ?", "#{@staff_name}").first
      unless @selected_staff.nil?
        scope = Librarytransaction.where(staff: @selected_staff).where(returneddate: nil).order(returnduedate: :asc)
        @searches = scope.all
        @searches.each do |t|
          @existing_library_transactions << t
        end
      end
      @@book_counter = @existing_library_transactions.count
      @booklimit = 5
    end

    if params[:search].present? && params[:search][:student_icno].present?
      @student_ic = params[:search][:student_icno].split(" ")[0]
      @selected_student = Student.where("icno = ?", "#{@student_ic}").first
      unless @selected_student.nil?
        scope = Librarytransaction.where(student: @selected_student).where(returneddate: nil).order(returnduedate: :asc)
        @searches = scope.all
        @searches.each do |t|
          @existing_library_transactions << t
        end
      end
      @booklimit = 2
    end

    @book_counter = @existing_library_transactions.count
    @@selected_staff = @selected_staff
    @@selected_student = @selected_student
  end


  def check_status
    @librarytransactions = []

    if params[:search].present? && params[:search][:staff_name].present?
      @staff_name = params[:search][:staff_name]
      @staff_list = Staff.where("name ILIKE ?", "%#{@staff_name}%").pluck(:id)
      scope = Librarytransaction.where("staff_id IN (?) AND returneddate IS ?", @staff_list, nil)
      @searches = scope.all
      @searches.each do |t|
        @librarytransactions << t
      end
    end

    if params[:search].present? && params[:search][:student_icno].present?
      @student_ic = params[:search][:student_icno]
      @student_list = Student.where("icno LIKE ?", "#{@student_ic}%").pluck(:id)
      scope = Librarytransaction.where("student_id IN (?) AND returneddate IS ?", @student_list, nil)
      @searches = scope.all
      @searches.each do |t|
        @librarytransactions << t
      end
    end
  end

  def late_books
    @staff_late_books = Librarytransaction.find_by_sql("
      SELECT s.name as name, s.coemail, b.title
      FROM librarytransactions lt
      LEFT JOIN staffs s on s.id=lt.staff_id
      LEFT JOIN accessions a on a.id=lt.accession_id
      LEFT OUTER JOIN books b on b.id=a.book_id
      WHERE lt.returned IS NULL
      AND s.coemail IS NOT NULL
      AND lt.returnduedate < current_date
      GROUP BY name, s.coemail, b.title;")

    @student_late_books = Librarytransaction.find_by_sql("
      SELECT s.name as name, s.coemail, b.title,
      FROM librarytransactions lt
      LEFT JOIN student s on s.id=lt.student_id
      LEFT JOIN accessions a on a.id=lt.accession_id
      LEFT OUTER JOIN books b on b.id=a.book_id
      WHERE lt.returned IS NULL
      AND s.coemail IS NOT NULL
      AND lt.returnduedate < current_date
      GROUP BY name, s.coemail, b.title;")

  end

  def extending
    @librarytransaction = Librarytransaction.find(params[:id])
  end

  def returning
    @librarytransaction = Librarytransaction.find(params[:id])
  end
  
  def analysis
    yyear = params[:reporting_year]
    unless yyear.blank?
      sstart = yyear.to_date
      eend = sstart.end_of_year
      @progs=Programme.where('course_type=? OR course_type=? OR course_type=? OR course_type=?', 'Diploma', 'Diploma Lanjutan', 'Pos Basik', 'Pengkhususan').where(ancestry_depth: 0).where('name NOT ILIKE(?) and name NOT ILIKE(?)', '%test%', '%unknown%').select(:id, :name, :course_type).order(course_type: :asc, name: :asc)
      student_ids=Student.all.pluck(:id)
      @librarytransactions=Librarytransaction.where(ru_staff: false).where('student_id IN(?)', student_ids).where('checkoutdate >=? and checkoutdate <=?', sstart, eend).group_by{|x|x.student.course_id}
      @librarytransactions_staff=Librarytransaction.where(ru_staff: true).where('checkoutdate >=? and checkoutdate <=?', sstart, eend)
      @thismonthcourse =[0,0,0,0,0,0,0,0,0,0,0,0,0] #note : 13 for 12 months
      @thismonthcourse2 =[0,0,0,0,0,0,0,0,0,0,0,0,0] 
      @thisyearcourse=[]
    else
      flash[:notice] = t('library.transaction.analysis.select_year')
      redirect_to analysis_statistic_library_librarytransactions_path
    end
  end
  
  def analysis_book
    student_ids=Student.all.pluck(:id)
    yyear = params[:reporting_year]
    unless yyear.blank?
      sstart = yyear.to_date
      eend = sstart.end_of_year
      @thismonthcourse =[0,0,0,0,0,0,0,0,0,0,0,0,0] #note : 13 for 12 months
      @thismonthumum =[0,0,0,0,0,0,0,0,0,0,0,0,0]
      @thismonth_wclass=[0,0,0,0,0,0,0,0,0,0,0,0,0]
      @thisyearcourse=[]
      @thisyear_wclass=0
      @nlm_classification_q=['QS','QT','QU','QV','QW','QX','QY','QZ']
      @nlm_classification_w=['W','WA','WB','WC','WD','WE','WF','WG','WH','WI','WJ','WK','WL','WM','WN','WO','WP','WQ','WR','WS','WT','WU','WV','WW','WX','WY','WZ']
      @nlm_classification=@nlm_classification_q+@nlm_classification_w
      @w_class=[]
      @umum_libtrans=[]
      @librarytransactions_students=Librarytransaction.where(ru_staff: false).where('student_id IN(?)', student_ids).where('checkoutdate >=? and checkoutdate <=?', sstart, eend)
      @librarytransactions_staff=Librarytransaction.where(ru_staff: true).where('checkoutdate >=? and checkoutdate <=?', sstart, eend)
      @librarytransactions=(@librarytransactions_staff+@librarytransactions_students).group_by{|x|x.accession.book.classlcc[0,2]}
    else
      flash[:notice] = t('library.transaction.analysis.select_year')
      redirect_to analysis_statistic_library_librarytransactions_path
    end
  end
  
  def general_analysis
    yyear = params[:reporting_year]
    unless yyear.blank?
      sstart = yyear.to_date
      eend = sstart.end_of_year
    else
      flash[:notice] = t('library.transaction.analysis.select_year')
      redirect_to analysis_statistic_library_librarytransactions_path
    end
  end
  
  def general_analysis_ext
    @jobtype=params[:jobtype]  
    if @jobtype=='1'
      @libtrans=Librarytransaction.where('returned is NOT TRUE').sort_by{|x|x.accession.accession_no}
      @libtrans=Kaminari.paginate_array(@libtrans).page(params[:page]||1).per(15)
    elsif @jobtype=='2'
      repeated_books = Book.all.select(:isbn).map(&:isbn)
      b = repeated_books.inject(Hash.new(0)) {|h,i| h[i] += 1; h }
      @repeat = b.to_a.each {|book, repeats|}
      @ewah=[]
      @repeat.each do |book, repeats| 
        if ("#{repeats}").to_i > 1 
          @ewah << [book, repeats]
        end
      end 
      @ewah=Kaminari.paginate_array(@ewah).page(params[:page]||1).per(15)
    end
  end
  
  def analysis_statistic #form for searching by year
  end
  
  def analysis_statistic_main
    commit = params[:list_submit_button]
    yyear=params[:report_year]
    reporting_year = Date.new(yyear.to_i,1,1)
    if commit == t('library.transaction.analysis.borrower_data')
      redirect_to analysis_library_librarytransactions_path(:reporting_year => reporting_year)
    elsif commit == t('library.transaction.analysis.book_data')
      redirect_to analysis_book_library_librarytransactions_path(:reporting_year => reporting_year)
    elsif commit == t('library.transaction.analysis.general_data')
      redirect_to general_analysis_library_librarytransactions_path(:reporting_year => reporting_year)
    end
  end
  
  def latereturn_report
    reporting_year=params[:report_year].to_i
    beginyear=Date.new(reporting_year, 1,1)
    endyear=beginyear.end_of_year
    @librarytransactions=Librarytransaction.overdue.where('returnduedate >=? and returnduedate <=?', beginyear, endyear)
    respond_to do |format|
       format.pdf do
         pdf = LatereturnReportPdf.new(@librarytransactions, view_context, current_user.college)
         send_data pdf.render, filename: "latereturn_report-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_librarytransaction
      @librarytransaction = Librarytransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def librarytransaction_params
      params.require(:librarytransaction).permit(:accession_id, :ru_staff, :staff_id, :student_id, :checkoutdate, :returnduedate, :accession, :accession_no, :accession_acc_book, :libcheckout_by, :returned, :returneddate, :extended, :fine, :finepay, :finepaydate)
      # <-- insert editable fields here inside here e.g (:date, :name)
    end

end
