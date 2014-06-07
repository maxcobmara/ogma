class Booleananswer < ActiveRecord::Base
  belongs_to :examquestion, :foreign_key => 'examquestion_id'
end

# == Schema Information
#
# Table name: booleananswers
#
#  answer          :boolean
#  created_at      :datetime
#  examquestion_id :integer
#  id              :integer          not null, primary key
#  item            :string(255)
#  updated_at      :datetime
#
