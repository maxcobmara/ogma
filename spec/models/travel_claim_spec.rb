require 'spec_helper'

describe TravelClaim do
  
  before { @travel_claim = FactoryGirl.create(:travel_claim)}
  
  subject { @travel_claim }
  
  it { should respond_to(:staff_id) }
  it { should respond_to(:approved_by) }
  it { should respond_to(:claim_month) }
  it { should respond_to(:advance) }
  it { should respond_to(:total) }
  it { should respond_to(:is_submitted) }
  it { should respond_to(:submitted_on) }
  it { should respond_to(:is_checked) }
  it { should respond_to(:is_returned) }
  it { should respond_to(:checked_on) }
  it { should respond_to(:notes) }
  it { should respond_to(:is_approved) }
  it { should respond_to(:approved_on) }
  
  it { should be_valid }
  
  describe "claim for current staff of this month already exist" do
    before do
      @travel_claim.claim_month='2010-01-01'
      @travel_claim.staff_id=1
      @travel_claim2 = FactoryGirl.create(:travel_claim, claim_month: '2010-01-01', staff_id: 1 )
    end
    it { should_not be_valid}
  end
  
end
  
