class Assetcategory < ActiveRecord::Base
  has_many :assets, :foreign_key => 'category_id'
  
  has_many    :subs,    :class_name => 'Assetcategory', :foreign_key => 'parent_id'
  belongs_to  :parent,  :class_name => 'Assetcategory', :foreign_key => 'parent_id'

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
