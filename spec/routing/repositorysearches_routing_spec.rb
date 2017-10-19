require "rails_helper"

RSpec.describe EqueryReport::RepositorysearchesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/repositorysearches").to route_to("repositorysearches#index")
    end

    it "routes to #new" do
      expect(:get => "/repositorysearches/new").to route_to("repositorysearches#new")
    end

    it "routes to #show" do
      expect(:get => "/repositorysearches/1").to route_to("repositorysearches#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/repositorysearches/1/edit").to route_to("repositorysearches#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/repositorysearches").to route_to("repositorysearches#create")
    end

    it "routes to #update" do
      expect(:put => "/repositorysearches/1").to route_to("repositorysearches#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/repositorysearches/1").to route_to("repositorysearches#destroy", :id => "1")
    end

  end
end
