class Staff::PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]
  
  def index
    @positions = Position.all
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staff_params
      params.require(:position).permit(:icno, :name, :code, :fileno, :coemail, :cobirthdt, :thumb_id)
    end
end