class Staff::PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]
  
  def index
    @positions = Position.order("combo_code ASC").where("ancestry_depth < ?", 2)
  end
  
  def maklumat_perjawatan
    @positions = Position.order("combo_code ASC")
    respond_to do |format|
      format.pdf do
        pdf = Maklumat_perjawatanPdf.new(@positions, view_context)
        send_data pdf.render, filename: "maklumat_perjawatan-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
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