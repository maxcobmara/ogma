class Examtemplate < ActiveRecord::Base
  belongs_to :exam, :foreign_key => "exam_id"

  scope :mcqq, -> { where(questiontype: 'MCQ')}
  scope :meqq, -> { where(questiontype: 'MEQ')}
  scope :seqq, -> { where(questiontype: 'SEQ')}
  scope :acqq, -> { where(questiontype: 'ACQ')}
  scope :osci2q, -> { where(questiontype: 'OSCI')}
  scope :osci3q, -> { where(questiontype: 'OSCII')}
  scope :osceq, -> { where(questiontype: 'OSCE')}
  scope :ospeq, -> { where(questiontype: 'OSPE')}
  scope :vivaq, -> { where(questiontype: 'VIVA')}
  scope :truefalseq, -> { where(questiontype: 'TRUEFALSE')}

end

# == Schema Information
#
# Table name: examtemplates
#
#  created_at   :datetime
#  exam_id      :integer
#  id           :integer          not null, primary key
#  quantity     :integer
#  questiontype :string(255)
#  total_marks  :decimal(, )
#  updated_at   :datetime
#
