class StaffTraining::PtcoursesController < ApplicationController

  def index
    @ptcourses = Ptcourse.all
  end
  
  
end