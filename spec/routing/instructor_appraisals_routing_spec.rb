require "rails_helper"

RSpec.describe Staff::InstructorAppraisalsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/instructor_appraisals").to route_to("instructor_appraisals#index")
    end

    it "routes to #new" do
      expect(:get => "/instructor_appraisals/new").to route_to("instructor_appraisals#new")
    end

    it "routes to #show" do
      expect(:get => "/instructor_appraisals/1").to route_to("instructor_appraisals#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/instructor_appraisals/1/edit").to route_to("instructor_appraisals#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/instructor_appraisals").to route_to("instructor_appraisals#create")
    end

    it "routes to #update" do
      expect(:put => "/instructor_appraisals/1").to route_to("instructor_appraisals#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/instructor_appraisals/1").to route_to("instructor_appraisals#destroy", :id => "1")
    end

  end
end
