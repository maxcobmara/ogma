class Assetcategory < ActiveRecord::Base
  has_many :assets, :foreign_key => 'category_id'
  
  has_many    :subs,    :class_name => 'Assetcategory', :foreign_key => 'parent_id'
  belongs_to  :parent,  :class_name => 'Assetcategory', :foreign_key => 'parent_id'

  ASSETTYPE = [
    #  Displayed       stored in db
       ["Harta Modal",1],
       ["Inventori",2]
  ]
  
  def render_cattype
    (DropDown::ASSETTYPE.find_all{|disp, value| value == cattype_id}).map {|disp, value| disp} [0]
  end
end

# == Schema Information
#
# Table name: assetcategories
#
#  cattype_id  :integer
#  created_at  :datetime
#  description :string(255)
#  id          :integer          not null, primary key
#  parent_id   :integer
#  updated_at  :datetime
#
