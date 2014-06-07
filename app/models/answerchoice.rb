class Answerchoice < ActiveRecord::Base
  belongs_to :examquestion, :foreign_key => 'examquestion_id'
end

# == Schema Information
#
# Table name: answerchoices
#
#  created_at      :datetime
#  description     :string(255)
#  examquestion_id :integer
#  id              :integer          not null, primary key
#  item            :string(255)
#  updated_at      :datetime
#
