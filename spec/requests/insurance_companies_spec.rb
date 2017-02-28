require 'rails_helper'

RSpec.describe "InsuranceCompanies", :type => :request do
  describe "GET /insurance_companies" do
    it "works! (now write some real specs)" do
      get insurance_companies_path
      expect(response.status).to be(200)
    end
  end
end
