class Cofile < ActiveRecord::Base
  
  validates_presence_of :name, :location, :owner_id#:cofileno, 
  
  belongs_to :owner,    :class_name => 'Staff', :foreign_key => 'owner_id' 
  belongs_to :borrower, :class_name => 'Staff', :foreign_key => 'staffloan_id' 
  
  has_many :documents, :foreign_key => 'file_id'
  has_many :sdiciplines, :foreign_key => 'file_id'
  has_many :student_discipline_cases, :foreign_key => 'file_id'
  
  #Link to Model Sdicipline
  #has_many :file,       :class_name => 'Sdicipline', :foreign_key => 'cofile_id'
  has_many :counsellings
  
  def file_no_and_name
    "#{cofileno}  #{name}"
  end
  
end