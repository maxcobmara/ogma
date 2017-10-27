require 'rails_helper'

RSpec.describe "ExamTemplates", :type => :request do
  describe "GET /exam_templates" do
    it "works! (now write some real specs)" do
#       get exam_templates_path
      get exam_exams_path
      expect(response.status).to be(200)
    end
  end
end
