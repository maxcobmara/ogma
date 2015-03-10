class Campus::LocationDamagesController < ApplicationController
  before_action :set_location_damage, only: [:show, :edit, :update, :destroy]
  
  def index
    @search = LocationDamage.search(params[:q]) 
    @damages = @search.result.joins(:location).where('typename IN(?) or lclass IN(?)',[2,8,6],[4,2]) #4-block, 2-flr, 2-bed f, 8-bed m, 6-room
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
    end
  end
  
  def new
    @locationid = params[:location_id]
    @location = Location.find(params[:location_id])
    @damage = @location.damages.new(params[:location_damage])
    #@damage.save
    #@damage = LocationDamage.new(:location_id => params[:location_id])
  end
  
  def edit
  end
  
  def create
    @locationid = params[:location_damage][:location_id]
    @location = Location.find(@locationid)
    @damage = @location.damages.new(params[:location_damage])
    #@damage = LocationDamage.new(location_damage_params)

    respond_to do |format|
      if @damage.save
        flash[:notice] = (t 'location.damage.title')+(t 'actions.created')
        format.html { redirect_to(campus_location_path(@damage.location)) }
        format.xml  { render :xml => @damage, :status => :created, :location_damage => @damage }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @damage.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    updatetype = params[:location_damage][:update_type]
    respond_to do |format|
      if @damage.update(location_damage_params)
        if updatetype == "update_damage"
          format.html {redirect_to campus_location_damage_path(@damage), notice: (t 'location.damage.title')+(t 'actions.updated')  }
          format.json { head :no_content }
        else
          format.html {redirect_to campus_location_path(@damage.location), notice: (t 'location.title')+(t 'actions.updated')  }
          format.json { head :no_content }
        end
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
      params.require(:location_damage).permit(:update_type, :location_id, :reported_on, :description, :repaired_on, :document_id, :inspection_on, :user_id, :college_id )
    end
end
