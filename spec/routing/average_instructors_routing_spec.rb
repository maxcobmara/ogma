require "rails_helper"

RSpec.describe Staff::AverageInstructorsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "staff/average_instructors").to route_to("staff/average_instructors#index")
    end

    it "routes to #new" do
      expect(:get => "staff/average_instructors/new").to route_to("staff/average_instructors#new")
    end

    it "routes to #show" do
      expect(:get => "staff/average_instructors/1").to route_to("staff/average_instructors#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "staff/average_instructors/1/edit").to route_to("staff/average_instructors#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "staff/average_instructors").to route_to("staff/average_instructors#create")
    end

    it "routes to #update" do
      expect(:put => "staff/average_instructors/1").to route_to("staff/average_instructors#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "staff/average_instructors/1").to route_to("staff/average_instructors#destroy", :id => "1")
    end

  end
end
