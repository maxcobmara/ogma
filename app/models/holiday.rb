class Holiday < ActiveRecord::Base 
  belongs_to :college
  validates_presence_of :hname, :hdate
  validates_uniqueness_of :hdate
end
