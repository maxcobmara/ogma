require 'spec_helper'

describe Event do

  before  { @event = FactoryGirl.create(:event) }

  subject { @event }

  it { should respond_to(:end_at) }
  it { should respond_to(:event_is_publik) }
  it { should respond_to(:assignedto_id) }
  it { should respond_to(:eventname) }
  it { should respond_to(:location) }
  it { should respond_to(:officiated) }
  it { should respond_to(:participants) }
  it { should respond_to(:engine_no) }
  it { should respond_to(:start_at) }
  
  it { should be_valid }
  
end


# == Schema Information
#
# Table name: events
#
#  created_at      :datetime
#  createdby       :integer
#  end_at          :datetime
#  event_is_publik :boolean
#  eventname       :string(255)
#  id              :integer          not null, primary key
#  location        :string(255)
#  officiated      :string(255)
#  participants    :text
#  start_at        :datetime
#  updated_at      :datetime
#
