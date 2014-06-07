class Examanswer < ActiveRecord::Base
  belongs_to :examquestion, :foreign_key => 'examquestion_id'
end

# == Schema Information
#
# Table name: examanswers
#
#  answer_desc     :string(255)
#  created_at      :datetime
#  examquestion_id :integer
#  id              :integer          not null, primary key
#  item            :string(255)
#  updated_at      :datetime
#
