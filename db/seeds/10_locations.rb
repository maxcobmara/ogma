#<Location id: 1, code: "01", name: "Building 01", lclass: 4, typename: nil, allocatable: nil, occupied: nil, staffadmin_id: nil, ancestry: nil, created_at: "2021-03-14 13:17:11", updated_at: "2021-03-14 13:17:11", combo_code: "01", ancestry_depth: 0, status: "_empty">


puts "Creating Main Buildings"

rand(2..9).times.with_index(1) do | n, i |
  Location.create!({id: i, code: "0#{i}", name: "Building 0#{i}", lclass: 1})
end

roots = Location.roots
roots.each do | b |
  puts "configuring building #{b.name}"
  puts "Setting number of rooms per floor"
  rpfftb  = rand(4..8)#rooms per floor for this building


  random_floor_count = rand(1..20)
  if random_floor_count < 6
    room_type = [3,4,5,6,9].sample
  else
    room_type = [1,2,2,2].sample
  end
  if room_type == 2
    b.update_attribute(:lclass, 4)
    puts "setting sex of building"
    sotb    = [20,21].sample
    puts "setting beds in a room"
    biar = rand(2..5)
  end


  puts "creating random_floor_count floors in building #{b.name}"
  random_floor_count.times.with_index(1) do | n, i |
    Location.create!({parent_id: b.id, code: "#{'%02i' % i}", name: "Floor #{'%02i' % i}", lclass: 2, parent_code: b.combo_code})
  end

  #Only do continue if roomtype 1 or 2
  puts "Generating apartments in the floor"
  floors = Location.children_of(b.id)
  floors.each do | f |
    rpfftb.times.with_index(1) do | v, i |
      Location.create!({parent_id: f.id, code: "#{'%02i' % i}", name: "Unit-#{'%02i' % i}", lclass: 3, typename: room_type, parent_code: f.combo_code})
    end
  end

  puts "generate beds in an apartment"
  units = Location.descendants_of(b.id).at_depth(2)
  units.each do | u, i |
    biar.times.with_index(1) do | v, i |
      Location.create!({parent_id: u.id, code: "#{'%02i' % i}", name: "Bed-#{'%02i' % i}", lclass: 3, parent_code: u.combo_code, typename: sotb })
    end
  end


id 133

units = Location.descendants_of(b.id).at_depth(2)
units.each do | u |
  u.update_attributes(lclass: 3, typename: 2 )
end

Location.where(typename: 20).each do | l |
  l.save!
end

end

#reset
Location.roots.each do | r |
  r.destroy
end
