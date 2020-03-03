class AddressBook < ActiveRecord::Base
  
  has_many :provides, :class_name => 'Ptcourse', :foreign_key => 'provider_id'
  validates :name, presence: :true
  has_many :suppliers,    :class_name => 'Asset', :foreign_key => 'supplier_id'
end

# == Schema Information
#
# Table name: address_books
#
#  address    :string
#  created_at :datetime
#  fax        :string
#  id         :integer          not null, primary key
#  mail       :string
#  name       :string
#  phone      :string
#  shortname  :string
#  updated_at :datetime
#  web        :string
#
