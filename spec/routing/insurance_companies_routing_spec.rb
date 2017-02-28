require "rails_helper"

RSpec.describe InsuranceCompaniesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/insurance_companies").to route_to("insurance_companies#index")
    end

    it "routes to #new" do
      expect(:get => "/insurance_companies/new").to route_to("insurance_companies#new")
    end

    it "routes to #show" do
      expect(:get => "/insurance_companies/1").to route_to("insurance_companies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/insurance_companies/1/edit").to route_to("insurance_companies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/insurance_companies").to route_to("insurance_companies#create")
    end

    it "routes to #update" do
      expect(:put => "/insurance_companies/1").to route_to("insurance_companies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/insurance_companies/1").to route_to("insurance_companies#destroy", :id => "1")
    end

  end
end
