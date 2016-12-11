class Postinfo < ActiveRecord::Base
  has_many :positions
  belongs_to :employgrade, :foreign_key => "staffgrade_id"
  belongs_to :college
  
  def details_grade 
    "#{details}"+" - "+"#{employgrade.name_and_group}"
  end
  
  def self.position_search(query)
    ids=Position.where(id: query).pluck(:postinfo_id)
    where(id: ids)
  end
  
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:position_search]
  end
end
