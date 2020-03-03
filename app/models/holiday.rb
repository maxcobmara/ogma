class Holiday < ActiveRecord::Base 
  validates_presence_of :hname, :hdate
  validates_uniqueness_of :hdate
end

# == Schema Information
#
# Table name: holidays
#
#  hdate :date
#  hname :string(255)
#  id    :integer          not null, primary key
#
