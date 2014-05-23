class Position < ActiveRecord::Base
  
  before_save :set_combo_code, :titleize_name
  has_ancestry :cache_depth => true
  
  validates_uniqueness_of :combo_code
  validates_presence_of   :name
  
  belongs_to :staff
  
  def titleize_name
    self.name = name.titleize
  end
  
  
end

# == Schema Information
#
# Table name: positions
#
#  ancestry       :string(255)
#  ancestry_depth :integer
#  code           :string(255)
#  combo_code     :string(255)
#  created_at     :datetime
#  id             :integer          not null, primary key
#  is_acting      :boolean
#  name           :string(255)
#  postinfo_id    :integer
#  staff_id       :integer
#  staffgrade_id  :integer
#  status         :integer
#  tasks_main     :text
#  tasks_other    :text
#  unit           :string(255)
#  updated_at     :datetime
#
