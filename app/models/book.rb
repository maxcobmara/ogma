class Book < ActiveRecord::Base
  belongs_to :staff  , :foreign_key => 'receiver_id'
  belongs_to :addbook, :foreign_key => 'supplier_id'
  has_many  :accessions, :dependent => :destroy
  accepts_nested_attributes_for :accessions, :reject_if => lambda { |a| a[:accession_no].blank? }, :allow_destroy =>true
end