require "rails_helper"

RSpec.describe VisitorsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/visitors").to route_to("visitors#index")
    end

    it "routes to #new" do
      expect(:get => "/visitors/new").to route_to("visitors#new")
    end

    it "routes to #show" do
      expect(:get => "/visitors/1").to route_to("visitors#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/visitors/1/edit").to route_to("visitors#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/visitors").to route_to("visitors#create")
    end

    it "routes to #update" do
      expect(:put => "/visitors/1").to route_to("visitors#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/visitors/1").to route_to("visitors#destroy", :id => "1")
    end

  end
end
