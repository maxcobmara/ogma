class Examresult < ActiveRecord::Base
  validates_presence_of :semester, :programme_id, :examdts, :examdte
  #ref:http://stackoverflow.com/questions/923796/how-do-you-validate-uniqueness-of-a-pair-of-ids-in-ruby-on-rails
  validates_uniqueness_of :semester, :scope => [:programme_id, :examdts], :message => I18n.t('exam.examresult.record_must_unique')
  belongs_to :programmestudent, :class_name => 'Programme', :foreign_key => 'programme_id' 
  has_many :resultlines, :dependent => :destroy                                                     
  accepts_nested_attributes_for :resultlines, :reject_if => lambda { |a| a[:student_id].blank? }
    
  def self.search2(search)
    if search 
      if search == '0'  #admin
        @examresults = Examresult.all.order(examdts: :desc)
      else
        @examresults = Examresult.where(programme_id: search)
      end
    end
  end
  
  def render_semester
    (DropDown::SEMESTER.find_all{|disp, value| value == semester}).map {|disp, value| disp}[0]
  end
  
  # define scope
  def self.keyword_search(query)
    programme_ids = Programme.where('name ILIKE(?)', "%#{query}%").where(course_type: ['Diploma', 'Diploma Lanjutan', 'Pos Basik', 'Pengkhususan']).pluck(:id)
    where(programme_id: programme_ids)
  end
  
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:keyword_search]
  end
  
  def self.get_subjects(programme_id,semester)#,examstartdate)
      parent_sem = Programme.find(programme_id).descendants.at_depth(1)
      parent_sem.each do |sem|
        @subjects_ids = sem.children.map(&:id) if sem.code == semester.to_s   #refer to semester no 
      end
      subjects = Programme.where(id: @subjects_ids)
      subjects
  end 
  
  #14March2013 - rev 18June2013
  def self.set_intake_group(examyear,exammonth,semester, posts)    #semester refers to semester of selected subject - subject taken by student of semester???
    #@unit_dept = Login.current_login.staff.position.unit
    #@unit_dept = Login.current_login.staff.position.ancestors.at_depth(2)[0].unit if @unit_dept==nil
    #------------in case , error ..use the above 2 lines--------
       
    @anc_depth = posts.first.ancestry_depth
    @multi_position = posts
        @ifmulti_position = @multi_position.count 
        if @anc_depth==2 
          @dept_unit = posts.first.unit
        elsif @anc_depth < 2 
        	if @ifmulti_position > 1 
        		@dept_unit = Position.where(['staff_id=? and ancestry_depth=?', posts.first.staff_id,2]).unit 
        	end 
        	if @anc_depth==1 
        		@dept_unit = posts.first.unit
        	end 
        elsif @anc_depth > 2
        	if @ifmulti_position > 1 
        		@multi_position.each do |x|
        			if x.parent.id > 6 && x.parent.id < 17
        			  @dept_unit = x.parent.unit
        			end
        		end
        	else
        		@dept_unit =posts.first.ancestors.at_depth(2)[0].unit 
			    # Login.current_login.staff.position.ancestors.at_depth(2)[0].unit 
        	  if @dept_unit == "Pos Basik" && @anc_depth == 3
        			@dept_unit = posts.first.unit #Login.current_login.staff.position.unit 
        	 end 
        end 
       end
       
       @current_login_roles=[]
       #Login.current_login.roles.each do |role|
       User.where(userable_id: posts.first.staff_id).first.roles.each do |role|
       	  @current_login_roles<< role.id
       end 

     
     #if @current_login_roles.include?(2)
        
        #--------------------
        
         if (@dept_unit && @dept_unit == "Kebidanan" && exammonth.to_i <= 9) || (@dept_unit && @dept_unit != "Kebidanan" && exammonth.to_i <= 7)|| (@current_login_roles.include?(2) && exammonth.to_i <= 9)||(@dept_unit=="Ketua Unit Penilaian & Kualiti" && exammonth.to_i <= 9) #|| (@current_login_roles.include?(2) && exammonth.to_i <= 7) #(@dept_unit && @dept_unit == "Teknologi Maklumat" && exammonth.to_i <= 9)                                         # for 1st semester-month: Jan-July, exam should be between Feb-July
            @current_sem = 1 
            @current_year = examyear 
            if (semester.to_i-1) % 2 == 0                        					      # modulus-no balance - semester genab
              @intake_year = @current_year.to_i-((semester.to_i-1)/2) 
              @intake_sem = @current_sem 
            elsif (semester.to_i-1) % 2 != 0                      				      # modulus-with balance - semester ganjil
              #29June2013-------------------OK
              if (semester.to_i+1)/2 > 3  
                @intake_year = @current_year.to_i-((semester.to_i+1)%2)-2
              elsif (semester.to_i+1)/2 > 2
                @intake_year = @current_year.to_i-((semester.to_i+1)%2)-1
              elsif (semester.to_i+1)/2 > 1
                @intake_year = @current_year.to_i-((semester.to_i+1)%2)
              end  
              #29June2013-------------------
              @intake_sem = @current_sem + 1 
      			end 
          elsif (@dept_unit&& @dept_unit == "Kebidanan" && exammonth.to_i > 9) || (@dept_unit && @dept_unit != "Kebidanan" && exammonth.to_i > 7) || (@current_login_roles.include?(2) && exammonth.to_i > 7)||(@dept_unit=="Ketua Unit Penilaian & Kualiti" && exammonth.to_i > 7)                                   # 2nd semester starts on July-Dec- exam should be between August-Dec
            @current_sem = 2 
            @current_year = examyear
            if (semester.to_i-1) % 2 == 0  
              @intake_year = @current_year.to_i-((semester.to_i-1)/2) 				
              @intake_sem = @current_sem 
            elsif (semester.to_i-1) % 2 != 0                   					        # modulus-with balance
              #@intake_year = @current_year.to_i-((semester.to_i+1)%2)         #@intake_year = @current_year.to_i-((semester.to_i-1)/2).to_i      # (hasil bahagi bukan baki..)..cth semester 6 
              #29June2013-------------------
              if (semester.to_i+1)/2 > 3  
                @intake_year = @current_year.to_i-((semester.to_i+1)%2)-2
              elsif (semester.to_i+1)/2 > 2
                @intake_year = @current_year.to_i-((semester.to_i+1)%2)-1
              elsif (semester.to_i+1)/2 > 1
                @intake_year = @current_year.to_i-((semester.to_i+1)%2)
              end  
              #29June2013-------------------
              
              @intake_sem = @current_sem - 1
            end 
          end
      		#return @intake_sem.to_s+'/'+@intake_year.to_s   #giving this format -->  2/2012  --> previously done on examresult(2012)

      		if @intake_sem == 1 
      		    @intake_month = '03' if( @dept_unit && @dept_unit == "Kebidanan") 
      		    @intake_month = '01' if @dept_unit && @dept_unit != "Kebidanan"  
      		    @intake_month = '03' if(@dept_unit && @current_login_roles.include?(2) && exammonth.to_i <=9 && exammonth.to_i > 7) 
      		    @intake_month = '03' if(@dept_unit=="Ketua Unit Penilaian & Kualiti" && exammonth.to_i <=9 && exammonth.to_i > 7)
      		elsif @intake_sem == 2
      		    @intake_month = '09' if (@dept_unit && @dept_unit == "Kebidanan") 
      		    @intake_month = '07' if @dept_unit && @dept_unit != "Kebidanan"
         		  @intake_month = '09' if(@dept_unit && @current_login_roles.include?(2) && exammonth.to_i >1 && exammonth.to_i <=3 ) 
      		    @intake_month = '03' if(@dept_unit=="Ketua Unit Penilaian & Kualiti" && exammonth.to_i >1 && exammonth.to_i <=3)    		  
      		end

      		return @intake_year.to_s+'-'+@intake_month+'-01'  #giving this format -->  2/2012
      end
      #14March2013
 
   
  def self.get_students(programme_id,examyear,exammonth,semester, posts)
    @combine = self.set_intake_group(examyear,exammonth,semester, posts)
    @all_students=[]
    Student.where(course_id: programme_id).each do |student|
      #if student.intakestudent.name == @combine
      if student.intake.to_s == @combine #'2011-07-01'#
        @all_students << student
      end
    end
    @all_students
  end
  
end