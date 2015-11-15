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
          intake_year = examyear.to_i-((semester.to_i+1)%2)-1#-2
        elsif (semester.to_i+1)/2.0 > 2
          intake_year = examyear.to_i-((semester.to_i+1)%2)#-1
        elsif (semester.to_i+1)/2.0 > 1
          intake_year= examyear
        end  
      end
    end
    intake_year.to_s+'-'+intake_month+'-01'  
  end
 
  def retrieve_student
    Student.where(course_id: programme_id).where('intake=?', intake_group)
  end
  
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
  
  def total_credit
    total=0
    retrieve_subject.each do |subject|
      credit=subject.code[10,1] if subject.code.size >9
      credit=subject.code[-1,1] if subject.code.size < 10
      total+=credit.to_i
    end
    total
  end
  
  def self.total_grade_points(resultlines)
    total=0
    if resultlines.first.examresult.total.nil?
      total+=0
    else
      total+=resultlines.first.examresult.total
    end
    if resultlines[1].examresult.total.nil?
      total+=0
    else
      total+=resultlines.first.examresult.total
    end
    if Programme.where(course_type: 'Diploma').pluck(:id).include?(resultlines.first.examresult.programme_id)
      if resultlines[2].examresult.total.nil?
        total+=0
      else
        total+=resultlines.first.examresult.total
      end
      if resultlines[3].examresult.total.nil?
        total+=0
      else
        total+=resultlines.first.examresult.total
      end
      if resultlines[4].examresult.total.nil?
        total+=0
      else
        total+=resultlines.first.examresult.total
      end
      if resultlines[5].examresult.total.nil?
        total+=0
      else
        total+=resultlines.first.examresult.total
      end
    end
    total
  end
  
end