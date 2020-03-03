class Accession < ActiveRecord::Base
  has_many :librarytransactions
  belongs_to :book
  
  def acc_book
    "#{accession_no} - #{book.title}"
  end
  
end

# == Schema Information
#
# Table name: accessions
#
#  accession_no   :string(255)
#  book_id        :integer
#  created_at     :datetime
#  id             :integer          not null, primary key
#  order_no       :string(255)
#  purchase_price :decimal(, )
#  received       :date
#  received_by    :integer
#  status         :integer
#  supplied_by    :integer
#  updated_at     :datetime
#
