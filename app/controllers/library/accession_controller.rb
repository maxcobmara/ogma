class Library::AccessionsController < ApplicationController
  
  before_action :set_accession, only: [:show, :edit, :update, :destroy]
  
  def available_autocomplete
    #@available_autocomplete = Accession.joins(:librarytransactions).where("librarytransactions.returneddate IS ?", nil).order(:accession_no)
  end
    
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accession
      @accession = Accession.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def accession_params
      params.require(:accession).permit()# <-- insert editable fields here inside here e.g (:date, :name)
    end
  
end