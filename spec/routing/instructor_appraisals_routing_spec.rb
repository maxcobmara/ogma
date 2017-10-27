require "rails_helper"

RSpec.describe Staff::InstructorAppraisalsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "staff/instructor_appraisals").to route_to("staff/instructor_appraisals#index")
    end

    it "routes to #new" do
      expect(:get => "staff/instructor_appraisals/new").to route_to("staff/instructor_appraisals#new")
    end

    it "routes to #show" do
      expect(:get => "staff/instructor_appraisals/1").to route_to("staff/instructor_appraisals#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "staff/instructor_appraisals/1/edit").to route_to("staff/instructor_appraisals#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "staff/instructor_appraisals").to route_to("staff/instructor_appraisals#create")
    end

    it "routes to #update" do
      expect(:put => "staff/instructor_appraisals/1").to route_to("staff/instructor_appraisals#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "staff/instructor_appraisals/1").to route_to("staff/instructor_appraisals#destroy", :id => "1")
    end

  end
end
