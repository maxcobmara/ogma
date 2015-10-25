class Examresult < ActiveRecord::Base
  validates_presence_of :semester, :programme_id
  #ref:http://stackoverflow.com/questions/923796/how-do-you-validate-uniqueness-of-a-pair-of-ids-in-ruby-on-rails
  validates_uniqueness_of :semester, :scope => [:programme_id, :examdts], :message => ", Programme and Examination Date has already been taken. Only 1 record permitted for each examination result. "
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
  
end