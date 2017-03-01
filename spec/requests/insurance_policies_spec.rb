require 'rails_helper'

RSpec.describe "InsurancePolicies", :type => :request do
  describe "GET /insurance_policies" do
    it "works! (now write some real specs)" do
      get insurance_policies_path
      expect(response.status).to be(200)
    end
  end
end
