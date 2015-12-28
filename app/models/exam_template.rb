class ExamTemplate < ActiveRecord::Base
  serialize :data, Hash

  belongs_to  :creator,       :class_name => 'User',   :foreign_key => 'created_by'
  has_many :exams

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
      if v['count']!='' || v['weight']!=''
        in_string += k.upcase+" : "
        in_string += v['count'] if v['count']!=''
        in_string += "/"+ v['weight']+"%" if v["weight"]!=''
        in_string+=", "
      end
    end
    in_string.gsub(/, $/,"")+")"
  end

  def total_in_weight
    total=0
    question_count.each{|k,v|total=v['weight'].to_f if k=="mcq"}
    question_count.each{|k,v|total+=v['weight'].to_f if k!="mcq"}
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

  def valid_for_removal
    if Exam.where(topic_id: id).count > 0
      return false
    else
      return true
    end
  end

end
