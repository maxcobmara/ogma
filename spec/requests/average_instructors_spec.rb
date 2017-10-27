require 'rails_helper'

RSpec.describe "AverageInstructors", :type => :request do
  describe "GET /average_instructors" do
    it "works! (now write some real specs)" do
      get staff_average_instructors_path
      expect(response.status).to be(200)
    end
  end
end
