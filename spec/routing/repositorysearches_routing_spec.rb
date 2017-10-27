require "rails_helper"

RSpec.describe EqueryReport::RepositorysearchesController, :type => :routing do
  describe "routing" do

#     it "routes to #index" do
#       expect(:get => "equery_report/repositorysearches").to route_to("repositorysearches#index")
#     end

    it "routes to #new" do
      expect(:get => "equery_report/repositorysearches/new").to route_to("equery_report/repositorysearches#new")
    end

    it "routes to #show" do
      expect(:get => "equery_report/repositorysearches/1").to route_to("equery_report/repositorysearches#show", :id => "1")
    end

#     it "routes to #edit" do
#       expect(:get => "equery_report/repositorysearches/1/edit").to route_to("equery_report/repositorysearches#edit", :id => "1")
#     end

    it "routes to #create" do
      expect(:post => "equery_report/repositorysearches").to route_to("equery_report/repositorysearches#create")
    end

    it "routes to #update" do
      expect(:put => "equery_report/repositorysearches/1").to route_to("equery_report/repositorysearches#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "equery_report/repositorysearches/1").to route_to("equery_report/repositorysearches#destroy", :id => "1")
    end

  end
end
