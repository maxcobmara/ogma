class AddressBook < ActiveRecord::Base
  
  has_many :provides, :class_name => 'Ptcourse', :foreign_key => 'provider_id'
  validates :name, presence: :true
end

# == Schema Information
#
# Table name: address_books
#
#  address    :string(255)
#  created_at :datetime
#  fax        :string(255)
#  id         :integer          not null, primary key
#  mail       :string(255)
#  name       :string(255)
#  phone      :string(255)
#  shortname  :string(255)
#  updated_at :datetime
#  web        :string(255)
#
