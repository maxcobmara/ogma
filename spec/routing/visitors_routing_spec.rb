require "rails_helper"

RSpec.describe Campus::VisitorsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "campus/visitors").to route_to("campus/visitors#index")
    end

    it "routes to #new" do
      expect(:get => "campus/visitors/new").to route_to("campus/visitors#new")
    end

    it "routes to #show" do
      expect(:get => "campus/visitors/1").to route_to("campus/visitors#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "campus/visitors/1/edit").to route_to("campus/visitors#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "campus/visitors").to route_to("campus/visitors#create")
    end

    it "routes to #update" do
      expect(:put => "campus/visitors/1").to route_to("campus/visitors#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "campus/visitors/1").to route_to("campus/visitors#destroy", :id => "1")
    end

  end
end
