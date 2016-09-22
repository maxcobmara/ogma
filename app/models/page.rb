class Page < ActiveRecord::Base
   has_many :subpages, :class_name => 'Page'
   belongs_to :parent, :class_name => 'Page', foreign_key: 'parent_id'
   belongs_to :college, foreign_key: 'college_id'
   
   before_save :set_body_val
   
   attr_accessor :body2, :body3
   
   def set_body_val
     if body2!=body
       self.body=body2
     elsif body3!=body
       self.body=body3
     end
   end
   
end