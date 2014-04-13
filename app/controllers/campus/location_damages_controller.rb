class Campus::LocationDamagesController < ApplicationController
  before_action :set_location_damage, only: [:show, :edit, :update, :destroy]
  
  def index
    @damages = LocationDamage.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
    end
  end
  
  def new
    @damage = Location.new(:parent_id => params[:parent_id])
  end
  
  def edit
  end
  
  def create
    @damage = Location.new(location_params)

    respond_to do |format|
      if @damage.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(campus_location_path(@damage)) }
        format.xml  { render :xml => @damage, :status => :created, :location_damage => @damage }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @damage.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @damage.update(location_params)
        format.html {redirect_to campus_location_path(@location), notice: (t 'location.title')+(t 'actions.updated')  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @damage.errors, status: :unprocessable_entity }
      end
    end
  end
    
  
  def show
  end
  
  def destroy
    @damage.destroy
    respond_to do |format|
      format.html { redirect_to campus_locations_url }
      format.json { head :no_content }
    end
  end
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location_damage
      @damage = LocationDamage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_damage_params
      params.require(:location_damage).permit(:location_id, :reported_on, :description, :repaired_on, :document_id, :inspection_on, :user_id, :college_id )
    end
end
