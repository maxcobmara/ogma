class Tenant < ActiveRecord::Base
  before_save :save_my_vars
  belongs_to :location, touch: true
  belongs_to :staff
  belongs_to :student
  belongs_to :visitor
  belongs_to :college
  has_many  :damages, :class_name => 'LocationDamage', :foreign_key => 'user_id', :dependent => :destroy
  accepts_nested_attributes_for :damages, :allow_destroy => true, reject_if: proc { |damages| damages[:description].blank?}
  
  validates :student_id, presence: true, :if => :location_is_student_residence?
  validates :staff_id, presence: true, :if => :location_is_staff_residence?
  validates :keyaccept, :keyexpectedreturn, :total_keys, presence: true
  
  def location_is_student_residence?
    #male lclass=3, typename=8 , ancestry_depth=3,
    #female lclass=3, typename=2, ditto
    student_beds=Location.where(ancestry_depth: 3).where(lclass: 3).where('typename=? OR typename=?', 3, 8).pluck(:id)
    student_beds.include?(location_id)==true
  end
  
  def location_is_staff_residence?
    #lclass=3, typename=1, ancestry_depth=2
    staff_houses=Location.where(ancestry_depth: 2).where(lclass: 3).where(typename: 1).pluck(:id)
    staff_houses.include?(location_id)==true
  end
  
  #student autocomplete - New Tenant 
  def student_icno
    student.try(:student_list)
  end

  def student_icno=(icno)
    icno2 = icno.split(" ")[0]
    #self.student = Student.find_or_create_by_icno(icno2) if icno2.present?
    self.student = Student.find_or_create_by(icno: icno2) if icno2.present?
  end
  
  #student autocomplete for return key
  def student_icno_location
    if Tenant.where(student_id: student.id).count > 1
      studentsearch = student.try(:student_list)+" "+location.combo_code
    else
      studentsearch = student.try(:student_list)
    end
    studentsearch
  end

  def student_icno_location=(icno)
    icno2 = icno.split(" ")[0]
    #self.student = Student.find_or_create_by_icno(icno2) if icno2.present?
    self.student = Student.find_or_create_by(icno: icno2) if icno2.present?
  end
  
  #staff autocomplete
  def staff_icno
    staff.try(:staff_list)
  end

  def staff_icno=(icno)
    icno2 = icno.split(" ")[0]
    #self.student = Student.find_or_create_by_icno(icno2) if icno2.present?
    self.staff = Staff.find_or_create_by(icno: icno2) if icno2.present?
  end
  
  #staff autocomplete for return key2
  def staff_icno_location
    if Tenant.where(staff_id: staff.id).count > 1
      staffsearch = staff.try(:staff_list)+" "+location.combo_code
    else
      staffsearch = staff.try(:staff_list)
    end
    staffsearch
  end

  def staff_icno_location=(icno)
    icno2 = icno.split(" ")[0]
    self.staff = Staff.find_or_create_by(icno: icno2) if icno2.present?
  end
  
  def save_my_vars
    if id.nil? || id.blank?
      self.force_vacate = 0
    end
  end
  
  # define scope
  def self.keyword_search(query)
    aaa=LocationDamage.where('user_id is not null').pluck(:user_id)
    tenant_ids = LocationDamage.where('user_id is not null').pluck(:user_id) if query=='1'   #w dmgs
    tenant_ids = Tenant.where('id not IN(?)', aaa).pluck(:id) if query=='2'                               #wo dmgs
    where('tenants.id IN(?)', tenant_ids) 
  end
  
  def self.damagetype_search(query)
    if query=='1' 
      tenant_ids = LocationDamage.where('document_id=?', 1).pluck(:user_id)  #oom_damage
    elsif query=='2'
      tenant_ids = LocationDamage.where('document_id=?', 2).pluck(:user_id)  #asset_other_damage
    end
    where('tenants.id IN(?)', tenant_ids) 
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:keyword_search, :damagetype_search]
  end
 
  #Temporary add other method for Excel Export of Tenant Listing - remove this part if general I/O error fixed 
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
        csv << [I18n.t('student.tenant.list_full')] #title added
        csv << [] #blank row added
        csv << [I18n.t('location.code'), I18n.t('student.students.icno'), I18n.t('student.name'), I18n.t('student.students.matrixno'), I18n.t('student.students.intake_id'), I18n.t('course.name'), I18n.t('student.tenant.key.provided'), I18n.t('student.tenant.key.expected'), I18n.t('student.tenant.key.returned'), I18n.t('student.tenant.vacate'), I18n.t('student.tenant.damage_status'), I18n.t('student.tenant.damage_type'),]   
        all.each do |tenant|
          unless tenant.student.nil?
            if tenant.damages.count==0; damages_text = (I18n.t 'no2'); else damages_text = (I18n.t 'yes2'); end
            damage_description = []
            
            if tenant.damages.count>0
                tenant.damages.each{|t|damage_description << t.damage_type}
                csv << [tenant.location.try(:combo_code), tenant.try(:student).try(:icno), tenant.try(:student).try(:name), tenant.try(:student).try(:matrixno), tenant.try(:student).try(:intake).try(:strftime, '%b %Y'), tenant.try(:student).try(:course).try(:name), tenant.keyaccept.try(:strftime, '%d %b %Y'), tenant.keyexpectedreturn.try(:strftime, '%d %b %Y'), tenant.keyreturned.try(:strftime, '%d %b %Y'), tenant.force_vacate? ? (I18n.t 'yes2') : (I18n.t 'no2'), damages_text, damage_description.uniq.to_sentence]
            else
                csv << [tenant.location.try(:combo_code), tenant.try(:student).try(:icno), tenant.try(:student).try(:name), tenant.try(:student).try(:matrixno), tenant.try(:student).try(:intake).try(:strftime, '%b %Y'), tenant.try(:student).try(:course).try(:name), tenant.keyaccept.try(:strftime, '%d %b %Y'), tenant.keyexpectedreturn.try(:strftime, '%d %b %Y'), tenant.keyreturned.try(:strftime, '%d %b %Y'), tenant.force_vacate? ? (I18n.t 'yes2') : (I18n.t 'no2'), damages_text]
            end
          end
        end
      end
  end
  
end

# == Schema Information
#
# Table name: tenants
#
#  created_at        :datetime
#  force_vacate      :boolean
#  id                :integer          not null, primary key
#  keyaccept         :date
#  keyexpectedreturn :date
#  keyreturned       :date
#  location_id       :integer
#  staff_id          :integer
#  student_id        :integer
#  updated_at        :datetime
#
