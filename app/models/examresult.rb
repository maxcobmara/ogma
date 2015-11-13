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
      elsif search == '1' #common subject lecturer
        @result_with_common_subjects=[]
        Examresult.all.each do |result|
        subject_ids=Examresult.get_subjects(result.programme_id, result.semester).map(&:id)
          common_subject_ids=Programme.where(course_type: 'Commonsubject').pluck(:id)
          common_exist=common_subject_ids & subject_ids
          if common_exist.count > 0
           @result_with_common_subjects << result.id
          end
        end
        @examresults = Examresult.where(id: @result_with_common_subjects)
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
  
  def retrieve_subject
    parent_sem=Programme.where(id: programme_id).first.descendants.at_depth(1)
    parent_sem.each{ |sem| @subject_ids = sem.children.map(&:id) if sem.code == semester.to_s }
    Programme.where(id: @subject_ids)
  end
  
#   def self.get_subjects(programme_id,semester)#,examstartdate)
#       parent_sem = Programme.find(programme_id).descendants.at_depth(1)
#       parent_sem.each do |sem|
#         @subjects_ids = sem.children.map(&:id) if sem.code == semester.to_s   #refer to semester no 
#       end
#       subjects = Programme.where(id: @subjects_ids)
#       subjects
#   end 
  
  def intake_group
    examyear=examdts.year 
    exammonth=examdts.month
    kebidanan=Programme.where(name: 'Kebidanan').first.id
    if exammonth < 7 #kebidanan sept-prev year [jan-feb](sem 1) or others [mei-jun](sem 1) 
      if (semester.to_i-1) % 2 == 0                                         # sem 1, thn 1 (semester=1), sem 3, sem 5 - semester GANJIL
        if programme_id==kebidanan
          intake_month = '09'
          intake_year = examyear-1
        else
          intake_year = examyear.to_i-((semester.to_i-1)/2)
          intake_month = '01'
        end
      elsif (semester.to_i-1) % 2 != 0
        if (semester.to_i+1)/2.0 > 3  
          intake_year = examyear.to_i-((semester.to_i+1)%2)-2
        elsif (semester.to_i+1)/2.0 > 2
          intake_year = examyear.to_i-((semester.to_i+1)%2)-1
        elsif (semester.to_i+1)/2.0 > 1
          intake_year = examyear.to_i-((semester.to_i+1)%2)  
        end
        if programme_id==kebidanan
          intake_month='03'
        else
          intake_month='07'
        end
      end
    elsif exammonth < 9 #kebidanan only
      intake_year = examyear
      intake_month = '03'
    elsif exammonth > 9 #others only 
      if (semester.to_i-1) % 2 == 0  
        intake_year = examyear.to_i-((semester.to_i-1)/2) 
        intake_month = '07'
      elsif (semester.to_i-1) % 2 != 0
        intake_month = '01'
        if (semester.to_i+1)/2.0 > 3  
          intake_year = examyear.to_i-((semester.to_i+1)%2)-2
        elsif (semester.to_i+1)/2.0 > 2
          intake_year = examyear.to_i-((semester.to_i+1)%2)#-1
        elsif (semester.to_i+1)/2.0 > 1
          intake_year= examyear
        end  
      end
    end
    intake_year.to_s+'-'+intake_month+'-01'  
  end
  
  #14March2013 - rev 18June2013
#   def self.set_intake_group(examyear,exammonth,semester, posts)    #semester refers to semester of selected subject - subject taken by student of semester???
#        
#     @anc_depth = posts.first.ancestry_depth
#     @multi_position = posts
#         @ifmulti_position = @multi_position.count 
#         if @anc_depth==2 
#           @dept_unit = posts.first.unit
#         elsif @anc_depth < 2 
#         	if @ifmulti_position > 1 
#         		@dept_unit = Position.where(['staff_id=? and ancestry_depth=?', posts.first.staff_id,2]).unit 
#         	end 
#         	if @anc_depth==1 
#         		@dept_unit = posts.first.unit
#         	end 
#         elsif @anc_depth > 2
#         	if @ifmulti_position > 1 
#         		@multi_position.each do |x|
#         			if x.parent.id > 6 && x.parent.id < 17
#         			  @dept_unit = x.parent.unit
#         			end
#         		end
#         	else
#         		@dept_unit =posts.first.ancestors.at_depth(2)[0].unit 
# 			    # Login.current_login.staff.position.ancestors.at_depth(2)[0].unit 
#         	  if @dept_unit == "Pos Basik" && @anc_depth == 3
#         			@dept_unit = posts.first.unit #Login.current_login.staff.position.unit 
#         	 end 
#         end 
#         #####--Pos Basik / Diploma Lanjutan / Kebidanan -- 1Nov2015 -- note latest format - Position for Pos Basik / Diploma Lanjutan / Pengkhususan
#         if ['Pos Basik', 'Kebidanan', 'Diploma Lanjutan'].include?(@dept_unit)
#            maintask=Login.current_login.staff.position.tasks_main
#            @dept_unit="Kebidanan" if maintask.include?('Kebidanan')
#         end
#         #####
#        end
#        
#        @current_login_roles=[]
#        #Login.current_login.roles.each do |role|
#        User.where(userable_id: posts.first.staff_id).first.roles.each do |role|
#        	  @current_login_roles<< role.id
#        end 
# 
#      
#      #if @current_login_roles.include?(2)
#         
#         #--------------------
#         
#          if (@dept_unit && @dept_unit == "Kebidanan" && exammonth.to_i <= 9) || (@dept_unit && @dept_unit != "Kebidanan" && exammonth.to_i <= 7)|| (@current_login_roles.include?(2) && exammonth.to_i <= 9)||(@dept_unit=="Ketua Unit Penilaian & Kualiti" && exammonth.to_i <= 9) #|| (@current_login_roles.include?(2) && exammonth.to_i <= 7) #(@dept_unit && @dept_unit == "Teknologi Maklumat" && exammonth.to_i <= 9)                                         # for 1st semester-month: Jan-July, exam should be between Feb-July
#             @current_sem = 1 
#             @current_year = examyear 
#             if (semester.to_i-1) % 2 == 0                        					      # modulus-no balance - semester genab
#               @intake_year = @current_year.to_i-((semester.to_i-1)/2)   ###########EXAM MAY - FISIOTERAPI / EXAM OGOS - KEBIDANAN Thn 1, Sem 1
#               @intake_sem = @current_sem 
#             elsif (semester.to_i-1) % 2 != 0                      				      # modulus-with balance - semester ganjil
#               #29June2013-------------------OK
#               if (semester.to_i+1)/2.0 > 3  
#                 @intake_year = @current_year.to_i-((semester.to_i+1)%2)-2
#               elsif (semester.to_i+1)/2.0 > 2
#                 @intake_year = @current_year.to_i-((semester.to_i+1)%2)-1
#               elsif (semester.to_i+1)/2.0 > 1
#                 @intake_year = @current_year.to_i-((semester.to_i+1)%2)  ###########EXAM FEB - KEBIDANAN Thn 1, sem 2
#               end  
#               #29June2013-------------------
#               @intake_sem = @current_sem + 1 
#       			end 
#           elsif (@dept_unit&& @dept_unit == "Kebidanan" && exammonth.to_i > 9) || (@dept_unit && @dept_unit != "Kebidanan" && exammonth.to_i > 7) || (@current_login_roles.include?(2) && exammonth.to_i > 7)||(@dept_unit=="Ketua Unit Penilaian & Kualiti" && exammonth.to_i > 7)                                   # 2nd semester starts on July-Dec- exam should be between August-Dec
#             @current_sem = 2 
#             @current_year = examyear
#             if (semester.to_i-1) % 2 == 0  
#               @intake_year = @current_year.to_i-((semester.to_i-1)/2) 				
#               @intake_sem = @current_sem 
#             elsif (semester.to_i-1) % 2 != 0                   					        # modulus-with balance
#               #@intake_year = @current_year.to_i-((semester.to_i+1)%2)         #@intake_year = @current_year.to_i-((semester.to_i-1)/2).to_i      # (hasil bahagi bukan baki..)..cth semester 6 
#               #29June2013-------------------
#               if (semester.to_i+1)/2.0 > 3  
#                 @intake_year = @current_year.to_i-((semester.to_i+1)%2)-2
#               elsif (semester.to_i+1)/2.0 > 2
#                 @intake_year = @current_year.to_i-((semester.to_i+1)%2)#-1        ##############EXAM NOVEMBER - FIFIOTERAPI - THN 2, SEM 2
#               elsif (semester.to_i+1)/2.0 > 1
#                 #@intake_year = @current_year.to_i-((semester.to_i+1)%2)
# 		@intake_year= @current_year ######EXAM NOVEMBER - FISIOTERAPI - THN 1, SEM 2
#               end  
#               #29June2013-------------------
#               
#               @intake_sem = @current_sem - 1
#             end 
#           end
#       		#return @intake_sem.to_s+'/'+@intake_year.to_s   #giving this format -->  2/2012  --> previously done on examresult(2012)
# 
#       		if @intake_sem == 1 
#       		    @intake_month = '03' if( @dept_unit && @dept_unit == "Kebidanan") 
#       		    @intake_month = '01' if @dept_unit && @dept_unit != "Kebidanan"  
#       		    @intake_month = '03' if(@dept_unit && @current_login_roles.include?(2) && exammonth.to_i <=9 && exammonth.to_i > 7) 
#       		    @intake_month = '03' if(@dept_unit=="Ketua Unit Penilaian & Kualiti" && exammonth.to_i <=9 && exammonth.to_i > 7)
#       		elsif @intake_sem == 2
#       		    @intake_month = '03' if (@dept_unit && @dept_unit == "Kebidanan") 
#       		    @intake_month = '01' if @dept_unit && @dept_unit != "Kebidanan"
#          		  @intake_month = '03' if(@dept_unit && @current_login_roles.include?(2) && exammonth.to_i >1 && exammonth.to_i <=3 ) 
#       		    @intake_month = '03' if(@dept_unit=="Ketua Unit Penilaian & Kualiti" && exammonth.to_i >1 && exammonth.to_i <=3)    		  
#       		end
# 
#       		return @intake_year.to_s+'-'+@intake_month+'-01'  #giving this format -->  2/2012
#       end
#       #14March2013
 
  def retrieve_student
    Student.where(course_id: programme_id).where('intake=?', intake_group)
  end
      
#   def self.get_students(programme_id,examyear,exammonth,semester, posts)
#     @combine = self.set_intake_group(examyear,exammonth,semester, posts)
#     Student.where(course_id: programme_id).where('intake=?', @combine)
#   end
  
  def self.total(finale_all,subject_credits)
    @finaletotal = 0.00
    0.upto(finale_all.count-1) do |index|
      @finaletotal = @finaletotal+(finale_all[index]*subject_credits[index])
    end
    @finaletotal
  end
  
  def self.pngs17(finale_total,subject_credits)
    #finale_total/17
    #total_credit = Examresult.get_subjects(programme_id,semester).map(&:credits).inject{|sum,x|sum+x}
    finale_total/(subject_credits.inject{|sum,x|sum+x})
    
    #(subject_credits.inject{|sum,x|sum+x}) 
    #NGS [=finale_total]-> Nilai Gred Semester(JUM-Nilai gred(tiap subjek) * kredit(tiap subjek))
    #PNGS -> Purata Nilai Gred Semester(NGS/jum kredit); [jum kredit=(subject_credits.inject{|sum,x|sum+x})]
  end
  
end