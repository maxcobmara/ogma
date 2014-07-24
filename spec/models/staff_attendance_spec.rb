require 'spec_helper'

describe StaffAttendance do

  before  { @staff_attendance = FactoryGirl.create(:staff_attendance) }

  subject { @staff_attendance }

  it { should respond_to(:thumb_id) }
  it { should respond_to(:logged_at) }
  it { should respond_to(:log_type) }
  it { should respond_to(:reason) }
  it { should respond_to(:trigger) }
  it { should respond_to(:approved_by) }
  it { should respond_to(:is_approved) }
  it { should respond_to(:approved_on) }
  it { should respond_to(:status) }
  it { should respond_to(:review) }
  
  it { should be_valid }
  
  describe "when reason is not present" do
    before { @staff_attendance.reason = "" }
    it { should_not be_valid }
  end

end

