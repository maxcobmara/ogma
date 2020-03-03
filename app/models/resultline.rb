class Resultline < ActiveRecord::Base
  belongs_to :examresult, :foreign_key => 'examresult_id'
  belongs_to :student, :foreign_key => 'student_id'
  validates_presence_of :student_id, :total, :pngs17, :status   #total (keep first)==>value obtained from grade.rb-> works like total_marks (previously be4 changed to virtual attr) -> changes does not take effect on 1st edit
                                                                #total refers to sum of.. [(set_NG*credit hour)..of each subject]
  before_save :default_next_semester_if_pass
  
  def default_next_semester_if_pass
    #rescue for (status: gagal, remark: VIVA), status : gagal was selected, but remark remain VIVA
    #note too, DropDown RESULT_STATUS && RESULT_STATUS_CONTRA (status 2 & 1)
    self.remark = '4' if status=='3' || status=='2' || status=='1'
  end
  
  def render_status
    (DropDown::RESULT_STATUS.find_all{|disp, value| value == status}).map {|disp, value| disp}[0]
  end
  
  def render_status_contra
    (DropDown::RESULT_STATUS_CONTRA.find_all{|disp, value| value == status}).map {|disp, value| disp}[0]
  end
  
  def render_remark
    (DropDown::RESULT_REMARK.find_all{|disp, value|value==remark}).map{|disp, value| disp}[0]
  end
  
  def self.search2(search)
    valid_examresult=Examresult.pluck(:id)
    if search 
      if search == '0'  #admin
        @resultlines = Resultline.where(examresult_id: valid_examresult).order(examresult_id: :asc)
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
        @resultlines = Resultline.where(examresult_id: valid_examresult).where(examresult_id: @result_with_common_subjects)
      elsif search=='2' #posbasic SUP
        posbasiks=["Diploma Lanjutan", "Pos Basik", "Pengkhususan"]
        postbasic_prog_ids=Programme.roots.where(course_type: posbasiks).pluck(:id)
        examresult_ids=Examresult.where(programme_id: postbasic_prog_ids).pluck(:id)
        @resultlines = Resultline.where(examresult_id: valid_examresult).where(examresult_id: examresult_ids)
      else
        examresult_ids=Examresult.where(programme_id: search).pluck(:id)
        @resultlines = Resultline.where(examresult_id: valid_examresult).where(examresult_id: examresult_ids)
      end
    end
  end

end

# == Schema Information
#
# Table name: resultlines
#
#  created_at    :datetime
#  examresult_id :integer
#  id            :integer          not null, primary key
#  pngk          :decimal(, )
#  pngs17        :decimal(, )
#  remark        :string(255)
#  status        :string(255)
#  student_id    :integer
#  total         :decimal(, )
#  updated_at    :datetime
#
