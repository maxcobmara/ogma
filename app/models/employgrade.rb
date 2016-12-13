class Employgrade < ActiveRecord::Base
  has_many :staffs, :class_name => 'Staffs', :foreign_key => 'staffgrade_id'
  has_many :staffgrades, :class_name => 'Positions'
  has_one :rank
  
  has_many :staffemploygrades
  has_many :staffemployschemes, :through => :staffemploygrades
  
  validates_uniqueness_of :name, :scope => :group_id
  validates_presence_of :name
  
  def grade_group
    (DropDown::GROUP.find_all{|disp, value| value == group_id}).map {|disp, value| disp}[0]
  end
  
  def name_and_group
    "#{name}  (#{grade_group})"
  end
  
  def gred_no
    #"#{name[1,2]}"
    #no_only=name.gsub(/[^0-9]/, '')
    #no_only.to_i
    no_only=name.gsub(/[^\/, ^0-9]/, '')
    if no_only.include?("/")
      no=no_only.split("/")[0]
    else
      no=no_only
    end
    no.to_i
  end
  
  def gred_str
    name.gsub(/[0-9]/, '')
  end
 
end

# == Schema Information
#
# Table name: employgrades
#
#  created_at :datetime
#  group_id   :integer
#  id         :integer          not null, primary key
#  name       :string(255)
#  updated_at :datetime
#
