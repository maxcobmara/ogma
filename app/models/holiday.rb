class Holiday < ActiveRecord::Base 
  validates_presence_of :hname, :hdate
  validates_uniqueness_of :hdate
end
