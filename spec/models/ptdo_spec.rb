require 'spec_helper'

describe Ptdo do

  before  { @ptdo = FactoryGirl.create(:ptdo) }

  subject { @ptdo }

  it { should respond_to(:dept_approve) }
  it { should respond_to(:dept_review) }
  it { should respond_to(:final_approve) }
  it { should respond_to(:justification) }
  it { should respond_to(:ptcourse_id) }
  it { should respond_to(:ptschedule_id) }
  it { should respond_to(:replacement_id) }
  it { should respond_to(:trainee_report) }
  it { should respond_to(:unit_approve) }
  it { should respond_to(:unit_review) }
  
  
end


# == Schema Information
#
# Table name: ptdos
#
#  created_at     :datetime
#  dept_approve   :boolean
#  dept_review    :string(255)
#  final_approve  :boolean
#  id             :integer          not null, primary key
#  justification  :string(255)
#  ptcourse_id    :integer
#  ptschedule_id  :integer
#  replacement_id :integer
#  staff_id       :integer
#  trainee_report :text
#  unit_approve   :boolean
#  unit_review    :string(255)
#  updated_at     :datetime