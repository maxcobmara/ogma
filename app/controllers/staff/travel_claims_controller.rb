class Staff::TravelClaimsController < ApplicationController
  def index
    #@travel_claims = TravelClaim.all
    @search = TravelClaim.search(params[:q])
    @travel_claims = @search.result

     respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @travel_claims }
    end
  end
end
