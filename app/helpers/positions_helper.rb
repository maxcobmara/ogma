module PositionsHelper

  def nested_groups(positions)
     content_tag(:ul) do
        # NOTE - http://stackoverflow.com/questions/16007384/arranging-ancestry-siblings-by-name-and-integer 
        #Category.siblings_of(params[:id]).order_by(name: :asc)
        positions.map do |position, sub_position|
           #sub_position.sort -> will just sort by ID
           subp=Position.children_of(position).order(combo_code: :asc)
           content_tag(:li, link_to(position_details(position).html_safe, staff_position_path(position)) + nested_groups(subp))
        end.join.html_safe
     end  
  end
  
  def position_details(position)
    "#{position.combo_code} <BR> #{(position.name).split('&').join('<BR>') }     <a href='/staff/positions/new?parent_id=#{position.id}'>(+)</a>"
  end

end
