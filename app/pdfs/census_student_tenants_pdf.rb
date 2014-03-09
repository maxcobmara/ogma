class CensusStudentTenantsPdf < Prawn::Document
  include StudentsHelper
  def initialize(residentials, current_tenants, current_user)
    super({top_margin: 50, page_size: 'A4', page_layout: :landscape })
    @residentials = residentials
    @current_tenants = current_tenants
    @current_user = current_user
    @residentials.map do |building|
      building.children.map do |floor|  
        @rooms = floor.descendants.where(typename: [2,8])
        @this_floor = @current_tenants.where(location_id: @rooms)
      end
    end
    font "Times-Roman"
    text "Census", :align => :right, :size => 16, :style => :bold
    move_down 20
    text "SENARAI PENGHUNI TINGKAT", :align => :center, :size => 14, :style => :bold
    resident_list
  end
  
  def resident_list
    move_down 5
    
    table line_item_rows do
    end
  end
  
  def line_item_rows
    @this_floor.map do |room|
      ["#{room.location.combo_code}", ""]
    end
  end
    
end
