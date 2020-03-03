class Postinfo < ActiveRecord::Base
  has_many :positions
  belongs_to :employgrade, :foreign_key => "staffgrade_id"
  
  def details_grade 
    "#{details}"+" - "+"#{employgrade.name_and_group}"
  end
end

# == Schema Information
#
# Table name: postinfos
#
#  created_at    :datetime
#  details       :string(255)
#  id            :integer          not null, primary key
#  post_count    :integer
#  staffgrade_id :integer
#  updated_at    :datetime
#
