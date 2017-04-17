require 'rails_helper'

RSpec.describe "Repositorysearches", :type => :request do
  describe "GET /repositorysearches" do
    it "works! (now write some real specs)" do
      get repositorysearches_path
      expect(response.status).to be(200)
    end
  end
end
