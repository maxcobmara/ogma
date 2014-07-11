require 'spec_helper'

describe "exam pages" do
  before  { @exam = FactoryGirl.create(:exam) }
  subject { page }

  #-Below-hold first - error arise (requires logged-in user)
  #ActiveRecord::RecordNotFound: Couldn't find User with id=11 # ./app/controllers/exam/exams_controller.rb:8:in `index'
  
  #describe "Exam Index page" do
    #before { visit exam_exams_path }

    #it { should have_selector('h1', text: 'Examination Development')}
    #it { should have_link("New",    href: new_exam_path + "?locale=en")}
    #it { should have_selector(:link_or_button, "Search")}    
    #it { should have_selector(:link_or_button, "Print")}
    #it { should have_selector('th', text: 'Subject') }
    #it { should have_selector('th', text: 'Topic') }
    #it { should have_selector('th', text: 'Type')}
    #it { should have_selector('th', text: 'Question')}
    #it { should have_selector('th', text: 'Answer')}
    #it { should have_selector('th', text: 'Marks')}
    #it { should have_selector('th', text: 'Category')}
    #it { should have_selector('th', text: 'Difficulty')}
    #it { should have_selector('th', text: 'Status')}
    #it { should have_selector('th', text: 'Created By')}
    #it { should have_link(@exam.id), href: exam_path(@exam) + "?locale=en" }
    #end
  
  #-Below-hold first - error arise (requires logged-in user)
  #NoMethodError:undefined method `code' for nil:NilClass # ./app/controllers/exam/exams_controller.rb:48:in `show'
  
  #describe "Exam Show page" do
    #before { visit exam_exam_path(@exam) }
 
    #it {should have_selector('h1', text: 'Exam Question Details')}
    #it { should have_selector(:link_or_button, "Question Details")}    
    #it { should have_selector(:link_or_button, "Back")}    
    #it { should have_selector(:link_or_button, "Edit")}    
    #it { should have_selector(:link_or_button, "Destroy")}   
    #end
  
  #-Below-hold first - error arise (requires logged-in user)
  #NoMethodError:undefined method `staff' for nil:NilClass # ./app/controllers/exam/exams_controller.rb:93:in `edit'

  #describe "Exam Edit page" do
    #before { visit edit_exam_exam_path(@exam)}
    #it {should have_selector('h1', text: "Edit Exam Question")}
    #it { should have_selector(:link_or_button, "Back")}    
    #it { should have_selector(:link_or_button, "Update")}  
    #end  

end