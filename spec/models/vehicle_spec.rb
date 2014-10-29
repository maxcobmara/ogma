require 'spec_helper'

  describe Vehicle do
  
    before { @vehicle = FactoryGirl.create(:vehicle) }
    subject { @vehicle }
  
    it { should respond_to(:type_model) }
    it { should respond_to(:reg_no) }
    it { should respond_to(:cylinder_capacity) }
    it { should respond_to(:staff_id) }
  
    it { should be_valid }    

end
