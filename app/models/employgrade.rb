class Employgrade < ActiveRecord::Base
  has_many :staffs, :class_name => 'Staffs', :foreign_key => 'staffgrade_id'
  has_many :staffgrades, :class_name => 'Positions', :foreign_key => 'staffgrade_id'
  
  has_many :staffemploygrades
  has_many :staffemployschemes, :through => :staffemploygrades
  
  validates_uniqueness_of :name, :scope => :group_id
  
  def grade_group
    (Employgrade::GROUP.find_all{|disp, value| value == group_id}).map {|disp, value| disp}
  end
  
  def name_and_group
    "#{name}  (#{grade_group[0]})"
  end
  
  def gred_no
    "#{name[1,2]}"
  end
  
  GROUP = [
       [ "Pengurusan & Professional", 1 ],
       [ "Sokongan", 2 ],
       [ "Bersepadu", 4 ]
  ]
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
