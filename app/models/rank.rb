class Rank < ActiveRecord::Base 
  serialize :data, Hash
  
  has_many :staffs
  
  def maritime_grade=(value)
    data[:maritime_grade]=value
  end
  
  def maritime_grade
    data[:maritime_grade]
  end
  
  RANK_CATEGORY= [
    #display         #stored in DB
    ["Pegawai Penguat Kuasa Maritim", 1],
    ["Pegawai Lain - Lain Pangkat Penguat Kuasa Maritim", 2]
    ]
  
end