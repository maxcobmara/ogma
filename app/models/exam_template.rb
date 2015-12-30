class ExamTemplate < ActiveRecord::Base
  serialize :data, Hash

  belongs_to  :creator,       :class_name => 'User',   :foreign_key => 'created_by'
  has_many :exams
  
  validates_presence_of :name
  validate :count_is_compulsory

  before_destroy :valid_for_removal

  def question_count=(value)
    data[:question_count] = value
  end
  def question_count
    data[:question_count]
  end
  

  # define scope
  def self.creator_search(query)
    staff_ids = Staff.where('name ILIKE(?)', "%#{query}%").pluck(:id)
    user_ids = User.where(userable_id: staff_ids).pluck(:id)
    where(created_by: user_ids)
  end
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:creator_search]
  end

  def template_in_use
    in_string="("
    question_count.each do |k, v|
      #if v['count']!='' || v['weight']!=''
      if !v['count'].blank?  ||  !v['weight'].blank? ||  !v['full_marks'].blank?  
        in_string += k.upcase+" : "
        in_string += v['count'] unless v['count'].blank?                                   #if v['count']!=''
        in_string += "/"+ v['weight']+"%" unless v['weight'].blank?                  #if v["weight"]!=''
        in_string += "/"+ v['full_marks'] unless v['full_marks'].blank?
        in_string +=", "
      end
    end
    in_string.gsub(/, $/,"")+")"
  end

  def total_in_weight
    total=0
    question_count.each{|k,v|total+=v['weight'].to_f}
    #question_count.each{|k,v|total=v['weight'].to_f if k=="mcq"}
    #question_count.each{|k,v|total+=v['weight'].to_f if k!="mcq"}
    total
  end
  
  def self.search2(search)
    if search
      admin_ids=Role.joins(:users).where(authname: 'administration').pluck(:user_id)
      if search=='0'
        @exam_templates=ExamTemplate.all
      elsif search=='1' 
        common_subjects = ["Sains Perubatan Asas", "Anatomi & Fisiologi", "Sains Tingkahlaku", "Komunikasi & Sains Pengurusan", "Komuniti"]
        staff_ids=Position.where(unit: common_subjects).pluck(:staff_id)
        creators_ids=User.where(userable_id: staff_ids).pluck(:id)
        @exam_templates=ExamTemplate.where(created_by: creators_ids+admin_ids)
      elsif search=='2'
        staff_ids=Position.where('unit ILIKE (?) OR unit ILIKE (?) OR unit ILIKE (?)', "%Pengkhususan%", "%Pos Basik%", "%Diploma Lanjutan%").pluck(:staff_id)
        creators_ids=User.where(userable_id: staff_ids).pluck(:id)
        @exam_templates=ExamTemplate.where(created_by: creators_ids+admin_ids)
      else
        staff_ids=Position.where(unit: Programme.where(id: search).first.name).pluck(:staff_id)
        creators_ids=User.where(userable_id: staff_ids).pluck(:id)
        @exam_templates=ExamTemplate.where(created_by: creators_ids+admin_ids)
      end
    end
  end
  
  #####use in exams/_show_exam 
  def template_full_marks
    sum=0
    question_count.each do |k, v|
      unless v['count'].blank?
        qty=(v['count']).to_i
        if !v["full_marks"].nil? && !v["full_marks"].blank?
          sum1=v["full_marks"].to_f
        else
          if k=="mcq"
            sum1=qty*1 
          elsif k=="seq" || k=="ospe"
            sum1=qty*10
          elsif k=="meq"
            sum1=qty*20
          else
            sum1=qty #default to 1 first
          end
        end
        sum+=sum1
      end #endfor unless v['count']
    end #endfor question_count loop
    sum
  end
  #####

  def valid_for_removal
    if Exam.where(topic_id: id).count > 0
      return false
    else
      return true
    end
  end
  
  private 
    def count_is_compulsory
      q_withcount=0
      question_count.each do |k, v|
        q_withcount+=1 unless v['count'].blank?
      end
      if q_withcount==0
        errors.add(:base, I18n.t('exam.exam_template.min_onetype_withcount'))
      end
    end

end
