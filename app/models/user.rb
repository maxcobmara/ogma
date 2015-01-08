class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :userable, polymorphic: true
  has_and_belongs_to_many :roles

  def self.current
    Thread.current[:user]
  end
  def self.current=(user)
    Thread.current[:user] = user
  end
  
  def self.keyword_search(query)
   staff_ids=Staff.where('name ILIKE(?)', "%#{query}%").pluck(:id)
   student_ids=Student.where('name ILIKE(?)', "%#{query}%").pluck(:id)
   where('(userable_id IN(?) and userable_type=?) OR userable_id IN(?) and userable_type=? ', staff_ids, "Staff", student_ids, "Student")
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
   [:keyword_search]
  end

  def exams_of_programme
    unit_of_staff = userable.positions.first.unit	 #User.where(id: self.id).first.userable.positions.first.unit
    programme_of_staff = Programme.where('name ILIKE(?)', "%#{unit_of_staff}%").at_depth(0).first
    subjects_ids = programme_of_staff.descendants.at_depth(2).pluck(:id)
    return Exam.where('subject_id IN(?)', subjects_ids).pluck(:id)
  end
  
  def evaluations_of_programme
    unit_of_prog_mgr = userable.positions.first.unit
    programme_id_of_prog_mgr = Programme.where('name ILIKE(?)', "%#{unit_of_prog_mgr}%").at_depth(0).first.id
    return programme_id_of_prog_mgr
  end
  
  def grades_of_programme
    unit_of_staff = userable.positions.first.unit	 #User.where(id: self.id).first.userable.positions.first.unit
    programme_of_staff = Programme.where('name ILIKE(?)', "%#{unit_of_staff}%").at_depth(0).first
    subjects_ids = programme_of_staff.descendants.at_depth(2).pluck(:id)
    return Grade.where('subject_id IN(?)', subjects_ids).pluck(:id)
  end
  
  def topicdetails_of_programme
    unit_of_staff = userable.positions.first.unit
    if Programme.roots.map(&:name).include?(unit_of_staff)==true
      programme_of_staff = Programme.where('name ILIKE(?)', "%#{unit_of_staff}%").at_depth(0).first
      topicids = programme_of_staff.descendants.at_depth(3).pluck(:id)
      subtopicids = programme_of_staff.descendants.at_depth(4).pluck(:id)
      topicdetailsids = Topicdetail.where('topic_code IN(?) OR topic_code IN(?)', topicids, subtopicids).pluck(:id)
    else
      #common subject lecturer
      commonsubject_ids= Programme.where(course_type: "Commonsubject").pluck(:id)
      topicids_of_commonsubject = []
      for commons_id in commonsubject_ids
        topicids_of_commonsubject +=Programme.where(id:commons_id).first.descendants.pluck(:id)
      end
      topicdetailsids = Topicdetail.where('topic_code IN(?)', topicids_of_commonsubject).pluck(:id)
    end
    topicdetailsids
  end

  def timetables_of_programme
    unit_of_staff = userable.positions.first.unit
    if Programme.roots.map(&:name).include?(unit_of_staff)==true
      programme_of_staff = Programme.where('name ILIKE(?)', "%#{unit_of_staff}%").at_depth(0).first
      topicids = programme_of_staff.descendants.at_depth(3).pluck(:id)
      subtopicids = programme_of_staff.descendants.at_depth(4).pluck(:id)
      timetable_in_trainingnote = Trainingnote.where('timetable_id IS NOT NULL').pluck(:timetable_id)
      timetableids = WeeklytimetableDetail.where('(topic IN(?) or topic IN(?))and id IN(?)',topicids, subtopicids, timetable_in_trainingnote).pluck(:id)
      #Use below instead & ignore training note -> copy above accordingly 4 those notes selection related
      timetableids = WeeklytimetableDetail.where('(topic IN(?) or topic IN(?))',topicids, subtopicids).pluck(:id)
      return timetableids
    else
      #common subject lecturer
      []
    end
  end

  def role_symbols
   roles.map do |role|
    role.authname.to_sym
   end
  end
end
