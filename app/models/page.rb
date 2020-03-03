class Page < ActiveRecord::Base
   has_many :subpages, :class_name => 'Page'
   belongs_to :parent, :class_name => 'Page', foreign_key: 'parent_id'
   #belongs_to :college, foreign_key: 'college_id'
   
   before_save :set_body_val
   
   validates :name, :title, :navlabel, :position, presence: true
   
   attr_accessor :body2, :body3
   
   def set_body_val
     if body2!=body
       self.body=body2
     elsif body3!=body
       self.body=body3
     end
   end
   
   def position_navlabel
     "#{position} | #{navlabel}"
   end
end

# == Schema Information
#
# Table name: pages
#
#  action_name     :string(255)
#  admin           :boolean
#  body            :text
#  controller_name :string(255)
#  created_at      :datetime
#  id              :integer          not null, primary key
#  name            :string(255)
#  navlabel        :string(255)
#  parent_id       :integer
#  position        :integer
#  redirect        :boolean
#  title           :string(255)
#  updated_at      :datetime
#
