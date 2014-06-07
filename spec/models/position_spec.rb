require 'spec_helper'


describe Position do

  before  { @position = FactoryGirl.create(:position) }

  subject { @position}

  it { should respond_to(:name) }  
  it { should be_valid }
  
end


# == Schema Information
#
# Table name: positions
#
#  ancestry       :string(255)
#  ancestry_depth :integer
#  code           :string(255)
#  combo_code     :string(255)
#  created_at     :datetime
#  id             :integer          not null, primary key
#  is_acting      :boolean
#  name           :string(255)
#  postinfo_id    :integer
#  staff_id       :integer
#  staffgrade_id  :integer
#  status         :integer
#  tasks_main     :text
#  tasks_other    :text
#  unit           :string(255)
#  updated_at     :datetime
#