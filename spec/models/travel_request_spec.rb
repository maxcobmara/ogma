require 'spec_helper'

describe TravelRequest do
  
  before { @travel_request = FactoryGirl.create(:travel_request)}
  
  subject {@travel_request }
  
  it { should respond_to(:staff_id) }
  it { should respond_to(:replaced_by) }
  it { should respond_to(:hod_id) }
  it { should respond_to(:travel_claim_id) }
  it { should respond_to(:document_id) }
  it { should respond_to(:destination) }
  it { should respond_to(:depart_at) }
  it { should respond_to(:return_at) }
  it { should respond_to(:own_car) }
  it { should respond_to(:own_car_notes) }
  it { should respond_to(:dept_car) }
  it { should respond_to(:others_car) }
  it { should respond_to(:taxi) }
  it { should respond_to(:bus) }
  it { should respond_to(:train) }
  it { should respond_to(:plane) }
  it { should respond_to(:other) }
  it { should respond_to(:other_desc) }
  it { should respond_to(:is_submitted) }
  it { should respond_to(:submitted_on) }
  it { should respond_to(:mileage) }
  it { should respond_to(:mileage_replace) }
  it { should respond_to(:hod_accept) }
  it { should respond_to(:hod_accept_on) }
  it { should respond_to(:is_travel_log_complete) }
  it { should respond_to(:log_mileage) }
  it { should respond_to(:log_fare) }
  it { should respond_to(:code) }
  
  it { should be_valid }
  
  describe "staff (claimant) is not present" do
    before { @travel_request.staff_id=nil}
    it {should_not be_valid}
  end
  
  describe "destination is not present" do
    before { @travel_request.destination=nil}
    it {should_not be_valid}
  end
  
  describe "depature date & time is not present" do
    before { @travel_request.depart_at=nil}
    it {should_not be_valid}
  end
  
  describe "return date & time is not present" do
    before { @travel_request.return_at=nil}
    it {should_not be_valid}
  end
  
  describe "own car notes is not present when own car is selected" do
    before do
      @travel_request.own_car=true
      @travel_request.own_car_notes=nil
    end
    it {should_not be_valid}
  end

  describe "replacement is not present when travel request submitted" do
    before do
      @travel_request.is_submitted=true
      @travel_request.replaced_by=nil
    end
    it {should_not be_valid}
  end  

  describe "approver is not present when travel request submitted" do
    before do
      @travel_request.is_submitted=true
      @travel_request.hod_id=nil
    end
    it {should_not be_valid}
  end  

  describe "hod acceptance date is not present when hod accepted request" do
    before do
      @travel_request.hod_accept=true
      @travel_request.hod_accept_on=nil
    end
    it {should_not be_valid}
  end  
  
  describe "departure must takes place before return" do
    before do
      @travel_request.depart_at='2010-01-02 08:00:00'
      @travel_request.return_at='2010-01-01 08:00:00'
    end
    it {should_not be_valid}
  end  
  
end

#validates_presence_of :staff_id, :destination, :depart_at, :return_at
#  validates_presence_of :own_car_notes, :if => :mycar?
#  validate :validate_end_date_before_start_date
#  validates_presence_of :replaced_by, :if => :check_submit?
#  validates_presence_of :hod_id,      :if => :check_submit?
#  validates_presence_of :hod_accept_on, :if => :hod_accept?
