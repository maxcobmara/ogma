class Staff::TravelClaimsController < ApplicationController
  def index
    @travel_claims = TravelClaim.all

     respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @travel_claims }
    end
  end
end
