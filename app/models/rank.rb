class Rank < ActiveRecord::Base 
  
  has_many :staffs
  belongs_to :staffgrade, class_name: 'Employgrade',  foreign_key: 'employgrade_id'
  
  validates :employgrade_id, uniqueness: true, allow_nil: true
  
  RANK_CATEGORY= [
    #display         #stored in DB
    ["Pegawai Penguat Kuasa Maritim", 1],
    ["Pegawai Lain - Lain Pangkat Penguat Kuasa Maritim", 2]
    ]
  
end