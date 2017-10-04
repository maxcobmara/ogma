module LocationHelper

  def location_categories
    dropper = (DropDown::LOCATION_CATEGORIES).map {|disp, value| disp }
    I18n.t(dropper).map { |key, value| [ value, key.to_s ] }
  end

  def location_category(location)
    (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == @location.lclass}).map {|disp, value| disp }[0] rescue 0
  end
  
  def set_view_class(location)
    #if (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == location.lclass}).map {|disp, value| disp }[0] == "building"
    if [1,4].include?(location.lclass)
      "col-md-5 building"
    elsif (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == location.lclass}).map {|disp, value| disp }[0] == "floor"
      "col-md-7 floor"
    elsif (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == location.lclass}).map {|disp, value| disp }[0] == "room"
      "room"
    end
  end
  
  def set_sub_class(location)
    if (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == location.lclass}).map {|disp, value| disp }[0] == "building"
      "col-md-5 building"
    elsif (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == location.lclass}).map {|disp, value| disp }[0] == "floor"
      "row floor"
    elsif (DropDown::LOCATION_CATEGORIES.find_all{|disp, value| value == location.lclass}).map {|disp, value| disp }[0] == "room"
      "room img-rounded"
    end
  end
  
  def get_status_link(bed)
    if bed.status.include? "damaged"
      campus_location_path(:id => bed)
    elsif bed.status.include? "empty"
      new_student_tenant_path(:location_id => bed)
    elsif bed.status.include? "occupied"
      student_tenant_path(bed.tenants.last)
    else
      '#'
    end
  end
  
  
end