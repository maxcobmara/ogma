class Examquestion < ActiveRecord::Base

  belongs_to :creator,  :class_name => 'Staff', :foreign_key => 'creator_id'
  belongs_to :approver, :class_name => 'Staff', :foreign_key => 'approver_id'
  belongs_to :editor,   :class_name => 'Staff', :foreign_key => 'editor_id'
  belongs_to :subject,  :class_name => 'Programme', :foreign_key => 'subject_id'
  belongs_to :topic,    :class_name => 'Programme', :foreign_key => 'topic_id'
  has_and_belongs_to_many :exams

  has_many :answerchoices, :dependent => :destroy
  accepts_nested_attributes_for :answerchoices, :allow_destroy => true , :reject_if => lambda { |a| a[:description].blank? }
  has_many :examanswers, :dependent => :destroy
  accepts_nested_attributes_for :examanswers, :allow_destroy => true , :reject_if => lambda { |a| a[:answer_desc].blank? }
  has_many :shortessays, :dependent => :destroy
  accepts_nested_attributes_for :shortessays#, :allow_destroy => true , :reject_if => lambda { |a| a[:subquestion].blank? }
  has_many :booleanchoices, :dependent => :destroy
  accepts_nested_attributes_for :booleanchoices, :allow_destroy => true , :reject_if => lambda { |a| a[:description].blank? }
  has_many :booleananswers, :dependent => :destroy
  accepts_nested_attributes_for :booleananswers, :allow_destroy => true , :reject_if => lambda { |a| a[:answer].blank? }

  attr_accessor :activate, :answermcq

  scope :mcqq, -> { where(questiontype: 'MCQ')}
  scope :meqq, -> { where(questiontype: 'MEQ')}
  scope :seqq, -> { where(questiontype: 'SEQ')}
  scope :acqq, -> { where(questiontype: 'ACQ')}
  scope :osci2q, -> { where(questiontype: 'OSCI')}
  scope :osci3q, -> { where(questiontype: 'OSCII')}
  scope :osceq, -> { where(questiontype: 'OSCE')}
  scope :ospeq, -> { where(questiontype: 'OSPE')}
  scope :vivaq, -> { where(questiontype: 'VIVA')}
  scope :truefalseq, -> { where(questiontype: 'TRUEFALSE')}

  has_attached_file :diagram,
                    :url => "/assets/examquestions/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/examquestions/:id/:style/:basename.:extension",
                    :styles => { :original => "250x300>", :thumbnail => "50x60" } #default size of uploaded image
  validates_attachment_size :diagram, :less_than => 5.megabytes
  validates_attachment_content_type :diagram, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
                    #may require validation

  validates_presence_of :subject_id, :topic_id, :questiontype, :question, :marks, :qstatus #17Apr2013,:answer #9Apr2013-compulsory for subject_id


  #has_many :examsubquestions, :dependent => :destroy
  #accepts_nested_attributes_for :examsubquestions, :reject_if => lambda { |a| a[:question].blank? }

  #has_many :exammcqanswers, :dependent => :destroy
  #accepts_nested_attributes_for :exammcqanswers, :reject_if => lambda { |a| a[:answer].blank? }

  attr_accessor :programme_id #9Apr2013 - rely on subject (root of subject[programme])
  #attr_accessor :question1,:question2,:question3,:question4,:questiona,:questionb,:questionc,:questiond

  before_validation :set_nil_if_not_activate, :set_answer_for_mcq
  #before_save :set_answer_for_mcq#, :set_subquestions_if_seq

  def set_nil_if_not_activate
     #if self.id != nil   
          if questiontype=="MCQ" && activate != "1" 
              self.answerchoices[0].description = "" if self.answerchoices[0]#.id !=nil
              self.answerchoices[1].description = "" if self.answerchoices[1]#.id !=nil
              self.answerchoices[2].description = "" if self.answerchoices[2]#.id !=nil
              self.answerchoices[3].description = "" if self.answerchoices[3]#.id !=nil
          end
      #end
  end
  
  def set_answer_for_mcq
      #if answermcq !=nil 
      if questiontype=="MCQ" 
        self.answer=answermcq.to_s
      end
        #end
  end

  #def set_subquestions_if_seq
    #if self.id == nil && questiontype=="SEQ"
        #self.shortessays[0].item = "a"    #new
        #self.shortessays[1].item = "b"
        #self.shortessays[2].item = "c"
    #end
  #end



  def question_creator
    #programme = User.current_user.staff.position.unit - replace with : 2 lines (below)
    #current_user = User.find(11)  #current_user = User.find(11) - 11-maslinda, 72-izmohdzaki
    current_user = Login.first
    programme = current_user.staff.positions[0].unit
    
    programme_name = Programme.roots.map(&:name)
    creator_prog= Staff.joins(:positions).where('unit IN(?)', programme_name).map(&:id)
    if programme_name.include?(programme)
      creator = Staff.joins(:positions).where('unit=? AND unit IN(?)', programme, programme_name).map(&:id)
    else
      role_admin = Role.find_by_name('Administration')  #must have role as administrator
      staff_with_adminrole = Login.joins(:roles).where('role_id=?',role_admin).map(&:staff_id).compact.uniq
      creator_adm = Staff.joins(:positions).where('staff_id IN(?)', staff_with_adminrole).map(&:id)
      creator=creator_prog+creator_adm
    end
    creator
  end
    
  def question_editor
    #programme = User.current_user.staff.position.unit --> requires log-in
    #current_user = User.find(72)  #current_user = User.find(72) - izmohdzaki, 11-maslinda
    current_user = Login.first
    programme = current_user.staff.positions[0].unit
    unless subject_id.nil?
      if subject.root.name == programme
        editors = Position.where('unit=?',programme).map(&:staff_id).compact
      else
        editors = Position.where('unit=?',subject.root.name).map(&:staff_id).compact
      end
    else
      programme_name = Programme.roots.map(&:name)    #must be among Academic Staff 
      editors = Staff.joins(:positions).where('unit=? AND unit IN(?)', programme, programme_name).map(&:id)
    end
    editors
  end
  
  def question_approver #to assign question -> KP
    ###latest finding - as of Mei-Jul/Aug 2013 - approver should be at Ketua Program level ONLY (own programme @ other programme)### 
    
    role_kp = Role.find_by_name('Programme Manager')  #must have role as Programme Manager
    staff_with_kprole = Login.joins(:roles).where('role_id=?',role_kp).pluck(:staff_id).compact.uniq
    programme_name = Programme.roots.map(&:name)    #must be among Academic Staff 
    approver = Staff.joins(:positions).where('unit IN(?) AND staff_id IN(?)', programme_name, staff_with_kprole).pluck(:staff_id)
    approver   
  end
  
  
  def self.search2(search2)
    common_subject = Programmewhere('course_type=?','Commonsubject').pluck(:id)
    if search2 
      if search2 == '0'
        @examquestions = Examquestion.all
      elsif search2 == '1'
        @examquestions = Examquestion.where("subject_id IN (?)", common_subject)
      else
        subject_of_program = Programme.find(search2).descendants.at_depth(2).map(&:id)
        @examquestions = Examquestion.where("subject_id IN (?) and subject_id NOT IN (?)", subject_of_program, common_subject)
      end
    else
       @examquestions = Examquestion.all
    end
  end
  
  #def self.find_main
  #    Examquestion.find(:all, :condition => ['staff_id IS NULL'])
 # end
  
   def self.find_main
     Subject.where('subject_id IS NULL')
   end
   
   def self.find_main
      Staff.where('staff_id IS NULL')
   end
      
   def render_difficulty
     (DropDown::QLEVEL.find_all{|disp, value| value == difficulty }).map {|disp, value| disp}[0]
   end
   
  def subject_details
     if subject.blank? 
       "None Assigned"
     else 
       subject.subject_list
     end
  end


  def creator_details
    if creator.blank?
       "None Assigned"
     else
       creator.name #mykad_with_staff_name
     end
  end

  def editor_details
    if editor.blank?
      "None Assigned"
    elsif editor_id?
      editor.staff_name_with_position
    else 
      "None Assigned"
    end
  end

  def approver_details
    if approver.blank?
      "None Assigned"
    else
      approver.name
    end
  end

  #10Apr2013
  def usage_frequency
      Examquestion.joins(:exams).where('examquestion_id=?',id).count
  end
  #10Apr2013

  def combine_subquestions
    shortessays2=Shortessay.find(:all, :conditions=>['examquestion_id=?',id])
    subq=[]
    shortessays2.each do |y|
      unless y.subquestion.nil? || y.subquestion.blank?
        subq<<"("+y.item.to_s+") "+y.subquestion+" ("+y.submark.to_s+") ["+y.subanswer.to_s+"]"
      end
    end
    subq.to_s
  end

  def self.csv(options={})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |examquestion|
        csv << examquestion.attributes.values_at(*column_names)
      end
    end
  end

end

# == Schema Information
#
# Table name: examquestions
#
#  accuracy_component    :boolean
#  accuracy_construct    :boolean
#  accuracy_topic        :boolean
#  answer                :text
#  approvedt             :date
#  approver_id           :integer
#  bplreserve            :boolean
#  bplsent               :boolean
#  bplsentdt             :date
#  category              :string(255)
#  conform_curriculum    :boolean
#  conform_opportunity   :boolean
#  conform_specification :boolean
#  construct             :string(255)
#  created_at            :datetime
#  createdt              :date
#  creator_id            :integer
#  diagram_caption       :string(255)
#  diagram_content_type  :string(255)
#  diagram_file_name     :string(255)
#  diagram_file_size     :integer
#  diagram_updated_at    :datetime
#  difficulty            :string(255)
#  editdt                :date
#  editor_id             :integer
#  fit_difficulty        :boolean
#  fit_fairness          :boolean
#  fit_important         :boolean
#  id                    :integer          not null, primary key
#  marks                 :decimal(, )
#  programme_id          :integer
#  qkeyword              :string(255)
#  qstatus               :string(255)
#  question              :text
#  questiontype          :string(255)
#  statusremark          :text
#  subject_id            :integer
#  topic_id              :integer
#  updated_at            :datetime
#
