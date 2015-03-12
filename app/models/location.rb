class Location < ActiveRecord::Base
  
  has_ancestry :cache_depth => true, orphan_strategy: :restrict
  before_validation     :set_combo_code
  before_save           :set_combo_code, :set_status
  after_touch           :update_status

  validates_presence_of  :code, :name
  validates :combo_code, uniqueness: true
  
  belongs_to  :administrator, :class_name => 'Staff', :foreign_key => 'staffadmin_id'
  has_many  :tenants, :dependent => :destroy
  has_many  :damages, :class_name => 'LocationDamage', :foreign_key => 'location_id', :dependent => :destroy
  accepts_nested_attributes_for :damages, :allow_destroy => true#, reject_if: proc { |damages| damages[:description].blank?}
  validates_associated :damages
  has_many :asset_placements
  has_many :assets, :through => :asset_placements
  #has_many :asset, :foreign_key => "location_id" --> not required - refer line 15 & 16
  has_many :asset_loss
  
  attr_accessor :repairdate
  
  def staff_name
    administrator.try(:name)
  end
  
  def staff_name=(name)
    self.administrator = Staff.find_by_name(name) if name.present?
  end
  
  def parent_code
    parent.try(:combo_code)
  end
  
  def parent_code=(combo_code)
    self.parent = Location.find_by_combo_code(combo_code) if combo_code.present?
  end
  
  
  def translated_location_category
    I18n.t(location_category, :scope => :location_categories)
  end
  
  def set_combo_code
    if ancestry_depth == 0
      self.combo_code = code
    else
      self.combo_code = parent.combo_code + "-" + code
    end
  end
  
  def set_status
    if typename == 2
      bed_type = "student_bed_female"
    elsif typename == 8
      bed_type = "student_bed_male"
    end
    @occupied_location_ids = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true).pluck(:location_id)
    #if occupied == true || (parent.occupied == true && parent.status== "_empty") - this line will failed if location is a building
    if occupied == true || (parent.nil? == false && parent.occupied == true && parent.status== "_empty") # if building, lclass will be updated as 1? - suppose 4
      status_type = "damage"
      if typename == 2|| typename == 8
        bed_type = "bed"
      end
      
      self.children.each do |c|
        c.occupied = 1
        c.status=self.parent.status
        c.save!
      end
    #required when damaged room is repaired
    elsif (occupied == false && status=="_damage") 
      status_type = "empty"
      if typename == 2
        bed_type = "student_bed_female"
      elsif typename == 8
        bed_type = "student_bed_male"
      end
      self.children.each do |c|
        c.occupied = 0
        c.save!
      end
      damages.each do |d|
        if d.repaired_on.nil?
          d.repaired_on = repairdate #Date.today
          d.save!
        end
      end
    elsif @occupied_location_ids.include? id
      status_type = "occupied"
    else
      status_type = "empty"
    end
    "#{bed_type}_#{status_type}"
    self.status = "#{bed_type}_#{status_type}"
  end
  
  def update_status
    update_attribute(:status, set_status)
  end
  
  #named shortcuts
  def location_list
     "#{combo_code}  #{name}"
  end
  
  def self.to_csv(options = {})
    @current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    occupied_beds = @current_tenants.pluck(:location_id)
    building_name = all[0].root.name
    CSV.generate(options) do |csv|
        csv << [I18n.t('student.tenant.report_main')] #title added
        csv << [] #blank row added
        csv << [building_name]
        csv << [I18n.t('student.tenant.level'), I18n.t('student.tenant.occupied'), I18n.t('student.tenant.empty'), I18n.t('student.tenant.damaged'), I18n.t('student.tenant.notes')]   
        
        ##############
        lev=[]
        occ_level=[]
        occupiedroomss=[]
        ocbb=[]
        all.each do |bed|      
            ocbb << bed if occupied_beds.include?(bed.id)
        end
        #occupiedroom = ocbb.group_by{|x|x.combo_code[0,6]}.count   #3 aras je yg ade data
        occupiedlevel = ocbb.group_by{|x|x.combo_code[0,6]}
        occupiedlevel.each do |level, beds| #beds
          occ_level << level  #HB-02-
          occupiedbeds_level = beds.group_by{|y|y.combo_code[0,9]}
          occupiedbeds_level.each do |leve, bedss|
            lev << leve[0,6]
          end
          occupiedroomss << occupiedbeds_level.count
        end
        ##################

        num=0
        all.group_by{|x|x.combo_code[0,6]}.sort.reverse.each do |floor, beds|     #by floor
           damangedbed=[]
          #per each level----start
           beds.each do|bed|
              if bed.occupied == true
                damangedbed << bed
             end
           end
           damangedroom = damangedbed.group_by{|x|x.combo_code[0,6]}.count
           hash_occlevel = Hash[occ_level.zip(occupiedroomss)]
           hash_occlevel.default = 0 
           occupiedroom = hash_occlevel[floor]
           allroom = beds.group_by{|x|x.combo_code[0,9]}.count
           csv << [floor, occupiedroom, allroom-occupiedroom-damangedroom, damangedroom]
           num+=1
          #per each level----end
        end

      end
  end
  
end

# == Schema Information
#
# Table name: locations
#
#  allocatable    :boolean
#  ancestry       :string(255)
#  ancestry_depth :integer          default(0)
#  code           :string(255)
#  combo_code     :string(255)
#  created_at     :datetime
#  id             :integer          not null, primary key
#  lclass         :integer
#  name           :string(255)
#  occupied       :boolean
#  staffadmin_id  :integer
#  status         :string(255)
#  typename       :integer
#  updated_at     :datetime
#
