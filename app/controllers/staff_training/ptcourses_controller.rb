class StaffTraining::PtcoursesController < ApplicationController
  
  before_action :set_ptcourse, only: [:show, :edit, :update, :destroy]

  def index
    @ptcourses = Ptcourse.all
  end
  
  def show
  end
  
  
  private
      # Use callbacks to share common setup or constraints between actions.
      def set_ptcourse
        @ptcourse = Ptcourse.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def ptcourse_params
        params.require(:ptcourse).permit(:fiscalstart, :budget, :used_budget, :budget_balance)
      end
  
  
end