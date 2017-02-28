require "rails_helper"

RSpec.describe InsurancePoliciesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/insurance_policies").to route_to("insurance_policies#index")
    end

    it "routes to #new" do
      expect(:get => "/insurance_policies/new").to route_to("insurance_policies#new")
    end

    it "routes to #show" do
      expect(:get => "/insurance_policies/1").to route_to("insurance_policies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/insurance_policies/1/edit").to route_to("insurance_policies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/insurance_policies").to route_to("insurance_policies#create")
    end

    it "routes to #update" do
      expect(:put => "/insurance_policies/1").to route_to("insurance_policies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/insurance_policies/1").to route_to("insurance_policies#destroy", :id => "1")
    end

  end
end
