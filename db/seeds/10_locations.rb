#<Location id: 1, code: "01", name: "Building 01", lclass: 4, typename: nil, allocatable: nil, occupied: nil, staffadmin_id: nil, ancestry: nil, created_at: "2021-03-14 13:17:11", updated_at: "2021-03-14 13:17:11", combo_code: "01", ancestry_depth: 0, status: "_empty">


puts "Creating Main Buildings"

rand(2..9).times.with_index(1) do | n, i |
  Location.create!({id: i, code: "0#{i}", name: "Building 0#{i}", lclass: 4})
end

roots = Location.roots
roots.each do | b |
  rand(4..30).times.with_index(1) do | n, i |
    Location.create!({parent_id: b.id, code: "#{'%02i' % i}", name: "Floor #{'%02i' % i}", lclass: 2, parent_code: b.code})
  end
end

floors = Location.at_depth(1)
