require 'rails_helper'

RSpec.describe "InstructorAppraisals", :type => :request do
  describe "GET /instructor_appraisals" do
    it "works! (now write some real specs)" do
      get staff_instructor_appraisals_path
      expect(response.status).to be(200)
    end
  end
end
