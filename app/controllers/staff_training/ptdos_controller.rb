class StaffTraining::PtdosController < ApplicationController
  before_action :set_ptdo, only: [:show, :edit, :update, :destroy]
  
  def index
  end
  
  private
      # Use callbacks to share common setup or constraints between actions.
      def set_ptdo
        @ptdo = Ptdo.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def ptdo_params
        params.require(:ptdo).permit(:fiscalstart, :budget, :used_budget, :budget_balance)
      end
  
  
  
end