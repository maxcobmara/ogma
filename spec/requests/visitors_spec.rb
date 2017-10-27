require 'rails_helper'

RSpec.describe "Visitors", :type => :request do
  describe "GET /visitors" do
    it "works! (now write some real specs)" do
      get campus_visitors_path
      expect(response.status).to be(200)
    end
  end
end
