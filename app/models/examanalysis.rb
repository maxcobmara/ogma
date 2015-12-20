class Examanalysis < ActiveRecord::Base
  
  validates_presence_of :exam_id, :message => I18n.t('examanalysis.exam_must_exist')
  validates_uniqueness_of :exam_id, :message => I18n.t('examanalysis.exam_must_uniq')
  has_many :examquestionanalyses#, :dependent => :destroy                                                     
  accepts_nested_attributes_for :examquestionanalyses, :reject_if => lambda { |a| a[:examquestion_id].blank? }
  belongs_to :exampaper, :class_name => 'Exam', :foreign_key => 'exam_id'
   
  def self.search2(search)
    if search 
      if search == '0'  #admin
        @examanalyses = Examanalysis.all
      elsif search == '1' #common subject lecturer
        @result_with_common_subjects=[]
        Examanalysis.all.each do |result|
          subject_ids=Examanalysis.get_subjects(result.programme_id, result.semester).map(&:id)
          common_subject_ids=Programme.where(course_type: 'Commonsubject').pluck(:id)
          common_exist=common_subject_ids & subject_ids
          if common_exist.count > 0
           @result_with_common_subjects << result.id
          end
        end
        @examanalyses = Examanalysis.where(id: @result_with_common_subjects)
      else
        subject_ids=Programme.where(id: search).first.descendants.at_depth(2).pluck(:id)
	exam_ids=Exam.where(subject_id: subject_ids).pluck(:id)
        @examanalyses = Examanalysis.where(exam_id: exam_ids)
      end
    end
  end
  
  # define scope
  def self.keyword_search(query)
    subject_ids=Programme.where('name ILIKE(?) OR code ILIKE(?)', "%#{query}%", "%#{query}%").where(course_type: ['Subject', 'Commonsubject']).pluck(:id)
    exam_ids=Exam.where(subject_id: subject_ids).pluck(:id)
    where(exam_id: exam_ids)
  end
  
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:keyword_search]
  end
  
  def average_data(marks)
    marks.inject{|sum, element| sum + element}.to_f/marks.size 
  end
  
  def standard_deviation(marks)
    sum = marks.inject(0){|sum,element|sum+(element-average_data(marks))**2} 
    sample_variance = (1/marks.length.to_f * sum).to_f 
    Math.sqrt(sample_variance).to_f  #21June2013
  end
  
  def pass_rate(marks, mid)
    rate=0
    marks.each{|m|rate+=1 if m.to_f >= mid.to_f}
    rate
  end
  
  def percent_pass(marks, mid)
    students=Student.where(id: exampaper.exammarks.pluck(:student_id))
    pass_rate(marks, mid)/students.count.to_f*100
  end
  
  def marks_zero(marks)
    total=0
    marks.each{|m|total+=1 if m.to_f==0.0}
    total
  end
  
  def marks_20percent(marks, fullmarks)
    total=0
    twentypercent=fullmarks.to_f*20/100
    marks.each{|m|total+=1 if m.to_f < twentypercent}
    total
  end
  
  def marks_50percent(marks, fullmarks)
    total=0
    twentypercent=fullmarks.to_f*20/100
    fifthtypercent=fullmarks.to_f*50/100
    marks.each{|m|total+=1 if m.to_f < fifthtypercent && m.to_f >=twentypercent}
    total
  end
  
  def marks_less80percent(marks, fullmarks)
    total=0
    fifthtypercent=fullmarks.to_f*50/100
    eightypercent=fullmarks.to_f*80/100
    marks.each{|m|total+=1 if m.to_f < eightypercent && m.to_f >=fifthtypercent}
    total
  end
  
  def marks_80abovepercent(marks, fullmarks)
    total=0
    eightypercent=fullmarks.to_f*80/100
    marks.each{|m|total+=1 if m.to_f >= eightypercent}
    total
  end
  
  def a_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m==4.00}
    total
  end
  
  def a_minus_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 4.00 && m >= 3.67}
    total
  end
  
  def b_plus_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 3.67 && m >= 3.33}
    total
  end
  
  def b_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 3.33 && m >= 3.00}
    total
  end
  
  def b_minus_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 3.00 && m >= 2.67}
    total
  end
  
  def c_plus_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 2.67 && m >= 2.33}
    total
  end
  
  def c_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 2.33 && m >= 1.67}
    total
  end
  
  def c_minus_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 1.67 && m >= 1.33}
    total
  end
  
  def d_plus_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 1.33 && m >= 1.00}
    total
  end
  
  def d_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 1.00 && m > 0.00}
    total
  end
  
  def e_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m==0.0}
    total
  end
  
  
  #Catechumen : count total of passed from given arrays of marks - view/exammakeranalysis/... & view/examresult/show_stat.html.erb
#   def self.set_pass_rate(column,loop_column)
#     pass_rate = 0 
#     column.each do |studentcountif_mark| 
#       if loop_column == 0 
# 				 pass_rate+=1 if studentcountif_mark >= 15      # CA + MSE marks - total marks= 30
# 			 elsif loop_column == 1 
# 				 pass_rate+=1 if studentcountif_mark >= 20      # MCQ marks - total marks varied ..depends on qty of questions, but most of the time->no matter how
# 			 elsif loop_column == 2                            # many questions they have -> weightage - 40% - marks shall be converted into 40%  
#  				 pass_rate+=1 if studentcountif_mark >= 5      #1 - 21june2013       # MEQ marks (not included in excel)
#  			 elsif loop_column == 3 
#  				 pass_rate+=1 if studentcountif_mark >= 5       #2.5 - 21June2013    # SEQ marks
#  			 elsif loop_column == 4 
#   				 pass_rate+=1 if studentcountif_mark >= 0.5   # ACQ marks (total marks for each question = 1.0)	
#  			 elsif loop_column == 5 
#   				 pass_rate+=1 if studentcountif_mark >= 50     # Final Exam & Total Marks
#   		 elsif loop_column == 6
#     			pass_rate+=1 if studentcountif_mark >= 2      # NG
# 			 elsif loop_column == 7
#       		pass_rate+=1 if studentcountif_mark >= 5      # Total SEQ
#   		 end
# 	  end
# 	  pass_rate
#   end

#   def statistic_item(column,loop_column)
#     statistic_item = [] 
#     statistic_item << column.count 
#     statistic_item << column.min 
# 		 @statistic_item << column.max 
# 		 @statistic_item << 0 #--4th array item-array index no:3
# 		 @statistic_item << @avg = column.inject{|sum, element| sum + element}.to_f/column.size 
# 		 #--start-standard deviation-->
# 		 @sum4var = column.inject(0){|sum,element|sum+(element-@avg)**2} 
# 		 @sample_variance = (1/column.length.to_f * @sum4var).to_f 
# 		 #@statistic_item <<3
# 		 @statistic_item << Math.sqrt(@sample_variance).to_f #1 #21June2013
# 		 #--end-standard deviation-->
# 		 @statistic_item << 0 #--6th array item-array index no:5-->
#      #--start-pass-rate--> #pass rate varied for different type of question...should be set in examquestion or shoud have a standard for each type of question.
#      @pass_rate = Examanalysis.set_pass_rate(column,loop_column)
# 		 @statistic_item << @pass_rate 
# 		 #--end-pass-rate-->
# 		 if @pass_rate == 0                       # @pass_rate == 1 if @pass_rate == 0
# 		      @pass_rate == 1                     #percent pass
# 		      @statistic_item << @pass_rate
# 		 else
# 		      @statistic_item << (@pass_rate.to_i/column.count)*100     #@statistic_item << (@pass_rate/column.count)*100 
# 		 end
# 		 
# 		 return @statistic_item 
#   end
  
  
end